// stereo_to_mono.v
// Mixes interleaved stereo I2S stream into mono (L+R)/2
// CMPE240 Spring 2026

`timescale 1ns / 1ps

module stereo_to_mono (
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

    localparam S_WAIT_LEFT  = 2'd0;
    localparam S_WAIT_RIGHT = 2'd1;
    localparam S_OUT_LEFT   = 2'd2;
    localparam S_OUT_RIGHT  = 2'd3;

    reg [1:0]  state;
    reg [23:0] left_sample;
    reg [23:0] mono_val;
    reg        saved_tlast;
    reg [3:0]  saved_tkeep;

    // sign-extend 24-bit to 25-bit so the addition doesn't overflow
    wire signed [24:0] left_ext  = {{2{left_sample[23]}}, left_sample[22:0]};
    wire signed [24:0] right_ext = {{2{s_axis_tdata[23]}}, s_axis_tdata[22:0]};
    wire signed [24:0] mono_sum  = left_ext + right_ext;
    wire        [23:0] mono_avg  = mono_sum[24:1];

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
                        mono_val    <= mono_avg;
                        saved_tlast <= s_axis_tlast;
                        s_axis_tready <= 1'b0;
                        state       <= S_OUT_LEFT;
                    end
                end

                S_OUT_LEFT: begin
                    s_axis_tready <= 1'b0;
                    m_axis_tvalid <= 1'b1;
                    m_axis_tdata  <= {8'd0, mono_val};
                    m_axis_tlast  <= 1'b0;
                    m_axis_tkeep  <= saved_tkeep;
                    if (m_axis_tready) begin
                        state <= S_OUT_RIGHT;
                    end
                end

                S_OUT_RIGHT: begin
                    s_axis_tready <= 1'b0;
                    m_axis_tvalid <= 1'b1;
                    m_axis_tdata  <= {8'd0, mono_val};
                    m_axis_tlast  <= saved_tlast;
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
