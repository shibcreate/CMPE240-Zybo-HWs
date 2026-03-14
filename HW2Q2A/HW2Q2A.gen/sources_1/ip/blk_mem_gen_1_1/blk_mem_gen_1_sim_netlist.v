// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sat Mar 14 11:20:57 2026
// Host        : MainPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top blk_mem_gen_1 -prefix
//               blk_mem_gen_1_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_1
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [10:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [10:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;

  wire [10:0]addra;
  wire [10:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "11" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.698 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_1_blk_mem_gen_v8_4_9 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
FPXllyX2NFs/RMngGqZy2bLYbZr92CdofeZrJOHklWXExpaPgHNYp2Lzm4MnflbnrfSkCmLwwKT5
zfRgEip7FKQ5Zhb73p0MAIADixBZ/ZRt4hQkJL0T9brm0waLHfanjnov2aCX6jN3LbQc3ujmDga6
Dd73k78u4xjRTDv1/P4=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kr7VKKvChFoiyRCReag+OvU3jnmG9pN0cv+BxhNmMKLthg/ksgNZyU3L+fQ7cmIQELtlUjwjkBAP
Jjq5RsCnHbJxj+Ys1GNhriiBsxLqxWCP8onhAVvgZN2xZFOih0UWpqlU8NVP8Eww1ohvkDgxTstC
3kDmYehxIUJjqCC/mgRZmuezqugrFdubYmBoz16tUvD17iA5qqCIMS9xSIXYp2LBNekmWEwrVqzu
R4koEo4UlXl/CEw0XY3QvMoHnlXgu6N/6sc+nxZtKSwjiMVvGnZE9UVvJPAC3Hn3zKFGlK53mmGO
Tj0dWzhwX0ahSYzkyJC/HLdbGZmriL2UNvDyFw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
CaLc9FGt3AdRHfNtGAsGFY/QEvHY1Vv4TvvgCDsdDMqiuDeLizFJDJeskBWjeKDoE2cufK8TxiBq
mySRQNJoeOKnxTiDdf+Rx6m0iR6h/YeswegYwgghpM5KVrl6mSwF3+4yEovPM7a+9ArDQ5vl+WT8
SilNGzyW0KnTwe7+szs=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
cEnudSW1X71p0Xuq6jrXOxHnBku87IA0RA3zKqmeZHZM0r+9rEm5MSzX8RecnQ994yiqeyxbIH2l
fGEzUzr0ZzryS3fkf2LnJuB39f2YARW9eVCSiaeWaraZuY1l89T+h3vgdlurS/1LIraYLS1MyOXa
6F1LAcQp3W4OO4ctc3q1FRMZGldRS1biMsKwJ8Lxj8NEOm67UfgFrJNQAxbVXEfbWRWhKtwNxcTB
JbgC8j4EHkIA46mzoHloeBAL6KieplQUBjKXSSTb66rxglbFhWLy+mirROHcocu9J4ZbvTRYZEww
4lso1lqAllVLAoKYqa3WImZuSRoTbGDngBt9Lg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rOyI+x4PlmKcVSFoN3oKgSYpVlmYxc194Ej04il/YmBg10xopy4zmtu5sdCP/uGSNYcNGWeAiw01
mNf98KyNgTUFXruHCA38qjhhEIvl4vfWWn3W3mFRxrIuwmnreT6qTvgMaxIkCdVBDP7Iy7O6WmCf
3Va5X5hnCHhtXgX5UYniBHiLjmupv63B8XMAYDH2n6mQ3H0DF7mtb7psBafd0Z6+IWUbmzwMtKrf
ZrRJBGAhNT0i1KrEjEh/rWjN7Z7N32zQ+Pl1kc5gYCQIX5McfdTdqSaRVXZ/HF90ymS7/8d5LDyj
Er+ORdcjnOn6oAyY4PuUUl4OYUHv5k+RglTe5Q==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bJa7kPSpDipzoJoQu1APEjc8vFLqBfQZK/grZvWijD7/FgMTerFCWLUY6n8DWeGdvjXvTeyrqCHE
2rP/H57wUqPC8tIJlGm6ZYQGjZ3TgYqLrJshDE5zYMTO//q0vuSraWvZP7A7SLuW6y7tFE/nplpx
L8gbYORx6j70okGUwnamCMS9yhFr7Z2QTJne1k4GNFGvy66URk3k5cBPl5j4/1yc4xGV+aWYl6L8
q8RorRU/CltObHKrji/jdiY1WtdGrkpRyCEFc+XNPazL9xSLLu5bz6XlvKwoks+8a5KYT/VFUovM
JbM0bpAXM8Z7rGaPuXjqXtZBg5praTZLu/WNcA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PYKBDinOGc/kIVdFzXrz2wA4/QNFxLDrQfTWfR5TjYE6bm49vrZi0bawcr9HXp4OP1+XxPLB3oCP
oV5e/rYeDln531ebt8yEg27XCoSHEX4FU8oG8aBJ8fqgWayOnAMJt025WodOxuZXbhT1zPo7J3uh
6iO9Mv7RtYE2fZ1W+G8oN//FTOEJYPWlKYnt0cDeZrN3I4rHHptZHuu7l8T+df0PYea3x6U3Mvkl
ojZ+TwQtdu0NuYY5j3QNgx3+W2XYq1M773FAnEz/deW54EjE+jf1jjrBk2pl8SYxeKuutS15oPVF
eHdqXYVcJxoUY5JH8z04lITKEnZ4oq6sYS6dog==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
tl+2vFCWZ583gQGsVC7oopz2NCKBiJ9uOHYBGzJZheOHJMqI/ehNvo25l710eBx00tztXzM30AH6
ZhAJg+kJwE2jO0MV5fmG5dnwXmLqoGEJMBs7xwWxvYK7w/0z9M0AJKD7HnuC+IiLhNU/fIxyuE+I
+vWqp//RcfY0tMMp2I2J1yEW6GUahS1ve/4JchssZ7Xu7VthoSDWXMQWATbvsUsDzeSo2+Ruz8Kq
Dc05HqEU8NgBxDPPEKLCcdKLp4byglwj7iCAtCjsPy8P18qjgb2sycFjNgmaiNMMB51WqeD+hneG
hLOue9bqVdEojkrb3q4WbsGZKz0bAGsryxslOlYHP1b8vey3yI2ixA80wyERe8d3GRIeZiSxGykH
qWxsE6x/iyi8QRb5mXZPMApA+Fln8tYmn7+1rFCm8gF4gJWhr1PsSJqTi658symGrzT0Ghjvf2QL
SvvoaeNdy0pOsWs7jLBFndd4GiFA+9K6Y33sziLToU9EvvFokENIslod

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oYiCujFRj1F3wKsGZlHR9niEtR9MLXEVAVfy+f/3xrmpW6Ye5a+fBCvm4TH+iRQefGHNdMPnzTNW
K/pEPAS9uMJjOdFiu+APT+LYrSRnEg4W0dX5buSDGM6LBWAuMseoTMjbJJoYDGLRckJgW43E30mX
ej4823nkbfwc+Ecbrup825qLyv8RTQLNHafvJA5lSapdqXwnlOIYRmcHn+sfAh5pGv9kW9aokcdh
ObR2XYxX99rYloyvz3x0pmjxD5ILW4SQMB1IUEuuyqX6eb5IQ+kZ41hjvsHIuQH29vzpCfV9Jqha
WC5yxxK1R+cleZSKD1H1gVzbTei8uFs/91Bgeg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
urNc+S8AFPj+GVFdqJE5V7P8O6QI6MA3nkwYb8NKbYbVufnXKg6voJIRYYeYr7EOa8mrqirozWbY
Lln9SLWnkaAy2LvL/N6WahoQdCt++4RH+xe768XvSrVUFPrIwZRixqMLurc/tPov4i5P/ukZKl18
ZPZvXRzUNlvCZnMPcF+5QCQihqPbjcZ0YyGgWgX/ipTGG3sNqmylGN7qLa4Rgqu/mB5a2xVyu5Wc
911+/X3VVFx697WVaP5V0SbOzYN8R8+8B8kdznwixMA+f4lSbBXyRysVOSzYjo8bKEMqyKMVBQn9
xDmEuV0DvVWXdO7VPvWA1LuJFwS07OxeI2GCcQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QcP7fsLZxaDrG29e9HQeXfu2TsKsdyW7Yc1vWct6lbmDEfXkWMU1fFWSPIjPzRc9UOnfEu0bRn+B
D+8MWokqes3WF7txljBmgUPiNGZ8arUU6ENa/IY/Wv7iaB/ZKM5PtdnFAkjDIrYyKFCTz/U6Yzwi
hBGGarK/wYQOLzeeKRewiPTiNUL7tztWuMZ1t1msxD951EeKrwjrjcXIIuf/TzrOGUOlWgjHlnrl
4Q/lfMAnRLBNTSWG+5wWewCE8jK2X/gJ5AV4p3x1WP3+JglbxpP39l3pzedXqciZPbuz2XlFnRPV
KByaUaAShzJ56p8+0HjWebibqQdieGNPiPWW0Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 48112)
`pragma protect data_block
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
cU/HvA==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
