// real_to_complex.v
// Converts 24-bit real audio to 32-bit complex (imag=0, real=top 16 bits) for FFT IP
// CMPE240 Spring 2026

`timescale 1ns / 1ps

module real_to_complex (
    input  wire        aclk,
    input  wire        aresetn,

    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire [3:0]  s_axis_tkeep,

    output wire [31:0] m_axis_tdata,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready,
    output wire        m_axis_tlast,
    output wire [3:0]  m_axis_tkeep
);

    // {16'b imag, 16'b real} - take bits [23:8] to keep sign bit
    assign m_axis_tdata  = {16'd0, s_axis_tdata[23:8]};
    assign m_axis_tvalid = s_axis_tvalid;
    assign s_axis_tready = m_axis_tready;
    assign m_axis_tlast  = s_axis_tlast;
    assign m_axis_tkeep  = 4'hF;

endmodule
