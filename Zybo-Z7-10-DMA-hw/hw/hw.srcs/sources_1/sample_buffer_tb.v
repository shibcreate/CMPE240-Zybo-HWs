/************************************************************************/
/*  sample_buffer_tb.v                                                  */
/*  Testbench for sample_buffer                                         */
/************************************************************************/

`timescale 1ns / 1ps

module sample_buffer_tb;

    reg        aclk;
    reg        aresetn;

    reg  [31:0] s_axis_tdata;
    reg         s_axis_tvalid;
    wire        s_axis_tready;
    reg         s_axis_tlast;
    reg  [3:0]  s_axis_tkeep;

    wire [31:0] m_axis_tdata;
    wire        m_axis_tvalid;
    reg         m_axis_tready;
    wire        m_axis_tlast;
    wire [3:0]  m_axis_tkeep;

    sample_buffer #(.FRAME_SIZE(8)) uut (
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

    integer errors;
    integer rx_count;
    reg [31:0] rx_buf  [0:7];
    reg        rx_last [0:7];

    // Sender: drives s_axis, waits for handshake each sample
    task automatic send_pair(input [31:0] left_val, input [31:0] right_val);
        begin
            // Drive LEFT
            @(negedge aclk);
            s_axis_tdata  = left_val;
            s_axis_tvalid = 1;
            s_axis_tkeep  = 4'hF;
            s_axis_tlast  = 0;
            @(posedge aclk);
            while (!s_axis_tready) @(posedge aclk);
            // LEFT accepted at this posedge

            // Drive RIGHT
            @(negedge aclk);
            s_axis_tdata  = right_val;
            s_axis_tvalid = 1;
            @(posedge aclk);
            while (!s_axis_tready) @(posedge aclk);
            // RIGHT accepted at this posedge

            // Deassert valid
            @(negedge aclk);
            s_axis_tvalid = 0;
        end
    endtask

    // Receiver: captures rx_count samples
    task automatic recv_frame(input integer count);
        integer timeout;
        begin
            rx_count = 0;
            timeout = 0;
            while (rx_count < count && timeout < 100000) begin
                @(posedge aclk);
                if (m_axis_tvalid && m_axis_tready) begin
                    rx_buf[rx_count]  = m_axis_tdata;
                    rx_last[rx_count] = m_axis_tlast;
                    rx_count = rx_count + 1;
                    timeout = 0;
                end else begin
                    timeout = timeout + 1;
                end
            end
            if (timeout >= 100000)
                $display("  TIMEOUT: only received %0d / %0d samples", rx_count, count);
        end
    endtask

    integer i;

    initial begin
        aclk          = 0;
        aresetn       = 0;
        s_axis_tdata  = 0;
        s_axis_tvalid = 0;
        s_axis_tlast  = 0;
        s_axis_tkeep  = 4'hF;
        m_axis_tready = 1;
        errors        = 0;

        #100;
        aresetn = 1;
        #20;

        // ============================================================
        // Test 1: Small frame (FRAME_SIZE=8)
        // Send 8 L/R pairs, L = 10..17, R = 0xDEAD
        // ============================================================
        $display("=== Test 1: 8 L/R pairs -> 8 mono output ===");

        // Send and receive in parallel
        fork
            begin : sender
                for (i = 0; i < 8; i = i + 1)
                    send_pair(10 + i, 32'h0000DEAD);
            end
            begin : receiver
                recv_frame(8);
            end
        join

        $display("  Received %0d samples", rx_count);

        // Verify values
        for (i = 0; i < 8; i = i + 1) begin
            if (rx_buf[i] !== 10 + i) begin
                $display("  ERROR sample %0d: got 0x%08h, expected 0x%08h", i, rx_buf[i], 10 + i);
                errors = errors + 1;
            end
        end

        // Verify TLAST
        for (i = 0; i < 7; i = i + 1) begin
            if (rx_last[i] !== 1'b0) begin
                $display("  ERROR: unexpected TLAST on sample %0d", i);
                errors = errors + 1;
            end
        end
        if (rx_last[7] !== 1'b1) begin
            $display("  ERROR: TLAST not set on last sample!");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("  Test 1 PASSED");

        // ============================================================
        // Test 2: Back-to-back frame
        // ============================================================
        $display("=== Test 2: Back-to-back frame (values 100..107) ===");

        fork
            begin : sender2
                for (i = 0; i < 8; i = i + 1)
                    send_pair(100 + i, 32'h0000BEEF);
            end
            begin : receiver2
                recv_frame(8);
            end
        join

        $display("  Received %0d samples", rx_count);
        for (i = 0; i < 8; i = i + 1) begin
            if (rx_buf[i] !== 100 + i) begin
                $display("  ERROR sample %0d: got %0d, expected %0d", i, rx_buf[i], 100+i);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("  Test 2 PASSED");

        #200;
        if (errors == 0)
            $display("=== ALL TESTS PASSED ===");
        else
            $display("=== %0d ERRORS DETECTED ===", errors);
        $finish;
    end

endmodule
