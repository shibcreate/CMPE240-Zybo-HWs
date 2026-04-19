/************************************************************************/
/*  stereo_to_mono_tb.v                                                 */
/*  Testbench for stereo_to_mono mixer                                  */
/*                                                                      */
/*  Run in Vivado: Flow Navigator -> Simulation -> Run Behavioral Sim   */
/************************************************************************/

`timescale 1ns / 1ps

module stereo_to_mono_tb;

    reg        aclk;
    reg        aresetn;

    // Slave (input) side
    reg  [31:0] s_axis_tdata;
    reg         s_axis_tvalid;
    wire        s_axis_tready;
    reg         s_axis_tlast;
    reg  [3:0]  s_axis_tkeep;

    // Master (output) side
    wire [31:0] m_axis_tdata;
    wire        m_axis_tvalid;
    reg         m_axis_tready;
    wire        m_axis_tlast;
    wire [3:0]  m_axis_tkeep;

    // DUT
    stereo_to_mono uut (
        .aclk           (aclk),
        .aresetn        (aresetn),
        .s_axis_tdata   (s_axis_tdata),
        .s_axis_tvalid  (s_axis_tvalid),
        .s_axis_tready  (s_axis_tready),
        .s_axis_tlast   (s_axis_tlast),
        .s_axis_tkeep   (s_axis_tkeep),
        .m_axis_tdata   (m_axis_tdata),
        .m_axis_tvalid  (m_axis_tvalid),
        .m_axis_tready  (m_axis_tready),
        .m_axis_tlast   (m_axis_tlast),
        .m_axis_tkeep   (m_axis_tkeep)
    );

    // 100MHz clock
    always #5 aclk = ~aclk;

    // Task: send one sample on slave interface
    task send_sample(input [23:0] data, input last);
        begin
            @(posedge aclk);
            s_axis_tdata  <= {8'd0, data};
            s_axis_tvalid <= 1'b1;
            s_axis_tlast  <= last;
            s_axis_tkeep  <= 4'hF;
            // Wait for handshake
            @(posedge aclk);
            while (!s_axis_tready) @(posedge aclk);
            // Data accepted on this edge
            @(posedge aclk);
            s_axis_tvalid <= 1'b0;
            s_axis_tlast  <= 1'b0;
        end
    endtask

    // Task: receive one sample from master interface
    task receive_sample(output [23:0] data, output last);
        begin
            while (!m_axis_tvalid) @(posedge aclk);
            data = m_axis_tdata[23:0];
            last = m_axis_tlast;
            @(posedge aclk);
        end
    endtask

    // Sign-extend helper for display
    function signed [23:0] se24(input [23:0] val);
        se24 = val;
    endfunction

    reg [23:0] out_data;
    reg        out_last;

    initial begin
        aclk          = 0;
        aresetn       = 0;
        s_axis_tdata  = 0;
        s_axis_tvalid = 0;
        s_axis_tlast  = 0;
        s_axis_tkeep  = 4'hF;
        m_axis_tready = 1;  // DMA always ready

        // Reset
        #100;
        aresetn = 1;
        #20;

        $display("=== Test 1: Equal L and R (100, 100) -> mono = 100 ===");
        send_sample(24'd100, 1'b0);   // Left
        send_sample(24'd100, 1'b0);   // Right
        receive_sample(out_data, out_last);
        $display("  L out: %0d (expect 100)", out_data);
        receive_sample(out_data, out_last);
        $display("  R out: %0d (expect 100)", out_data);

        #40;
        $display("=== Test 2: Different L and R (200, 100) -> mono = 150 ===");
        send_sample(24'd200, 1'b0);   // Left
        send_sample(24'd100, 1'b0);   // Right
        receive_sample(out_data, out_last);
        $display("  L out: %0d (expect 150)", out_data);
        receive_sample(out_data, out_last);
        $display("  R out: %0d (expect 150)", out_data);

        #40;
        $display("=== Test 3: Negative sample (-1000, 1000) -> mono = 0 ===");
        // -1000 in 24-bit two's complement = 0xFFFC18
        send_sample(24'hFFFC18, 1'b0);  // Left = -1000
        send_sample(24'h0003E8, 1'b0);  // Right = +1000
        receive_sample(out_data, out_last);
        $display("  L out: %0d (expect 0, got 0x%06h)", se24(out_data), out_data);
        receive_sample(out_data, out_last);
        $display("  R out: %0d (expect 0, got 0x%06h)", se24(out_data), out_data);

        #40;
        $display("=== Test 4: TLAST passthrough (last pair in burst) ===");
        send_sample(24'd500, 1'b0);    // Left, not last
        send_sample(24'd500, 1'b1);    // Right, TLAST=1
        receive_sample(out_data, out_last);
        $display("  L out: %0d, tlast=%0b (expect 500, 0)", out_data, out_last);
        receive_sample(out_data, out_last);
        $display("  R out: %0d, tlast=%0b (expect 500, 1)", out_data, out_last);

        #40;
        $display("=== Test 5: Max positive + max positive ===");
        // Max 24-bit positive = 0x7FFFFF = 8388607
        send_sample(24'h7FFFFF, 1'b0);
        send_sample(24'h7FFFFF, 1'b0);
        receive_sample(out_data, out_last);
        $display("  L out: 0x%06h (expect 0x7FFFFF)", out_data);
        receive_sample(out_data, out_last);
        $display("  R out: 0x%06h (expect 0x7FFFFF)", out_data);

        #100;
        $display("=== All tests complete ===");
        $finish;
    end

endmodule
