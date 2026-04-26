// fft_config.v
// Drives Xilinx FFT config channel: forward transform, scale /4 per stage pair (/256 total)
// CMPE240 Spring 2026

`timescale 1ns / 1ps

module fft_config (
    input  wire        aclk,
    input  wire        aresetn,

    output wire [15:0] m_axis_tdata,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready
);

    // bit0=FWD, bits[8:1]=scale schedule {10,10,10,10} = 0x0155
    assign m_axis_tdata  = 16'h0155;
    assign m_axis_tvalid = 1'b1;

endmodule
