/************************************************************************/
/*  axis_broadcast.v                                                    */
/*  AXI4-Stream 1-to-2 Broadcast Splitter                              */
/*                                                                      */
/*  Forwards every input sample to both outputs.                        */
/*  Input only advances when BOTH outputs have accepted.                */
/*                                                                      */
/*  CMPE240 Spring 2026                                                */
/************************************************************************/

`timescale 1ns / 1ps

module axis_broadcast (
    input  wire        aclk,
    input  wire        aresetn,

    // AXI4-Stream Slave (input)
    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire [3:0]  s_axis_tkeep,

    // AXI4-Stream Master 0 (to sample_buffer → FFT)
    output wire [31:0] m0_axis_tdata,
    output wire        m0_axis_tvalid,
    input  wire        m0_axis_tready,
    output wire        m0_axis_tlast,
    output wire [3:0]  m0_axis_tkeep,

    // AXI4-Stream Master 1 (to I2S TX)
    output wire [31:0] m1_axis_tdata,
    output wire        m1_axis_tvalid,
    input  wire        m1_axis_tready,
    output wire        m1_axis_tlast,
    output wire [3:0]  m1_axis_tkeep
);

    // Track which outputs have accepted the current sample
    reg m0_done;
    reg m1_done;

    // An output is "active" if it hasn't accepted yet this cycle
    wire m0_active = ~m0_done;
    wire m1_active = ~m1_done;

    // Input is ready only when both outputs have accepted
    wire both_done = (m0_done | (m0_active & m0_axis_tready))
                   & (m1_done | (m1_active & m1_axis_tready));
    assign s_axis_tready = both_done;

    // Data passes straight through
    assign m0_axis_tdata = s_axis_tdata;
    assign m1_axis_tdata = s_axis_tdata;
    assign m0_axis_tlast = s_axis_tlast;
    assign m1_axis_tlast = s_axis_tlast;
    assign m0_axis_tkeep = s_axis_tkeep;
    assign m1_axis_tkeep = s_axis_tkeep;

    // Valid only if input is valid and this output hasn't accepted yet
    assign m0_axis_tvalid = s_axis_tvalid & m0_active;
    assign m1_axis_tvalid = s_axis_tvalid & m1_active;

    always @(posedge aclk) begin
        if (!aresetn) begin
            m0_done <= 1'b0;
            m1_done <= 1'b0;
        end else begin
            if (both_done && s_axis_tvalid) begin
                // Both done, advance to next sample
                m0_done <= 1'b0;
                m1_done <= 1'b0;
            end else begin
                // Latch individual completions
                if (m0_axis_tvalid && m0_axis_tready)
                    m0_done <= 1'b1;
                if (m1_axis_tvalid && m1_axis_tready)
                    m1_done <= 1'b1;
            end
        end
    end

endmodule
