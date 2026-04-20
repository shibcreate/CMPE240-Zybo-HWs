/************************************************************************/
/*  sample_buffer.v                                                     */
/*  AXI4-Stream 256-Sample Frame Buffer                                 */
/*                                                                      */
/*  Accepts interleaved mono L/R stream from stereo_to_mono,            */
/*  keeps only one channel per pair (since L==R after mono mix),        */
/*  accumulates FRAME_SIZE unique samples, then bursts the full frame   */
/*  out on master AXI4-Stream with TLAST on the last sample.            */
/*                                                                      */
/*  CMPE240 Spring 2026 - Amina Akhtar                                 */
/************************************************************************/

`timescale 1ns / 1ps

module sample_buffer #(
    parameter FRAME_SIZE = 256   // Samples per FFT frame
)(
    input  wire        aclk,
    input  wire        aresetn,

    // AXI4-Stream Slave (from stereo_to_mono - interleaved L/R)
    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output reg         s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire [3:0]  s_axis_tkeep,

    // AXI4-Stream Master (to FFT IP - FRAME_SIZE-sample frames)
    output reg  [31:0] m_axis_tdata,
    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         m_axis_tlast,
    output reg  [3:0]  m_axis_tkeep
);

    localparam S_FILL  = 2'd0;   // Accept and store L samples
    localparam S_DRAIN = 2'd1;   // Output frame, advance on handshake

    reg [1:0]  state;
    reg        lr_toggle;           // 0 = left (keep), 1 = right (skip)
    reg [8:0]  wr_count;            // Write counter (0..FRAME_SIZE-1)
    reg [8:0]  rd_count;            // Read counter - points to NEXT sample to load

    // BRAM
    (* ram_style = "block" *) reg [31:0] frame_buf [0:FRAME_SIZE-1];

    always @(posedge aclk) begin
        if (!aresetn) begin
            state         <= S_FILL;
            lr_toggle     <= 1'b0;
            wr_count      <= 9'd0;
            rd_count      <= 9'd0;
            s_axis_tready <= 1'b1;
            m_axis_tvalid <= 1'b0;
            m_axis_tdata  <= 32'd0;
            m_axis_tlast  <= 1'b0;
            m_axis_tkeep  <= 4'hF;
        end else begin
            case (state)

                S_FILL: begin
                    m_axis_tvalid <= 1'b0;
                    s_axis_tready <= 1'b1;

                    if (s_axis_tvalid && s_axis_tready) begin
                        if (lr_toggle == 1'b0) begin
                            // Left sample: store it
                            frame_buf[wr_count[7:0]] <= s_axis_tdata;
                            wr_count <= wr_count + 1'b1;

                            if (wr_count == FRAME_SIZE - 1) begin
                                // Frame complete, switch to drain
                                state         <= S_DRAIN;
                                s_axis_tready <= 1'b0;
                                wr_count      <= 9'd0;
                                // Pre-load first sample onto output
                                m_axis_tdata  <= frame_buf[0];
                                m_axis_tvalid <= 1'b1;
                                m_axis_tlast  <= (FRAME_SIZE == 1) ? 1'b1 : 1'b0;
                                m_axis_tkeep  <= 4'hF;
                                rd_count      <= 9'd1; // Next to load is index 1
                            end
                        end
                        lr_toggle <= ~lr_toggle;
                    end
                end

                S_DRAIN: begin
                    s_axis_tready <= 1'b0;

                    if (m_axis_tready && m_axis_tvalid) begin
                        // Current sample accepted by downstream
                        if (rd_count == FRAME_SIZE) begin
                            // All samples sent, back to fill
                            state         <= S_FILL;
                            rd_count      <= 9'd0;
                            m_axis_tvalid <= 1'b0;
                            m_axis_tlast  <= 1'b0;
                            s_axis_tready <= 1'b1;
                        end else begin
                            // Load next sample
                            m_axis_tdata  <= frame_buf[rd_count[7:0]];
                            m_axis_tlast  <= (rd_count == FRAME_SIZE - 1) ? 1'b1 : 1'b0;
                            rd_count      <= rd_count + 1'b1;
                        end
                    end
                end

            endcase
        end
    end

endmodule
