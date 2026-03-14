vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_vip_v1_1_19
vlib modelsim_lib/msim/processing_system7_vip_v1_0_21
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/axi_bram_ctrl_v4_1_11
vlib modelsim_lib/msim/xlconstant_v1_1_9
vlib modelsim_lib/msim/lib_cdc_v1_0_3
vlib modelsim_lib/msim/proc_sys_reset_v5_0_16
vlib modelsim_lib/msim/smartconnect_v1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_33

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_19 modelsim_lib/msim/axi_vip_v1_1_19
vmap processing_system7_vip_v1_0_21 modelsim_lib/msim/processing_system7_vip_v1_0_21
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap axi_bram_ctrl_v4_1_11 modelsim_lib/msim/axi_bram_ctrl_v4_1_11
vmap xlconstant_v1_1_9 modelsim_lib/msim/xlconstant_v1_1_9
vmap lib_cdc_v1_0_3 modelsim_lib/msim/lib_cdc_v1_0_3
vmap proc_sys_reset_v5_0_16 modelsim_lib/msim/proc_sys_reset_v5_0_16
vmap smartconnect_v1_0 modelsim_lib/msim/smartconnect_v1_0
vmap axi_register_slice_v2_1_33 modelsim_lib/msim/axi_register_slice_v2_1_33

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"B:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"B:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"B:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"B:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"B:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_19  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/8c45/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_21  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_processing_system7_0_0/sim/design_1_processing_system7_0_0.v" \

vcom -work axi_bram_ctrl_v4_1_11  -93  \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/df79/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_0_0/sim/design_1_axi_bram_ctrl_0_0.vhd" \

vlog -work xlconstant_v1_1_9  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/e2d2/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_0/sim/bd_afc3_one_0.v" \

vcom -work lib_cdc_v1_0_3  -93  \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/2a4f/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_16  -93  \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0831/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/sim/bd_afc3_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f49a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_2/sim/bd_afc3_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/2da8/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_3/sim/bd_afc3_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/63ed/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_4/sim/bd_afc3_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/cef3/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_5/sim/bd_afc3_s00a2s_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_6/sim/bd_afc3_sarn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_7/sim/bd_afc3_srn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_8/sim/bd_afc3_sawn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_9/sim/bd_afc3_swn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_10/sim/bd_afc3_sbn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/7f4f/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_11/sim/bd_afc3_m00s2a_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/37bc/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_12/sim/bd_afc3_m00e_0.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/sim/bd_afc3.v" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/3718/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work axi_register_slice_v2_1_33  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/3ee4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/sim/design_1_axi_smc_0.v" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_rst_ps7_0_50M_0/sim/design_1_rst_ps7_0_50M_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../HW2Q2A.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+B:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

