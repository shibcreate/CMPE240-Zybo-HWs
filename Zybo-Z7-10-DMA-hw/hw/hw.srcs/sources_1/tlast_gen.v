/************************************************************************/
/*  tlast_gen.v                                                         */
/*  AXI4-Stream TLAST frame aligner                                     */
/*                                                                      */
/*  Sits between FFT output and DMA S2MM input.                         */
/*  Waits for the FFT's own TLAST to find a frame boundary, then        */
/*  passes aligned frames with correctly-timed TLAST for the DMA.       */
/*                                                                      */
/*  Fixes DMAIntErr caused by DMA starting mid-FFT-frame.               */
/*                                                                      */
/*  CMPE240 Spring 2026                                                 */
/************************************************************************/

`timescale 1ns / 1ps

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
(* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_axis:m_axis, ASSOCIATED_RESET aresetn" *)

module tlast_gen #(
    parameter FRAME_SIZE = 256   // Samples per FFT frame
)(
    input  wire        aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        aresetn,

    // AXI4-Stream Slave (from FFT M_AXIS_DATA)
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *)
    (* X_INTERFACE_PARAMETER = "TDATA_NUM_BYTES 4, HAS_TLAST 1, HAS_TKEEP 1, HAS_TREADY 1" *)
    input  wire [31:0] s_axis_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *)
    input  wire        s_axis_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *)
    output wire        s_axis_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *)
    input  wire        s_axis_tlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TKEEP" *)
    input  wire [3:0]  s_axis_tkeep,

    // AXI4-Stream Master (to DMA S_AXIS_S2MM)
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *)
    (* X_INTERFACE_PARAMETER = "TDATA_NUM_BYTES 4, HAS_TLAST 1, HAS_TKEEP 1, HAS_TREADY 1" *)
    output wire [31:0] m_axis_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *)
    output wire        m_axis_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *)
    input  wire        m_axis_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *)
    output wire        m_axis_tlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TKEEP" *)
    output wire [3:0]  m_axis_tkeep
);

    reg        synced;    // 1 after first FFT TLAST seen
    reg [8:0]  count;     // 0 to FRAME_SIZE-1

    // Always accept data from FFT (don't stall the pipeline)
    assign s_axis_tready = synced ? m_axis_tready : 1'b1;

    // Only pass data downstream after synced to frame boundary
    assign m_axis_tdata  = s_axis_tdata;
    assign m_axis_tvalid = synced & s_axis_tvalid;
    assign m_axis_tkeep  = s_axis_tkeep;
    assign m_axis_tlast  = synced & s_axis_tvalid & (count == FRAME_SIZE - 1);

    always @(posedge aclk) begin
        if (!aresetn) begin
            synced <= 1'b0;
            count  <= 9'd0;
        end else if (!synced) begin
            // Discard data until we see FFT's TLAST (end of frame)
            if (s_axis_tvalid && s_axis_tlast)
                synced <= 1'b1;  // Next sample is start of a new frame
        end else if (s_axis_tvalid && m_axis_tready) begin
            if (count == FRAME_SIZE - 1)
                count <= 9'd0;
            else
                count <= count + 1'b1;
        end
    end

endmodule
