/*
 * xparameters_compat.h
 *
 * Legacy-to-SDT macro shim for the Digilent Zybo Z7-10 HDMI demo.
 *
 * The original Digilent sources were written for the pre-2023 HSI/SDK flow
 * and reference XPAR_* macros that no longer exist in Vitis 2025.2's
 * System Device Tree (SDT) generated xparameters.h:
 *
 *   - XPAR_*_DEVICE_ID       -> replaced by XPAR_X<driver>_<i>_BASEADDR
 *                              (SDT drivers take a base address, not an ID)
 *   - XPAR_FABRIC_*_IRPT     -> renamed to XPAR_FABRIC_*_INTR
 *   - XPAR_CPU_CORTEXA9_0_*  -> renamed to XPAR_CPU_*
 *   - XPAR_PS7_UART_1_*      -> renamed to XPAR_XUARTPS_0_*
 *
 * This header re-establishes the legacy names so the demo sources compile
 * unmodified. Include AFTER #include "xparameters.h".
 */
#ifndef XPARAMETERS_COMPAT_H
#define XPARAMETERS_COMPAT_H

#include "xparameters.h"

/* CPU clock */
#ifndef XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ
#define XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ XPAR_CPU_CORE_CLOCK_FREQ_HZ
#endif

/* AXI Dynamic Clock (Digilent axi_dynclk) */
#ifndef XPAR_AXI_DYNCLK_0_S_AXI_LITE_BASEADDR
#define XPAR_AXI_DYNCLK_0_S_AXI_LITE_BASEADDR XPAR_AXI_DYNCLK_0_BASEADDR
#endif

/* AXI VDMA - DEVICE_ID -> BASEADDR for LookupConfig() in SDT mode */
#ifndef XPAR_AXIVDMA_0_DEVICE_ID
#define XPAR_AXIVDMA_0_DEVICE_ID XPAR_XAXIVDMA_0_BASEADDR
#endif

/* Video Timing Controllers (input from HDMI RX, output to HDMI TX) */
#ifndef XPAR_V_TC_IN_DEVICE_ID
#define XPAR_V_TC_IN_DEVICE_ID XPAR_V_TC_IN_BASEADDR
#endif
#ifndef XPAR_V_TC_OUT_DEVICE_ID
#define XPAR_V_TC_OUT_DEVICE_ID XPAR_V_TC_OUT_BASEADDR
#endif

/* AXI GPIO tied to HDMI RX HPD/locked signals */
#ifndef XPAR_AXI_GPIO_VIDEO_DEVICE_ID
#define XPAR_AXI_GPIO_VIDEO_DEVICE_ID XPAR_AXI_GPIO_VIDEO_BASEADDR
#endif

/* Fabric interrupt IDs (renamed in SDT: *_IRPT/_IRQ -> _INTR) */
#ifndef XPAR_FABRIC_V_TC_IN_IRQ_INTR
#define XPAR_FABRIC_V_TC_IN_IRQ_INTR XPAR_FABRIC_V_TC_IN_INTR
#endif
#ifndef XPAR_FABRIC_AXI_GPIO_VIDEO_IP2INTC_IRPT_INTR
#define XPAR_FABRIC_AXI_GPIO_VIDEO_IP2INTC_IRPT_INTR XPAR_FABRIC_AXI_GPIO_VIDEO_INTR
#endif

/* PS7 UART1 - physical UART1 at 0xe0001000 is XPAR_XUARTPS_0 in SDT */
#ifndef XPAR_PS7_UART_1_BASEADDR
#define XPAR_PS7_UART_1_BASEADDR XPAR_XUARTPS_0_BASEADDR
#endif

#endif /* XPARAMETERS_COMPAT_H */
