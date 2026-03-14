// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sat Mar 14 11:20:57 2026
// Host        : MainPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_9,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_9,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_9 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 48528)
`pragma protect data_block
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
saFIKk0c5O7jz3pWsSIpNpbu0E5D
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
