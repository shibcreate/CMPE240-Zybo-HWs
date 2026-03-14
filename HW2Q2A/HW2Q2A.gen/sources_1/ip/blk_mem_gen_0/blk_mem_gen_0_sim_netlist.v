// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sat Mar 14 11:20:57 2026
// Host        : MainPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/jorda/VivadoProject2/HW2Q2A/HW2Q2A.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
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
  blk_mem_gen_0_blk_mem_gen_v8_4_9 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 48384)
`pragma protect data_block
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
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
