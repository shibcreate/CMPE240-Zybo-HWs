/**
 * demo.h - Zybo Z7-10 Audio Spectrum Analyzer
 *
 * Shared application state, memory layout, and hardware constants.
 */

#ifndef DEMO_H_
#define DEMO_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xil_io.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xpar_remap.h"
#include "xil_cache.h"

/************************** Memory Layout ***********************************/

#ifdef XPAR_PS7_DDR_0_S_AXI_BASEADDR
#define DDR_BASE_ADDR       XPAR_PS7_DDR_0_S_AXI_BASEADDR
#else
#warning "DDR base address not found, defaulting to 0x010000000"
#define DDR_BASE_ADDR       0x00000000
#endif

#define MEM_BASE_ADDR       (DDR_BASE_ADDR + 0x10000000)

/************************** Interrupt Definitions ***************************/

#define DMA_DEV_ID          XPAR_AXIDMA_0_DEVICE_ID
#define RX_INTR_ID          XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
#define TX_INTR_ID          XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR

/************************** Application State *******************************/

typedef struct {
	u8 u8Verbose;
	u8 fUserIOEvent;
	u8 fAudioRecord;
	u8 fAudioPlayback;
	u8 fDmaError;
	u8 fDmaS2MMEvent;
	u8 fDmaMM2SEvent;
	char chBtn;
} sDemo_t;

extern volatile sDemo_t Demo;

#endif /* DEMO_H_ */
