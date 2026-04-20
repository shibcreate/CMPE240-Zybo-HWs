/************************************************************************/
/*  real_to_complex.v                                                   */
/*  Converts real audio samples to complex format for FFT IP            */
/*                                                                      */
/*  Input:  32-bit AXI-Stream (24-bit audio in [23:0])                 */
/*  Output: 32-bit AXI-Stream (16-bit imag [31:16] + 16-bit real [15:0])*/
/*                                                                      */
/*  Takes top 16 bits of 24-bit audio as real, sets imaginary = 0.     */
/*                                                                      */
/*  CMPE240 Spring 2026                                                */
/************************************************************************/

`timescale 1ns / 1ps

module real_to_complex (
    input  wire        aclk,
    input  wire        aresetn,

    // AXI4-Stream Slave (from sample_buffer - 24-bit audio in 32-bit)
    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire [3:0]  s_axis_tkeep,

    // AXI4-Stream Master (to FFT - {imag[15:0], real[15:0]})
    output wire [31:0] m_axis_tdata,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready,
    output wire        m_axis_tlast,
    output wire [3:0]  m_axis_tkeep
);

    // Combinational pass-through with format conversion
    // Take bits [23:8] of 24-bit audio as 16-bit real (preserves sign bit)
    // Set imaginary = 0
    assign m_axis_tdata  = {16'd0, s_axis_tdata[23:8]};
    assign m_axis_tvalid = s_axis_tvalid;
    assign s_axis_tready = m_axis_tready;
    assign m_axis_tlast  = s_axis_tlast;
    assign m_axis_tkeep  = 4'hF;

endmodule
