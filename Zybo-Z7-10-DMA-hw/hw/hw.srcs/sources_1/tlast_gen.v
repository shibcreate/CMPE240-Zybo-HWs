// tlast_gen.v
// Aligns FFT output frames for DMA by waiting for FFT's TLAST before passing data
// Fixes DMAIntErr caused by DMA starting mid-frame
// CMPE240 Spring 2026

`timescale 1ns / 1ps

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
(* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_axis:m_axis, ASSOCIATED_RESET aresetn" *)

module tlast_gen #(
    parameter FRAME_SIZE = 256
)(
    input  wire        aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        aresetn,

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

    reg        synced;
    reg [8:0]  count;

    assign s_axis_tready = synced ? m_axis_tready : 1'b1;

    assign m_axis_tdata  = s_axis_tdata;
    assign m_axis_tvalid = synced & s_axis_tvalid;
    assign m_axis_tkeep  = s_axis_tkeep;
    assign m_axis_tlast  = synced & s_axis_tvalid & (count == FRAME_SIZE - 1);

    always @(posedge aclk) begin
        if (!aresetn) begin
            synced <= 1'b0;
            count  <= 9'd0;
        end else if (!synced) begin
            // discard until we see a TLAST (frame boundary)
            if (s_axis_tvalid && s_axis_tlast)
                synced <= 1'b1;
        end else if (s_axis_tvalid && m_axis_tready) begin
            if (count == FRAME_SIZE - 1)
                count <= 9'd0;
            else
                count <= count + 1'b1;
        end
    end

endmodule
