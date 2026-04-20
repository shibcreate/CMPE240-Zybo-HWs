/************************************************************************/
/*  stereo_to_mono.v                                                    */
/*  AXI4-Stream Stereo-to-Mono Mixer                                   */
/*                                                                      */
/*  Takes interleaved stereo I2S stream [L][R][L][R]...                 */
/*  Outputs mono = (L+R)>>1 on both L and R slots                      */
/*                                                                      */
/*  24-bit audio in 32-bit AXI-Stream words (upper 8 bits zero)        */
/*                                                                      */
/*  CMPE240 Spring 2026                                                */
/************************************************************************/

`timescale 1ns / 1ps

module stereo_to_mono (
    input  wire        aclk,
    input  wire        aresetn,

    // AXI4-Stream Slave (from I2S IP)
    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output reg         s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire [3:0]  s_axis_tkeep,

    // AXI4-Stream Master (to DMA)
    output reg  [31:0] m_axis_tdata,
    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         m_axis_tlast,
    output reg  [3:0]  m_axis_tkeep
);

    // State machine
    localparam S_WAIT_LEFT  = 2'd0;   // Accept left sample
    localparam S_WAIT_RIGHT = 2'd1;   // Accept right sample, compute mono
    localparam S_OUT_LEFT   = 2'd2;   // Output mono as left channel
    localparam S_OUT_RIGHT  = 2'd3;   // Output mono as right channel

    reg [1:0]  state;
    reg [23:0] left_sample;           // Stored left sample (24-bit)
    reg [23:0] mono_val;              // Computed mono value
    reg        saved_tlast;           // TLAST from the right sample
    reg [3:0]  saved_tkeep;           // TKEEP from input

    // Sign-extend 24-bit to 25-bit for overflow-safe addition
    wire signed [24:0] left_ext  = {{2{left_sample[23]}}, left_sample[22:0]};
    wire signed [24:0] right_ext = {{2{s_axis_tdata[23]}}, s_axis_tdata[22:0]};
    wire signed [24:0] mono_sum  = left_ext + right_ext;
    wire        [23:0] mono_avg  = mono_sum[24:1]; // Arithmetic right shift by 1

    always @(posedge aclk) begin
        if (!aresetn) begin
            state        <= S_WAIT_LEFT;
            s_axis_tready <= 1'b1;
            m_axis_tvalid <= 1'b0;
            m_axis_tdata  <= 32'd0;
            m_axis_tlast  <= 1'b0;
            m_axis_tkeep  <= 4'hF;
            left_sample   <= 24'd0;
            mono_val      <= 24'd0;
            saved_tlast   <= 1'b0;
            saved_tkeep   <= 4'hF;
        end else begin
            case (state)

                S_WAIT_LEFT: begin
                    s_axis_tready <= 1'b1;
                    m_axis_tvalid <= 1'b0;
                    if (s_axis_tvalid && s_axis_tready) begin
                        left_sample <= s_axis_tdata[23:0];
                        saved_tkeep <= s_axis_tkeep;
                        state       <= S_WAIT_RIGHT;
                    end
                end

                S_WAIT_RIGHT: begin
                    s_axis_tready <= 1'b1;
                    m_axis_tvalid <= 1'b0;
                    if (s_axis_tvalid && s_axis_tready) begin
                        // Compute mono average
                        mono_val    <= mono_avg;
                        saved_tlast <= s_axis_tlast;
                        s_axis_tready <= 1'b0;  // Stop accepting input
                        state       <= S_OUT_LEFT;
                    end
                end

                S_OUT_LEFT: begin
                    s_axis_tready <= 1'b0;
                    m_axis_tvalid <= 1'b1;
                    m_axis_tdata  <= {8'd0, mono_val};
                    m_axis_tlast  <= 1'b0;       // Not last (right still coming)
                    m_axis_tkeep  <= saved_tkeep;
                    if (m_axis_tready) begin
                        state <= S_OUT_RIGHT;
                    end
                end

                S_OUT_RIGHT: begin
                    s_axis_tready <= 1'b0;
                    m_axis_tvalid <= 1'b1;
                    m_axis_tdata  <= {8'd0, mono_val};
                    m_axis_tlast  <= saved_tlast; // Forward TLAST from input
                    m_axis_tkeep  <= saved_tkeep;
                    if (m_axis_tready) begin
                        m_axis_tvalid <= 1'b0;
                        s_axis_tready <= 1'b1;
                        state <= S_WAIT_LEFT;
                    end
                end

            endcase
        end
    end

endmodule
