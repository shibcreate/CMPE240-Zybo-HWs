// axis_broadcast.v
// 1-to-2 AXI-Stream splitter, input advances only when both outputs accept
// CMPE240 Spring 2026

`timescale 1ns / 1ps

module axis_broadcast (
    input  wire        aclk,
    input  wire        aresetn,

    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire [3:0]  s_axis_tkeep,

    output wire [31:0] m0_axis_tdata,
    output wire        m0_axis_tvalid,
    input  wire        m0_axis_tready,
    output wire        m0_axis_tlast,
    output wire [3:0]  m0_axis_tkeep,

    output wire [31:0] m1_axis_tdata,
    output wire        m1_axis_tvalid,
    input  wire        m1_axis_tready,
    output wire        m1_axis_tlast,
    output wire [3:0]  m1_axis_tkeep
);

    reg m0_done;
    reg m1_done;

    wire m0_active = ~m0_done;
    wire m1_active = ~m1_done;

    wire both_done = (m0_done | (m0_active & m0_axis_tready))
                   & (m1_done | (m1_active & m1_axis_tready));
    assign s_axis_tready = both_done;

    assign m0_axis_tdata = s_axis_tdata;
    assign m1_axis_tdata = s_axis_tdata;
    assign m0_axis_tlast = s_axis_tlast;
    assign m1_axis_tlast = s_axis_tlast;
    assign m0_axis_tkeep = s_axis_tkeep;
    assign m1_axis_tkeep = s_axis_tkeep;

    assign m0_axis_tvalid = s_axis_tvalid & m0_active;
    assign m1_axis_tvalid = s_axis_tvalid & m1_active;

    always @(posedge aclk) begin
        if (!aresetn) begin
            m0_done <= 1'b0;
            m1_done <= 1'b0;
        end else begin
            if (both_done && s_axis_tvalid) begin
                m0_done <= 1'b0;
                m1_done <= 1'b0;
            end else begin
                if (m0_axis_tvalid && m0_axis_tready)
                    m0_done <= 1'b1;
                if (m1_axis_tvalid && m1_axis_tready)
                    m1_done <= 1'b1;
            end
        end
    end

endmodule
