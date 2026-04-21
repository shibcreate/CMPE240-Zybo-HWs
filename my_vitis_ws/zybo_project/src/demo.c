/************************************************************************/
/*  demo.c  --  Zybo Z7-10 Audio Spectrum Analyzer                     */
/*                                                                      */
/*  PL handles:                                                         */
/*    I2S RX -> stereo_to_mono -> broadcast -> I2S TX (passthrough)    */
/*                                          -> sample_buffer            */
/*                                          -> real_to_complex -> FFT   */
/*  PS handles:                                                         */
/*    DMA S2MM receives FFT output (256 complex bins)                   */
/*    Computes magnitudes, prints for debug                             */
/*                                                                      */
/************************************************************************/

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
#include "xdebug.h"
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

/************************** Constant Definitions *****************************/

#define AUDIO_SAMPLING_RATE    96000

// FFT frame: 256 complex bins, each 32 bits (16-bit real + 16-bit imag)
#define FFT_SIZE               256
#define FFT_FRAME_BYTES        (FFT_SIZE * 4)

// DMA receive buffer
#define FFT_BUF_A              (MEM_BASE_ADDR)
#define FFT_BUF_B              (MEM_BASE_ADDR + 0x10000)

// Spectrum display: 128 usable FFT bins grouped into 32 bars
#define USABLE_BINS            128
#define NUM_BARS               32
#define BINS_PER_BAR           (USABLE_BINS / NUM_BARS)

// HDMI framebuffer (640x480 @ 24bpp RGB888, 3 bytes/pixel)
#define SCREEN_WIDTH           640
#define SCREEN_HEIGHT          480
#define STRIDE                 (SCREEN_WIDTH * 3)
#define BAR_MAX_HEIGHT         400
#define BAR_BASELINE           (SCREEN_HEIGHT - 40)
#define BAR_WIDTH              (SCREEN_WIDTH / NUM_BARS)
#define BAR_GAP                2
#define FRAME_BUF_SIZE         (SCREEN_WIDTH * SCREEN_HEIGHT * 3)
#define MAG_SCALE              10.0f
#define NOISE_FLOOR            50.0f

// HDMI display IP addresses (populated after Vivado block design update)
#define DYNCLK_BASEADDR        XPAR_AXI_DYNCLK_0_S_AXI_LITE_BASEADDR
#define VTC_OUT_ID             XPAR_V_TC_OUT_DEVICE_ID
#define VDMA_ID                XPAR_AXIVDMA_0_DEVICE_ID

// Gain: toggle between 0dB and boosted via codec registers
#define DAC_VOL_0DB            0b101111001
#define DAC_VOL_BOOST          0b101111111
#define ADC_VOL_NORMAL         0b000010111
#define ADC_VOL_BOOST          0b000011111

#define RESET_TIMEOUT_COUNTER  10000
#define TEST_START_VALUE       0x0

/************************** Variable Definitions *****************************/

volatile sDemo_t Demo;

static float    magnitudes[USABLE_BINS];
static u32      barHeights[NUM_BARS];

static XIic sIic;
static XAxiDma sAxiDma;
static XGpio sUserIO;
static XAxiVdma sVdma;
static DisplayCtrl sDispCtrl;

// Framebuffers for HDMI output (aligned for DMA)
static u8 frameBuf[DISPLAY_NUM_FRAMES][SCREEN_HEIGHT][STRIDE] __attribute__((aligned(0x20)));
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

/************************** Helper Functions *********************************/

// Start I2S streaming and first DMA receive for FFT
static void fnStartAudio(XAxiDma *pAxiDma, volatile int *pRxBufIdx)
{
	*pRxBufIdx = 0;

	// Reset I2S FIFOs
	Xil_Out32(I2S_FIFO_CONTROL_REG, (1u << 30) | (1u << 31));
	Xil_Out32(I2S_FIFO_CONTROL_REG, 0x00000000);

	// Set period count to max for continuous streaming
	Xil_Out32(I2S_PERIOD_COUNT_REG, 0x000FFFFF);

	// Start I2S FIRST — let the pipeline fill before DMA starts receiving
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000003); // TX_RS | RX_RS
	Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000003);   // S2MM | MM2S

	// Wait for pipeline to fill: I2S -> mono -> broadcast -> sample_buffer
	// (256 stereo pairs at 48kHz = ~10ms) + FFT processing
	usleep(50000); // 50ms

	// NOW start DMA S2MM to receive FFT output
	XAxiDma_SimpleTransfer(pAxiDma, (u32)FFT_BUF_A, FFT_FRAME_BYTES,
			XAXIDMA_DEVICE_TO_DMA);

	xil_printf("Audio pipeline started\r\n");
}

// Stop I2S streaming
static void fnStopAudio(void)
{
	Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000000);
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000000);
}

/************************** Spectrum Processing *******************************/

// Clear all framebuffers to black
static void initFramebuffer(void)
{
	for (int i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		memset(frameBuf[i], 0, FRAME_BUF_SIZE);
		Xil_DCacheFlushRange((UINTPTR)frameBuf[i], FRAME_BUF_SIZE);
	}
}

// Render bar graph into the HDMI framebuffer (24bpp RGB888)
// Pixel layout: byte[0]=blue, byte[1]=green, byte[2]=red (per display_ctrl color bit positions)
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
			// Black above bar
			for (int y = 0; y < bar_top; y++)
			{
				int offset = y * STRIDE + x * 3;
				fb[offset]     = 0; // blue
				fb[offset + 1] = 0; // green
				fb[offset + 2] = 0; // red
			}

			// Bar: bright green at top, dark green at bottom
			if (height > 0)
			{
				for (int y = bar_top; y <= BAR_BASELINE; y++)
				{
					int dist = y - bar_top;
					u8 g = (u8)(255 - (dist * 191) / (int)height);
					int offset = y * STRIDE + x * 3;
					fb[offset]     = 0; // blue
					fb[offset + 1] = g; // green
					fb[offset + 2] = 0; // red
				}
			}

			// Black below baseline
			for (int y = BAR_BASELINE + 1; y < SCREEN_HEIGHT; y++)
			{
				int offset = y * STRIDE + x * 3;
				fb[offset]     = 0; // blue
				fb[offset + 1] = 0; // green
				fb[offset + 2] = 0; // red
			}
		}
	}

	Xil_DCacheFlushRange((UINTPTR)fb, FRAME_BUF_SIZE);
}

// Full PS processing: magnitude computation, binning, gain, render
static void processFFTFrame(u32 *pBuf, int gainBoost)
{
	// 1. Magnitude computation for 128 usable bins (Nyquist limit)
	//    FFT output is packed [imag(16) | real(16)] per 32-bit word
	//    Bin 0 (DC) is zeroed — it carries DC offset, not audio content
	magnitudes[0] = 0.0f;
	for (int i = 1; i < USABLE_BINS; i++)
	{
		int16_t re = (int16_t)(pBuf[i] & 0xFFFF);
		int16_t im = (int16_t)((pBuf[i] >> 16) & 0xFFFF);
		float mag = sqrtf((float)re * re + (float)im * im);
		magnitudes[i] = (mag > NOISE_FLOOR) ? mag - NOISE_FLOOR : 0.0f;
	}

	// 2. Digital gain: 1x normal, 4x boosted (stacks with codec gain)
	float gainScale = gainBoost ? 4.0f : 1.0f;

	// 3. Frequency binning: average BINS_PER_BAR magnitudes per bar
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

	// 4. Render into HDMI framebuffer
	renderBars();
}

/************************** Main *********************************************/

int main(void)
{
	int Status;
	volatile int rxBufIdx = 0;
	volatile int audioOn = 0;
	volatile int gainBoost = 0;
	volatile int frameCount = 0;

	Demo.u8Verbose = 0;

	xil_printf("\r\n--- Entering main() --- \r\n");

	xil_printf("Init INTC...\r\n");
	Status = fnInitInterruptController(&sIntc);
	if(Status != XST_SUCCESS) {
		xil_printf("Error initializing interrupts");
		return XST_FAILURE;
	}

	xil_printf("Init IIC...\r\n");
	Status = fnInitIic(&sIic);
	if(Status != XST_SUCCESS) {
		xil_printf("Error initializing I2C controller");
		return XST_FAILURE;
	}

	xil_printf("Init UserIO...\r\n");
	Status = fnInitUserIO(&sUserIO);
	if(Status != XST_SUCCESS) {
		xil_printf("User I/O ERROR");
		return XST_FAILURE;
	}

	xil_printf("Init DMA...\r\n");
	Status = fnConfigDma(&sAxiDma);
	if(Status != XST_SUCCESS) {
		xil_printf("DMA configuration ERROR");
		return XST_FAILURE;
	}

	xil_printf("Init Audio...\r\n");
	Status = fnInitAudio();
	if(Status != XST_SUCCESS) {
		xil_printf("Audio initializing ERROR");
		return XST_FAILURE;
	}

	// Wait for codec to stabilize
	xil_printf("Codec stabilize...\r\n");
	{
		XTime tStart, tEnd;
		XTime_GetTime(&tStart);
		do {
			XTime_GetTime(&tEnd);
		} while((tEnd-tStart)/(COUNTS_PER_SECOND/10) < 20);
	}

	Status = fnInitAudio();
	if(Status != XST_SUCCESS) {
		xil_printf("Audio initializing ERROR");
		return XST_FAILURE;
	}

	fnEnableInterrupts(&sIntc, &ivt[0], sizeof(ivt)/sizeof(ivt[0]));

	// Disable MM2S interrupts - that channel is unused (passthrough is in PL)
	XAxiDma_IntrDisable(&sAxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

	fnSetLineInput();

	// --- HDMI Display Init ---
	xil_printf("Init VDMA...\r\n");
	{
		XAxiVdma_Config *vdmaConfig = XAxiVdma_LookupConfig(VDMA_ID);
		if (!vdmaConfig) {
			xil_printf("VDMA config not found\r\n");
			return XST_FAILURE;
		}
		Status = XAxiVdma_CfgInitialize(&sVdma, vdmaConfig, vdmaConfig->BaseAddress);
		if (Status != XST_SUCCESS) {
			xil_printf("VDMA init ERROR %d\r\n", Status);
			return XST_FAILURE;
		}
	}

	xil_printf("Init Display...\r\n");
	Status = DisplayInitialize(&sDispCtrl, &sVdma, VTC_OUT_ID,
			DYNCLK_BASEADDR, framePtrs, STRIDE);
	if (Status != XST_SUCCESS) {
		xil_printf("Display init ERROR %d\r\n", Status);
		return XST_FAILURE;
	}

	xil_printf("Set mode 640x480...\r\n");
	Status = DisplaySetMode(&sDispCtrl, &VMODE_640x480);
	if (Status != XST_SUCCESS) {
		xil_printf("Display set mode ERROR\r\n");
		return XST_FAILURE;
	}

	xil_printf("Init framebuffer...\r\n");
	initFramebuffer();

	xil_printf("Display start...\r\n");
	Status = DisplayStart(&sDispCtrl);
	if (Status != XST_SUCCESS) {
		xil_printf("Display start ERROR\r\n");
		return XST_FAILURE;
	}

	xil_printf("----------------------------------------------------------\r\n");
	xil_printf("Zybo Z7-10 Audio Spectrum Analyzer\r\n");
	xil_printf("----------------------------------------------------------\r\n");
	xil_printf("  BTN3: Toggle audio ON/OFF (FFT pipeline)\r\n");
	xil_printf("  BTN2: Toggle gain boost (+18dB)\r\n");
	xil_printf("----------------------------------------------------------\r\n");
	xil_printf("Audio OFF | Gain: 0dB\r\n");
	xil_printf("HDMI: 640x480 @ 24bpp, framebuf at 0x%08x\r\n",
			(u32)framePtrs[0]);

	while(1) {

		// --- Button events ---
		if (Demo.fUserIOEvent)
		{
			switch(Demo.chBtn)
			{
				case 'r': // BTN3: toggle audio on/off
					if (!audioOn)
					{
						audioOn = 1;
						frameCount = 0;
						// Power up output + analog bypass to headphones
						fnAudioWriteToReg(R6_POWER_MGMT, 0b000100000);
						fnAudioWriteToReg(R4_ANALOG_PATH, 0b000001010);
						fnStartAudio(&sAxiDma, &rxBufIdx);
						xil_printf("Audio ON  | Gain: %s\r\n",
								gainBoost ? "+18dB" : "0dB");
					}
					else
					{
						audioOn = 0;
						// Disable bypass, mute output
						fnAudioWriteToReg(R4_ANALOG_PATH, 0b000000010);
						fnAudioWriteToReg(R6_POWER_MGMT, 0b000110000);
						fnStopAudio();
						xil_printf("Audio OFF | Gain: %s\r\n",
								gainBoost ? "+18dB" : "0dB");
					}
					break;

				case 'l': // BTN2: toggle gain boost
					gainBoost = !gainBoost;
					if (gainBoost)
					{
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

		// Debug: periodically check I2S and DMA status
		if (audioOn && !Demo.fDmaS2MMEvent)
		{
			static int dbgCount = 0;
			dbgCount++;
			if (dbgCount >= 5000000)
			{
				dbgCount = 0;
				u32 i2s_sr = Xil_In32(I2S_STATUS_REG);
				u32 dma_sr = XAxiDma_ReadReg(sAxiDma.RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
				xil_printf("I2S_SR=0x%08x DMA_S2MM_SR=0x%08x\r\n", i2s_sr, dma_sr);
			}
		}

		// --- FFT DMA receive complete ---
		if (audioOn && Demo.fDmaS2MMEvent)
		{
			Demo.fDmaS2MMEvent = 0;

			// Determine which buffer just received FFT data
			u32 doneBuf = (rxBufIdx == 0) ? (u32)FFT_BUF_A : (u32)FFT_BUF_B;
			rxBufIdx = 1 - rxBufIdx;
			u32 nextBuf = (rxBufIdx == 0) ? (u32)FFT_BUF_A : (u32)FFT_BUF_B;

			// Invalidate cache to read fresh DMA data
			Xil_DCacheInvalidateRange(doneBuf, FFT_FRAME_BYTES);

			// DMA channel halts on every transfer due to TLAST mismatch
			// from the FFT IP. Re-init the DMA for each new transfer.
			if (Demo.fDmaError)
			{
				Demo.fDmaError = 0;
				fnConfigDma(&sAxiDma);
				XAxiDma_IntrDisable(&sAxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);
			}

			// Start next DMA receive
			XAxiDma_SimpleTransfer(&sAxiDma, nextBuf, FFT_FRAME_BYTES,
					XAXIDMA_DEVICE_TO_DMA);

			// PS processing: magnitudes, binning, gain, framebuffer render
			processFFTFrame((u32 *)doneBuf, gainBoost);

			// Debug: print bar heights + raw magnitudes every ~5s
			frameCount++;
			if (frameCount >= 230)
			{
				frameCount = 0;
				// Raw DMA buffer words (before processFFTFrame)
				u32 *dbgBuf = (u32 *)doneBuf;
				xil_printf("DMA raw[0-7]: %08x %08x %08x %08x %08x %08x %08x %08x\r\n",
					dbgBuf[0], dbgBuf[1], dbgBuf[2], dbgBuf[3],
					dbgBuf[4], dbgBuf[5], dbgBuf[6], dbgBuf[7]);
				xil_printf("Bars: ");
				for (int i = 0; i < 8; i++)
					xil_printf("%d ", barHeights[i]);
				xil_printf("\r\nRaw mags [1-8]: ");
				for (int i = 1; i <= 8; i++)
					xil_printf("%d ", (int)magnitudes[i]);
				xil_printf("\r\n");
			}
		}

		// MM2S complete (unused now, passthrough is in hardware)
		if (Demo.fDmaMM2SEvent)
		{
			Demo.fDmaMM2SEvent = 0;
		}

		// DMA error without data — shouldn't happen normally
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
