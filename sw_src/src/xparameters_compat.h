/*
 * xparameters_compat.h
 *
 * Compatibility header for Vitis 2025.2 SDT flow.
 * Maps old HSI-style XPAR_ macro names to the new SDT-generated names
 * in xparameters.h. Include this AFTER xparameters.h in any file that
 * uses the old-style names.
 */

#ifndef XPARAMETERS_COMPAT_H
#define XPARAMETERS_COMPAT_H

#include "xparameters.h"

/* ---- I2S Audio IP base address ---- */
#ifndef XPAR_D_AXI_I2S_AUDIO_0_AXI_L_BASEADDR
#define XPAR_D_AXI_I2S_AUDIO_0_AXI_L_BASEADDR  XPAR_D_AXI_I2S_AUDIO_0_BASEADDR
#endif

/* ---- IIC base address (polled mode) ---- */
#ifndef XPAR_IIC_0_BASEADDR
#define XPAR_IIC_0_BASEADDR  XPAR_XIIC_0_BASEADDR
#endif

/* ---- Device IDs (SDT uses base addresses instead) ---- */
#ifndef XPAR_AXIDMA_0_DEVICE_ID
#define XPAR_AXIDMA_0_DEVICE_ID  XPAR_XAXIDMA_0_BASEADDR
#endif

#ifndef XPAR_AXI_IIC_0_DEVICE_ID
#define XPAR_AXI_IIC_0_DEVICE_ID  XPAR_XIIC_0_BASEADDR
#endif

#ifndef XPAR_PS7_SCUGIC_0_DEVICE_ID
#define XPAR_PS7_SCUGIC_0_DEVICE_ID  XPAR_XSCUGIC_0_BASEADDR
#endif

#ifndef XPAR_SCUGIC_0_DEVICE_ID
#define XPAR_SCUGIC_0_DEVICE_ID  XPAR_XSCUGIC_0_BASEADDR
#endif

/* ---- Interrupt IDs ---- */
#ifndef XPAR_FABRIC_AXI_IIC_0_IIC2INTC_IRPT_INTR
#define XPAR_FABRIC_AXI_IIC_0_IIC2INTC_IRPT_INTR  XPAR_FABRIC_XIIC_0_INTR
#endif

#ifndef XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
#define XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR  XPAR_FABRIC_AXI_DMA_0_INTR
#endif

#ifndef XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR
#define XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR  XPAR_FABRIC_AXI_DMA_0_INTR_1
#endif

#ifndef XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR
#define XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR  XPAR_FABRIC_XGPIO_0_INTR
#endif

/* ---- DDR base address ---- */
#ifndef XPAR_PS7_DDR_0_S_AXI_BASEADDR
#define XPAR_PS7_DDR_0_S_AXI_BASEADDR  XPAR_PS7_DDR_0_BASEADDRESS
#endif

/* ---- GPIO (switches) ---- */
#ifndef XPAR_SWITCHES_0_BASEADDR
#define XPAR_SWITCHES_0_BASEADDR  XPAR_XGPIO_0_BASEADDR
#endif

/* ---- MIG base address (not present on Zynq, map to DDR) ---- */
#ifndef XPAR_MIG_7SERIES_0_BASEADDR
#define XPAR_MIG_7SERIES_0_BASEADDR  XPAR_PS7_DDR_0_BASEADDRESS
#endif

/* ---- CPU clock freq (xtime_l.h -> xparameters_ps.h expects this) ---- */
#ifndef XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ
#define XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ  XPAR_CPU_CORE_CLOCK_FREQ_HZ
#endif

#endif /* XPARAMETERS_COMPAT_H */
