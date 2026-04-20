/************************************************************************/
/*  fft_config.v                                                        */
/*  Drives Xilinx FFT LogiCORE config channel                          */
/*                                                                      */
/*  Sends config: forward FFT, scale-by-4 at each stage pair.          */
/*  Total scaling = /256 (prevents overflow for 256-point FFT).         */
/*                                                                      */
/*  Config TDATA[15:0] layout (pipelined streaming, fixed length):     */
/*    Bit 0     : FWD/INV = 1 (forward)                                */
/*    Bits [8:1]: SCALE_SCH = 4 pairs x 2'b10 (/4 each)               */
/*    Bits[15:9]: unused                                                */
/*                                                                      */
/*  CMPE240 Spring 2026                                                */
/************************************************************************/

`timescale 1ns / 1ps

module fft_config (
    input  wire        aclk,
    input  wire        aresetn,

    // AXI4-Stream Master → FFT s_axis_config
    output wire [15:0] m_axis_tdata,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready
);

    // Config word: FWD=1, scaling = {10,10,10,10} = /4 per pair, /256 total
    // Bit layout: {7'b0, 2'b10, 2'b10, 2'b10, 2'b10, 1'b1} = 16'h0155
    assign m_axis_tdata  = 16'h0155;
    assign m_axis_tvalid = 1'b1;  // Always valid, FFT reads when needed

endmodule
