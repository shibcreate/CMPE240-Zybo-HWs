/**
 * demo.c - Zybo Z7-10 Audio Spectrum Analyzer
 *
 * PL pipeline:
 *   I2S RX -> stereo_to_mono -> broadcast -> I2S TX (passthrough)
 *                                         -> sample_buffer -> FFT -> DMA
 * PS handles:
 *   DMA S2MM receives FFT output (256 complex bins)
 *   Computes magnitudes, bins into 32 bars, renders to HDMI framebuffer
 */

#include "demo.h"
#include "audio/audio.h"
#include "dma/dma.h"
#include "intc/intc.h"
#include "userio/userio.h"
#include "iic/iic.h"
#include "display_ctrl/display_ctrl.h"

#include "xaxidma.h"
#include "xaxivdma.h"
#include "xparameters.h"
#include "xil_exception.h"
#include "xiic.h"
#include "xtime_l.h"
#include <math.h>

#ifdef XPAR_INTC_0_DEVICE_ID
 #include "xintc.h"
 #include "microblaze_sleep.h"
#else
 #include "xscugic.h"
 #include "sleep.h"
 #include "xil_cache.h"
#endif

/************************** Constants ****************************************/

/* FFT */
#define FFT_SIZE            256
#define FFT_FRAME_BYTES     (FFT_SIZE * 4)     /* 16-bit real + 16-bit imag */
#define FFT_BUF_A           (MEM_BASE_ADDR)
#define FFT_BUF_B           (MEM_BASE_ADDR + 0x10000)

/* Spectrum display */
#define USABLE_BINS         128
#define NUM_BARS            32
#define BINS_PER_BAR        (USABLE_BINS / NUM_BARS)
#define NOISE_FLOOR         50.0f
#define MAG_SCALE           10.0f

/* HDMI framebuffer (640x480 @ 24bpp RGB888) */
#define SCREEN_WIDTH        640
#define SCREEN_HEIGHT       480
#define STRIDE              (SCREEN_WIDTH * 3)
#define FRAME_BUF_SIZE      (SCREEN_WIDTH * SCREEN_HEIGHT * 3)
#define BAR_MAX_HEIGHT      400
#define BAR_BASELINE        (SCREEN_HEIGHT - 40)
#define BAR_WIDTH           (SCREEN_WIDTH / NUM_BARS)
#define BAR_GAP             2

/* HDMI IP addresses */
#define DYNCLK_BASEADDR     XPAR_AXI_DYNCLK_0_S_AXI_LITE_BASEADDR
#define VTC_OUT_ID          XPAR_V_TC_OUT_DEVICE_ID
#define VDMA_ID             XPAR_AXIVDMA_0_DEVICE_ID

/* Codec gain presets */
#define DAC_VOL_0DB         0b101111001
#define DAC_VOL_BOOST       0b101111111
#define ADC_VOL_NORMAL      0b000010111
#define ADC_VOL_BOOST       0b000011111

/* Watchdog: loop iterations before pipeline restart */
#define STALL_TIMEOUT       2000000

/************************** Globals ******************************************/

volatile sDemo_t Demo;

static XIic        sIic;
static XAxiDma     sAxiDma;
static XGpio       sUserIO;
static XAxiVdma    sVdma;
static DisplayCtrl sDispCtrl;

static float  magnitudes[USABLE_BINS];
static u32    barHeights[NUM_BARS];

static u8 frameBuf[DISPLAY_NUM_FRAMES][SCREEN_HEIGHT][STRIDE]
	__attribute__((aligned(0x20)));
static u8 *framePtrs[DISPLAY_NUM_FRAMES] = {
	frameBuf[0][0], frameBuf[1][0], frameBuf[2][0], frameBuf[3][0]
};

#ifdef XPAR_INTC_0_DEVICE_ID
 static XIntc sIntc;
#else
 static XScuGic sIntc;
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
const ivt_t ivt[] = {
	{XPAR_AXI_INTC_0_AXI_IIC_0_IIC2INTC_IRPT_INTR, (XInterruptHandler)XIic_InterruptHandler, &sIic},
	{XPAR_AXI_INTC_0_AXI_DMA_0_S2MM_INTROUT_INTR, (XInterruptHandler)fnS2MMInterruptHandler, &sAxiDma},
	{XPAR_AXI_INTC_0_AXI_DMA_0_MM2S_INTROUT_INTR, (XInterruptHandler)fnMM2SInterruptHandler, &sAxiDma},
	{XPAR_AXI_INTC_0_AXI_GPIO_0_IP2INTC_IRPT_INTR, (XInterruptHandler)fnUserIOIsr, &sUserIO}
};
#else
const ivt_t ivt[] = {
	{XPAR_FABRIC_AXI_IIC_0_IIC2INTC_IRPT_INTR, (Xil_ExceptionHandler)XIic_InterruptHandler, &sIic},
	{XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR, (Xil_ExceptionHandler)fnS2MMInterruptHandler, &sAxiDma},
	{XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR, (Xil_ExceptionHandler)fnMM2SInterruptHandler, &sAxiDma},
	{XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR, (Xil_ExceptionHandler)fnUserIOIsr, &sUserIO}
};
#endif

/************************** Audio Pipeline ***********************************/

static void fnStartAudio(XAxiDma *pAxiDma, volatile int *pRxBufIdx)
{
	*pRxBufIdx = 0;

	Xil_Out32(I2S_FIFO_CONTROL_REG, (1u << 30) | (1u << 31));
	Xil_Out32(I2S_FIFO_CONTROL_REG, 0x00000000);
	Xil_Out32(I2S_PERIOD_COUNT_REG, 0x000FFFFF);
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000003);
	Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000003);

	usleep(50000);

	XAxiDma_SimpleTransfer(pAxiDma, (u32)FFT_BUF_A, FFT_FRAME_BYTES,
			XAXIDMA_DEVICE_TO_DMA);
}

static void fnStopAudio(XAxiDma *pAxiDma)
{
	Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000000);
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000000);

	XAxiDma_Reset(pAxiDma);
	int timeout = 1000;
	while (timeout && !XAxiDma_ResetIsDone(pAxiDma)) timeout--;
	fnConfigDma(pAxiDma);
	XAxiDma_IntrDisable(pAxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
	Demo.fDmaS2MMEvent = 0;
	Demo.fDmaError = 0;
}

/************************** Spectrum Rendering ********************************/

static void initFramebuffer(void)
{
	for (int i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		memset(frameBuf[i], 0, FRAME_BUF_SIZE);
		Xil_DCacheFlushRange((UINTPTR)frameBuf[i], FRAME_BUF_SIZE);
	}
}

static void renderBars(void)
{
	u8 *fb = frameBuf[sDispCtrl.curFrame][0];

	for (int b = 0; b < NUM_BARS; b++)
	{
		int x_start = b * BAR_WIDTH + BAR_GAP;
		int x_end   = (b + 1) * BAR_WIDTH;
		u32 height  = barHeights[b];
		int bar_top = BAR_BASELINE - (int)height;

		for (int x = x_start; x < x_end; x++)
		{
			for (int y = 0; y < bar_top; y++)
			{
				int offset = y * STRIDE + x * 3;
				fb[offset] = 0; fb[offset+1] = 0; fb[offset+2] = 0;
			}

			if (height > 0)
			{
				for (int y = bar_top; y <= BAR_BASELINE; y++)
				{
					int dist = y - bar_top;
					u8 g = (u8)(255 - (dist * 191) / (int)height);
					int offset = y * STRIDE + x * 3;
					fb[offset] = 0; fb[offset+1] = g; fb[offset+2] = 0;
				}
			}

			for (int y = BAR_BASELINE + 1; y < SCREEN_HEIGHT; y++)
			{
				int offset = y * STRIDE + x * 3;
				fb[offset] = 0; fb[offset+1] = 0; fb[offset+2] = 0;
			}
		}
	}

	Xil_DCacheFlushRange((UINTPTR)fb, FRAME_BUF_SIZE);
}

static void processFFTFrame(u32 *pBuf, int gainBoost)
{
	magnitudes[0] = 0.0f;
	for (int i = 1; i < USABLE_BINS; i++)
	{
		int16_t re = (int16_t)(pBuf[i] & 0xFFFF);
		int16_t im = (int16_t)((pBuf[i] >> 16) & 0xFFFF);
		float mag = sqrtf((float)re * re + (float)im * im);
		magnitudes[i] = (mag > NOISE_FLOOR) ? mag - NOISE_FLOOR : 0.0f;
	}

	float gainScale = gainBoost ? 4.0f : 1.0f;

	for (int b = 0; b < NUM_BARS; b++)
	{
		float sum = 0.0f;
		int base = b * BINS_PER_BAR;
		for (int j = 0; j < BINS_PER_BAR; j++)
			sum += magnitudes[base + j];

		float avg = (sum / BINS_PER_BAR) * gainScale;
		u32 h = (u32)(avg / MAG_SCALE);
		if (h > BAR_MAX_HEIGHT) h = BAR_MAX_HEIGHT;
		barHeights[b] = h;
	}

	renderBars();
}

/************************** Initialization ***********************************/

static int initHardware(void)
{
	int Status;

	Status = fnInitInterruptController(&sIntc);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	Status = fnInitIic(&sIic);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	Status = fnInitUserIO(&sUserIO);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	Status = fnConfigDma(&sAxiDma);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	Status = fnInitAudio();
	if (Status != XST_SUCCESS) return XST_FAILURE;

	/* Codec stabilize delay (~2s) */
	XTime tStart, tEnd;
	XTime_GetTime(&tStart);
	do { XTime_GetTime(&tEnd); }
	while ((tEnd - tStart) / (COUNTS_PER_SECOND / 10) < 20);

	Status = fnInitAudio();
	if (Status != XST_SUCCESS) return XST_FAILURE;

	fnEnableInterrupts(&sIntc, &ivt[0], sizeof(ivt)/sizeof(ivt[0]));
	XAxiDma_IntrDisable(&sAxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
	fnSetLineInput();

	return XST_SUCCESS;
}

static int initDisplay(void)
{
	int Status;

	XAxiVdma_Config *vdmaConfig = XAxiVdma_LookupConfig(VDMA_ID);
	if (!vdmaConfig) return XST_FAILURE;

	Status = XAxiVdma_CfgInitialize(&sVdma, vdmaConfig, vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	Status = DisplayInitialize(&sDispCtrl, &sVdma, VTC_OUT_ID,
			DYNCLK_BASEADDR, framePtrs, STRIDE);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	Status = DisplaySetMode(&sDispCtrl, &VMODE_640x480);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	initFramebuffer();

	Status = DisplayStart(&sDispCtrl);
	if (Status != XST_SUCCESS) return XST_FAILURE;

	return XST_SUCCESS;
}

/************************** Main Loop ****************************************/

int main(void)
{
	volatile int rxBufIdx   = 0;
	volatile int audioOn    = 0;
	volatile int gainBoost  = 0;
	int stallCount = 0;

	Demo.u8Verbose = 0;

	xil_printf("\r\n--- Zybo Z7-10 Audio Spectrum Analyzer ---\r\n");

	if (initHardware() != XST_SUCCESS) {
		xil_printf("Hardware init FAILED\r\n");
		return XST_FAILURE;
	}

	if (initDisplay() != XST_SUCCESS) {
		xil_printf("Display init FAILED\r\n");
		return XST_FAILURE;
	}

	xil_printf("HDMI: 640x480 @ 24bpp\r\n");
	xil_printf("BTN3: Audio ON/OFF | BTN2: Gain toggle\r\n");
	xil_printf("Ready.\r\n");

	while (1)
	{
		/* ---- Button events ---- */
		if (Demo.fUserIOEvent)
		{
			switch (Demo.chBtn)
			{
			case 'r': /* BTN3: toggle audio */
				if (!audioOn)
				{
					audioOn = 1;
					fnAudioWriteToReg(R6_POWER_MGMT, 0b000100000);
					fnAudioWriteToReg(R4_ANALOG_PATH, 0b000001010);
					fnStartAudio(&sAxiDma, &rxBufIdx);
					xil_printf("Audio ON  | Gain: %s\r\n",
							gainBoost ? "+18dB" : "0dB");
				}
				else
				{
					audioOn = 0;
					fnAudioWriteToReg(R4_ANALOG_PATH, 0b000000010);
					fnAudioWriteToReg(R6_POWER_MGMT, 0b000110000);
					fnStopAudio(&sAxiDma);
					xil_printf("Audio OFF | Gain: %s\r\n",
							gainBoost ? "+18dB" : "0dB");
				}
				break;

			case 'l': /* BTN2: toggle gain */
				gainBoost = !gainBoost;
				fnAudioWriteToReg(R2_LEFT_DAC_VOL,  gainBoost ? DAC_VOL_BOOST : DAC_VOL_0DB);
				fnAudioWriteToReg(R3_RIGHT_DAC_VOL, gainBoost ? DAC_VOL_BOOST : DAC_VOL_0DB);
				fnAudioWriteToReg(R0_LEFT_ADC_VOL,  gainBoost ? ADC_VOL_BOOST : ADC_VOL_NORMAL);
				fnAudioWriteToReg(R1_RIGHT_ADC_VOL, gainBoost ? ADC_VOL_BOOST : ADC_VOL_NORMAL);
				xil_printf("%s | Gain: %s\r\n",
						audioOn ? "Audio ON " : "Audio OFF",
						gainBoost ? "+18dB" : "0dB");
				break;
			}

			Demo.chBtn = 0;
			Demo.fUserIOEvent = 0;
		}

		/* ---- Pipeline stall watchdog ---- */
		if (audioOn && !Demo.fDmaS2MMEvent)
		{
			if (++stallCount >= STALL_TIMEOUT)
			{
				stallCount = 0;
				fnStopAudio(&sAxiDma);
				fnStartAudio(&sAxiDma, &rxBufIdx);
			}
		}
		else
		{
			stallCount = 0;
		}

		/* ---- FFT frame received ---- */
		if (audioOn && Demo.fDmaS2MMEvent)
		{
			Demo.fDmaS2MMEvent = 0;

			u32 doneBuf = (rxBufIdx == 0) ? (u32)FFT_BUF_A : (u32)FFT_BUF_B;
			rxBufIdx = 1 - rxBufIdx;
			u32 nextBuf = (rxBufIdx == 0) ? (u32)FFT_BUF_A : (u32)FFT_BUF_B;

			Xil_DCacheInvalidateRange(doneBuf, FFT_FRAME_BYTES);

			if (Demo.fDmaError)
			{
				Demo.fDmaError = 0;
				fnConfigDma(&sAxiDma);
				XAxiDma_IntrDisable(&sAxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);
			}

			XAxiDma_SimpleTransfer(&sAxiDma, nextBuf, FFT_FRAME_BYTES,
					XAXIDMA_DEVICE_TO_DMA);

			processFFTFrame((u32 *)doneBuf, gainBoost);
		}

		/* ---- Stale events ---- */
		if (Demo.fDmaMM2SEvent)
			Demo.fDmaMM2SEvent = 0;

		if (Demo.fDmaError)
		{
			Demo.fDmaError = 0;
			fnConfigDma(&sAxiDma);
			XAxiDma_IntrDisable(&sAxiDma, XAXIDMA_IRQ_ALL_MASK,
					XAXIDMA_DMA_TO_DEVICE);
			if (audioOn)
			{
				u32 nextBuf = (rxBufIdx == 0) ? (u32)FFT_BUF_A : (u32)FFT_BUF_B;
				XAxiDma_SimpleTransfer(&sAxiDma, nextBuf, FFT_FRAME_BYTES,
						XAXIDMA_DEVICE_TO_DMA);
			}
		}
	}

	return XST_SUCCESS;
}
