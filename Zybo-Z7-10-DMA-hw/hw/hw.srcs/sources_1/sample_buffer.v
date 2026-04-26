// sample_buffer.v
// Collects 256 mono samples (skipping duplicate R channel) then bursts them out for FFT
// CMPE240 Spring 2026

`timescale 1ns / 1ps

module sample_buffer #(
    parameter FRAME_SIZE = 256
)(
    input  wire        aclk,
    input  wire        aresetn,

    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output reg         s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire [3:0]  s_axis_tkeep,

    output reg  [31:0] m_axis_tdata,
    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         m_axis_tlast,
    output reg  [3:0]  m_axis_tkeep
);

    localparam S_FILL  = 2'd0;
    localparam S_DRAIN = 2'd1;

    reg [1:0]  state;
    reg        lr_toggle;  // 0=left (keep), 1=right (skip)
    reg [8:0]  wr_count;
    reg [8:0]  rd_count;

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
                            frame_buf[wr_count[7:0]] <= s_axis_tdata;
                            wr_count <= wr_count + 1'b1;

                            // frame full, start outputting
                            if (wr_count == FRAME_SIZE - 1) begin
                                state         <= S_DRAIN;
                                s_axis_tready <= 1'b0;
                                wr_count      <= 9'd0;
                                m_axis_tdata  <= frame_buf[0];
                                m_axis_tvalid <= 1'b1;
                                m_axis_tlast  <= (FRAME_SIZE == 1) ? 1'b1 : 1'b0;
                                m_axis_tkeep  <= 4'hF;
                                rd_count      <= 9'd1;
                            end
                        end
                        lr_toggle <= ~lr_toggle;
                    end
                end

                S_DRAIN: begin
                    s_axis_tready <= 1'b0;

                    if (m_axis_tready && m_axis_tvalid) begin
                        if (rd_count == FRAME_SIZE) begin
                            state         <= S_FILL;
                            rd_count      <= 9'd0;
                            m_axis_tvalid <= 1'b0;
                            m_axis_tlast  <= 1'b0;
                            s_axis_tready <= 1'b1;
                        end else begin
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
