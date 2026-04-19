/************************************************************************/
/*																		*/
/*	demo.c	--	Zybo DMA Demo				 						*/
/*																		*/
/************************************************************************/
/*	Author: Sam Lowe											*/
/*	Copyright 2015, Digilent Inc.										*/
/************************************************************************/
/*  Module Description: 												*/
/*																		*/
/*		This file contains code for running a demonstration of the		*/
/*		DMA audio inputs and outputs on the Zybo.					*/
/*																		*/
/*																		*/
/************************************************************************/
/*  Notes:																*/
/*																		*/
/*		- The DMA max burst size needs to be set to 16 or less			*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/* 																		*/
/*		9/6/2016(SamL): Created										*/
/*																		*/
/************************************************************************/


#include "demo.h"




#include "audio/audio.h"
#include "dma/dma.h"
#include "intc/intc.h"
#include "userio/userio.h"
#include "iic/iic.h"

/***************************** Include Files *********************************/

#include "xaxidma.h"
#include "xparameters.h"
#include "xil_exception.h"
#include "xdebug.h"
#include "xiic.h"
#include "xaxidma.h"
#include "xtime_l.h"


#ifdef XPAR_INTC_0_DEVICE_ID
 #include "xintc.h"
 #include "microblaze_sleep.h"
#else
 #include "xscugic.h"
#include "sleep.h"
#include "xil_cache.h"
#endif

/************************** Constant Definitions *****************************/

/*
 * Device hardware build related constants.
 */

// Audio constants
// ADC/DAC sampling rate in Hz
#define AUDIO_SAMPLING_RATE	  96000

// Passthrough chunk size (matches future FFT frame size)
#define PASSTHROUGH_CHUNK      256
#define BYTES_PER_SAMPLE       4
#define CHUNK_BYTES            (PASSTHROUGH_CHUNK * BYTES_PER_SAMPLE)

// Ping-pong buffer addresses in DDR
#define BUF_A                  (MEM_BASE_ADDR)
#define BUF_B                  (MEM_BASE_ADDR + 0x10000)

// Gain: toggle between 0dB and boosted via codec registers
#define DAC_VOL_0DB            0b101111001   // 0dB (default)
#define DAC_VOL_BOOST          0b101111111   // +6dB (max DAC boost)
#define ADC_VOL_NORMAL         0b000010111   // 0dB input
#define ADC_VOL_BOOST          0b000011111   // +12dB input

/* Timeout loop counter for reset
 */
#define RESET_TIMEOUT_COUNTER	10000

#define TEST_START_VALUE	0x0


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/
#if (!defined(DEBUG))
extern void xil_printf(const char *format, ...);
#endif


/************************** Variable Definitions *****************************/
// This variable holds the demo related settings
volatile sDemo_t Demo;

/*
 * Device instance definitions
 */

static XIic sIic;
static XAxiDma sAxiDma;		/* Instance of the XAxiDma */

static XGpio sUserIO;

#ifdef XPAR_INTC_0_DEVICE_ID
 static XIntc sIntc;
#else
 static XScuGic sIntc;
#endif

//
// Interrupt vector table
#ifdef XPAR_INTC_0_DEVICE_ID
const ivt_t ivt[] = {
	//IIC
	{XPAR_AXI_INTC_0_AXI_IIC_0_IIC2INTC_IRPT_INTR, (XInterruptHandler)XIic_InterruptHandler, &sIic},
	//DMA Stream to MemoryMap Interrupt handler
	{XPAR_AXI_INTC_0_AXI_DMA_0_S2MM_INTROUT_INTR, (XInterruptHandler)fnS2MMInterruptHandler, &sAxiDma},
	//DMA MemoryMap to Stream Interrupt handler
	{XPAR_AXI_INTC_0_AXI_DMA_0_MM2S_INTROUT_INTR, (XInterruptHandler)fnMM2SInterruptHandler, &sAxiDma},
	//User I/O (buttons, switches, LEDs)
	{XPAR_AXI_INTC_0_AXI_GPIO_0_IP2INTC_IRPT_INTR, (XInterruptHandler)fnUserIOIsr, &sUserIO}
};
#else
const ivt_t ivt[] = {
	//IIC
	{XPAR_FABRIC_AXI_IIC_0_IIC2INTC_IRPT_INTR, (Xil_ExceptionHandler)XIic_InterruptHandler, &sIic},
	//DMA Stream to MemoryMap Interrupt handler
	{XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, (Xil_ExceptionHandler)fnS2MMInterruptHandler, &sAxiDma},
	//DMA MemoryMap to Stream Interrupt handler
	{XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR, (Xil_ExceptionHandler)fnMM2SInterruptHandler, &sAxiDma},
	//User I/O (buttons, switches, LEDs)
	{XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR, (Xil_ExceptionHandler)fnUserIOIsr, &sUserIO}
};
#endif


/*****************************************************************************/
/**
* Main function - Real-time audio passthrough (LINE IN -> HPH OUT)
*
* Uses ping-pong DMA buffers for continuous low-latency audio.
* Each chunk is 256 samples (~2.67ms at 96kHz), giving continuous
* passthrough with minimal latency.
*
******************************************************************************/
// Helper: start the first S2MM receive to kick off passthrough
static void fnStartPassthrough(XAxiDma *pAxiDma, volatile int *pRxBufIdx)
{
	*pRxBufIdx = 0;
	// Reset FIFOs for clean channel alignment
	Xil_Out32(I2S_FIFO_CONTROL_REG, (1u << 30) | (1u << 31));
	Xil_Out32(I2S_FIFO_CONTROL_REG, 0x00000000);

	XAxiDma_SimpleTransfer(pAxiDma, (u32)BUF_A, CHUNK_BYTES, XAXIDMA_DEVICE_TO_DMA);
	Xil_Out32(I2S_PERIOD_COUNT_REG, PASSTHROUGH_CHUNK);
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000000);
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000002); // RX_RS only
	Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000001);   // S2MM enable
}

// Helper: stop I2S streaming
static void fnStopPassthrough(void)
{
	Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000000);
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000000);
}

// Helper: convert interleaved stereo to mono in-place
// Buffer format: [L0][R0][L1][R1]... each 24-bit in 32-bit word
// Output: mono = (L+R)>>1 written to both L and R slots
static void fnStereoToMono(u32 bufAddr, u32 numBytes)
{
	u32 *pBuf = (u32 *)bufAddr;
	u32 numWords = numBytes / sizeof(u32);

	for (u32 i = 0; i < numWords; i += 2)
	{
		int32_t left  = (int32_t)pBuf[i];
		int32_t right = (int32_t)pBuf[i + 1];

		// Sign-extend from 24-bit
		left  = (left  << 8) >> 8;
		right = (right << 8) >> 8;

		// Mix to mono: (L + R) / 2
		int32_t mono = (left + right) >> 1;

		u32 out = (u32)(mono & 0x00FFFFFF);
		pBuf[i]     = out;
		pBuf[i + 1] = out;
	}
}

int main(void)
{
	int Status;
	volatile int rxBufIdx = 0;
	volatile int audioOn = 0;
	volatile int gainBoost = 0;

	Demo.u8Verbose = 0;

	xil_printf("\r\n--- Entering main() --- \r\n");

	//Initialize the interrupt controller
	Status = fnInitInterruptController(&sIntc);
	if(Status != XST_SUCCESS) {
		xil_printf("Error initializing interrupts");
		return XST_FAILURE;
	}

	// Initialize IIC controller
	Status = fnInitIic(&sIic);
	if(Status != XST_SUCCESS) {
		xil_printf("Error initializing I2C controller");
		return XST_FAILURE;
	}

	// Initialize User I/O driver
	Status = fnInitUserIO(&sUserIO);
	if(Status != XST_SUCCESS) {
		xil_printf("User I/O ERROR");
		return XST_FAILURE;
	}

	//Initialize DMA
	Status = fnConfigDma(&sAxiDma);
	if(Status != XST_SUCCESS) {
		xil_printf("DMA configuration ERROR");
		return XST_FAILURE;
	}

	//Initialize Audio I2S
	Status = fnInitAudio();
	if(Status != XST_SUCCESS) {
		xil_printf("Audio initializing ERROR");
		return XST_FAILURE;
	}

	// Wait for codec to stabilize
	{
		XTime tStart, tEnd;
		XTime_GetTime(&tStart);
		do {
			XTime_GetTime(&tEnd);
		} while((tEnd-tStart)/(COUNTS_PER_SECOND/10) < 20);
	}

	// Re-init audio after codec settle time
	Status = fnInitAudio();
	if(Status != XST_SUCCESS) {
		xil_printf("Audio initializing ERROR");
		return XST_FAILURE;
	}

	// Enable all interrupts
	fnEnableInterrupts(&sIntc, &ivt[0], sizeof(ivt)/sizeof(ivt[0]));

	// Configure codec: line input selected, DAC enabled
	fnSetLineInput();

	xil_printf("----------------------------------------------------------\r\n");
	xil_printf("Zybo Z7-10 Audio Passthrough\r\n");
	xil_printf("----------------------------------------------------------\r\n");
	xil_printf("  BTN3: Toggle audio ON/OFF\r\n");
	xil_printf("  BTN2: Toggle gain boost (+18dB)\r\n");
	xil_printf("----------------------------------------------------------\r\n");
	xil_printf("Audio OFF | Gain: 0dB\r\n");

	while(1) {

		// --- Button events ---
		if (Demo.fUserIOEvent)
		{
			switch(Demo.chBtn)
			{
				case 'r': // BTN3 (BTNR): toggle audio on/off
					if (!audioOn)
					{
						audioOn = 1;
						fnStartPassthrough(&sAxiDma, &rxBufIdx);
						xil_printf("Audio ON  | Gain: %s\r\n",
								gainBoost ? "+18dB" : "0dB");
					}
					else
					{
						audioOn = 0;
						fnStopPassthrough();
						xil_printf("Audio OFF | Gain: %s\r\n",
								gainBoost ? "+18dB" : "0dB");
					}
					break;

				case 'l': // BTN2 (BTNL): toggle gain boost
					gainBoost = !gainBoost;
					if (gainBoost)
					{
						// +6dB DAC + +12dB ADC = +18dB total
						fnAudioWriteToReg(R2_LEFT_DAC_VOL, DAC_VOL_BOOST);
						fnAudioWriteToReg(R3_RIGHT_DAC_VOL, DAC_VOL_BOOST);
						fnAudioWriteToReg(R0_LEFT_ADC_VOL, ADC_VOL_BOOST);
						fnAudioWriteToReg(R1_RIGHT_ADC_VOL, ADC_VOL_BOOST);
					}
					else
					{
						fnAudioWriteToReg(R2_LEFT_DAC_VOL, DAC_VOL_0DB);
						fnAudioWriteToReg(R3_RIGHT_DAC_VOL, DAC_VOL_0DB);
						fnAudioWriteToReg(R0_LEFT_ADC_VOL, ADC_VOL_NORMAL);
						fnAudioWriteToReg(R1_RIGHT_ADC_VOL, ADC_VOL_NORMAL);
					}
					xil_printf("%s | Gain: %s\r\n",
							audioOn ? "Audio ON " : "Audio OFF",
							gainBoost ? "+18dB" : "0dB");
					break;

				default:
					break;
			}

			Demo.chBtn = 0;
			Demo.fUserIOEvent = 0;
		}

		// --- Passthrough DMA loop (only when audio is on) ---
		if (audioOn && Demo.fDmaS2MMEvent)
		{
			Demo.fDmaS2MMEvent = 0;

			// Determine which buffer just finished and which is next
			u32 doneBuf = (rxBufIdx == 0) ? (u32)BUF_A : (u32)BUF_B;
			rxBufIdx = 1 - rxBufIdx;
			u32 nextBuf = (rxBufIdx == 0) ? (u32)BUF_A : (u32)BUF_B;

			// Cache: invalidate received data
			Xil_DCacheInvalidateRange(doneBuf, CHUNK_BYTES);

			// Flush for playback
			Xil_DCacheFlushRange(doneBuf, CHUNK_BYTES);

			// Stop I2S before reconfiguring
			Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000000);
			Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000000);

			// Reset I2S FIFOs to clear stale data and prevent L/R channel misalignment
			Xil_Out32(I2S_FIFO_CONTROL_REG, (1u << 30) | (1u << 31));
			Xil_Out32(I2S_FIFO_CONTROL_REG, 0x00000000);

			// Start next S2MM receive into the other buffer
			XAxiDma_SimpleTransfer(&sAxiDma, nextBuf, CHUNK_BYTES,
					XAXIDMA_DEVICE_TO_DMA);

			// Start MM2S playback from the completed buffer
			XAxiDma_SimpleTransfer(&sAxiDma, doneBuf, CHUNK_BYTES,
					XAXIDMA_DMA_TO_DEVICE);

			// Enable both TX and RX simultaneously
			Xil_Out32(I2S_PERIOD_COUNT_REG, PASSTHROUGH_CHUNK);
			Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000003); // TX_RS | RX_RS
			Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000003);   // S2MM | MM2S
		}

		// MM2S complete: playback of a chunk finished
		if (Demo.fDmaMM2SEvent)
		{
			Demo.fDmaMM2SEvent = 0;
		}

		// DMA error: reset and restart if audio is on
		if (Demo.fDmaError)
		{
			xil_printf("\r\nDMA Error, restarting...\r\n");
			Demo.fDmaError = 0;
			fnConfigDma(&sAxiDma);

			if (audioOn)
			{
				fnStartPassthrough(&sAxiDma, &rxBufIdx);
			}
		}
	}

	return XST_SUCCESS;
}









