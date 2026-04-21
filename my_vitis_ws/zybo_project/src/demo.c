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
#define NUM_BARS            24
#define NOISE_FLOOR         10.0f
#define MAG_SCALE           2.5f

/* Frequency regions: 5 bass + 10 vocal + 9 highs with visual gaps */
#define BASS_BARS           5
#define MID_BARS            10
#define HIGH_BARS           9
#define GROUP_GAP           8      /* extra pixels between regions */

/* HDMI framebuffer (640x480 @ 24bpp RGB888) */
#define SCREEN_WIDTH        640
#define SCREEN_HEIGHT       480
#define STRIDE              (SCREEN_WIDTH * 3)
#define FRAME_BUF_SIZE      (SCREEN_WIDTH * SCREEN_HEIGHT * 3)
#define BAR_MAX_HEIGHT      310
#define BAR_BASELINE        350
#define BAR_TOTAL_W         (SCREEN_WIDTH * 5 / 6)
#define BAR_LEFT            ((SCREEN_WIDTH - BAR_TOTAL_W) / 2)
#define BAR_WIDTH_PX        ((BAR_TOTAL_W - 2 * GROUP_GAP) / NUM_BARS)
#define BAR_GAP             2
#define MIRROR_HEIGHT       80
#define BG_R 8
#define BG_G 8
#define BG_B 12

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
static u32    peakHeights[NUM_BARS];   /* peak-hold dot position */
static u8     peakHold[NUM_BARS];      /* frames to hold before falling */

#define PEAK_HOLD_FRAMES    12   /* how long peak dot stays before falling */
#define PEAK_FALL_RATE      4    /* pixels per frame the peak falls */
#define SMOOTH_DECAY        0.7f  /* bar fall-off factor (0-1, higher = slower) */

/* Log-spaced bin mapping: each bar covers [binStart, binEnd] */
static int binStart[NUM_BARS];
static int binEnd[NUM_BARS];

/* Per-bar color (RGB) — gradient from blue(bass) → green(mids) → cyan(highs) */
static u8 barColorR[NUM_BARS];
static u8 barColorG[NUM_BARS];
static u8 barColorB[NUM_BARS];

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

/* Per-bar x position (accounts for group gaps) */
static int barX[NUM_BARS];

static void initBinMapping(void)
{
	/* Pop-biased frequency mapping (256-pt FFT @ 48kHz, ~187.5Hz/bin):
	 *   Bass  (5 bars):  bins 1-4   (~187Hz-750Hz)   - kick, bass, low synth
	 *   Vocal (10 bars): bins 4-35  (~750Hz-6.6kHz)  - vocals, guitar, keys, snare
	 *   High  (9 bars):  bins 35-80 (~6.6kHz-15kHz)  - hi-hat, cymbal, air
	 * Within each group, bins are log-spaced. */
	struct { int lo; int hi; int nBars; int barOff; } groups[3] = {
		{ 1,   4,   BASS_BARS, 0 },
		{ 4,   35,  MID_BARS,  BASS_BARS },
		{ 35,  80,  HIGH_BARS, BASS_BARS + MID_BARS }
	};

	for (int g = 0; g < 3; g++)
	{
		float logLo = logf((float)groups[g].lo);
		float logHi = logf((float)groups[g].hi);
		for (int i = 0; i < groups[g].nBars; i++)
		{
			int b = groups[g].barOff + i;
			float t0 = (float)i / groups[g].nBars;
			float t1 = (float)(i + 1) / groups[g].nBars;
			binStart[b] = (int)(expf(logLo + t0 * (logHi - logLo)) + 0.5f);
			binEnd[b]   = (int)(expf(logLo + t1 * (logHi - logLo)) + 0.5f) - 1;
			if (binEnd[b] < binStart[b]) binEnd[b] = binStart[b];
			if (binEnd[b] >= USABLE_BINS) binEnd[b] = USABLE_BINS - 1;
		}
	}

	/* Compute bar X positions with group gaps */
	for (int b = 0; b < NUM_BARS; b++)
	{
		int groupOffset = 0;
		if (b >= BASS_BARS) groupOffset += GROUP_GAP;
		if (b >= BASS_BARS + MID_BARS) groupOffset += GROUP_GAP;
		barX[b] = BAR_LEFT + b * BAR_WIDTH_PX + groupOffset;
	}

	/* Color: blue/purple (bass) → green/yellow (mids) → cyan (highs) */
	for (int b = 0; b < NUM_BARS; b++)
	{
		if (b < BASS_BARS)
		{
			/* Deep blue → purple */
			float s = (float)b / BASS_BARS;
			barColorR[b] = (u8)(40 + 100 * s);
			barColorG[b] = (u8)(30 + 30 * s);
			barColorB[b] = (u8)(255 - 40 * s);
		}
		else if (b < BASS_BARS + MID_BARS)
		{
			/* Green-yellow (vocal range) */
			float s = (float)(b - BASS_BARS) / MID_BARS;
			barColorR[b] = (u8)(40 * s);
			barColorG[b] = (u8)(200 + 55 * s);
			barColorB[b] = (u8)(30 + 20 * s);
		}
		else
		{
			/* Cyan → light blue */
			float s = (float)(b - BASS_BARS - MID_BARS) / HIGH_BARS;
			barColorR[b] = (u8)(20 + 30 * s);
			barColorG[b] = (u8)(180 + 40 * s);
			barColorB[b] = (u8)(200 + 55 * s);
		}
	}
}

static inline void setPixel(u8 *fb, int x, int y, u8 r, u8 g, u8 b)
{
	int off = y * STRIDE + x * 3;
	fb[off] = b; fb[off+1] = g; fb[off+2] = r;
}

/* Minimal 5x7 bitmap font for labels */
static const u8 font5x7[][5] = {
	[' '] = {0x00,0x00,0x00,0x00,0x00},
	['A'] = {0x7E,0x11,0x11,0x11,0x7E},
	['B'] = {0x7F,0x49,0x49,0x49,0x36},
	['C'] = {0x3E,0x41,0x41,0x41,0x22},
	['D'] = {0x7F,0x41,0x41,0x22,0x1C},
	['E'] = {0x7F,0x49,0x49,0x49,0x41},
	['G'] = {0x3E,0x41,0x49,0x49,0x3A},
	['H'] = {0x7F,0x08,0x08,0x08,0x7F},
	['I'] = {0x00,0x41,0x7F,0x41,0x00},
	['L'] = {0x7F,0x40,0x40,0x40,0x40},
	['O'] = {0x3E,0x41,0x41,0x41,0x3E},
	['S'] = {0x26,0x49,0x49,0x49,0x32},
	['V'] = {0x1F,0x20,0x40,0x20,0x1F},
};

static void drawChar(u8 *fb, int cx, int cy, char ch, u8 r, u8 g, u8 b, int scale)
{
	if (ch < ' ' || ch > 'Z') return;
	const u8 *glyph = font5x7[(int)ch];
	for (int col = 0; col < 5; col++)
	{
		u8 bits = glyph[col];
		for (int row = 0; row < 7; row++)
		{
			if (bits & (1 << row))
			{
				for (int sy = 0; sy < scale; sy++)
					for (int sx = 0; sx < scale; sx++)
						setPixel(fb, cx + col*scale + sx, cy + row*scale + sy, r, g, b);
			}
		}
	}
}

static void drawString(u8 *fb, int x, int y, const char *str, u8 r, u8 g, u8 b, int scale)
{
	while (*str)
	{
		drawChar(fb, x, y, *str, r, g, b, scale);
		x += 6 * scale;
		str++;
	}
}

static void initFramebuffer(void)
{
	for (int i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		u8 *fb = frameBuf[i][0];
		for (int y = 0; y < SCREEN_HEIGHT; y++)
			for (int x = 0; x < SCREEN_WIDTH; x++)
			{
				int off = y * STRIDE + x * 3;
				fb[off] = BG_B; fb[off+1] = BG_G; fb[off+2] = BG_R;
			}
		Xil_DCacheFlushRange((UINTPTR)frameBuf[i], FRAME_BUF_SIZE);
	}
}

static int drawFrame = 0;   /* frame we render into (back buffer) */

static void renderBars(void)
{
	u8 *fb = frameBuf[drawFrame][0];

	/* Fast clear: fill one scanline then memcpy to the rest */
	for (int x = 0; x < SCREEN_WIDTH; x++)
	{
		int off = x * 3;
		fb[off] = BG_B; fb[off+1] = BG_G; fb[off+2] = BG_R;
	}
	for (int y = 1; y < SCREEN_HEIGHT; y++)
		memcpy(fb + y * STRIDE, fb, STRIDE);

	for (int b = 0; b < NUM_BARS; b++)
	{
		int x_start = barX[b] + BAR_GAP;
		int x_end   = barX[b] + BAR_WIDTH_PX;
		int height  = (int)barHeights[b];
		int bar_top = BAR_BASELINE - height;
		if (bar_top < 0) bar_top = 0;
		u8 cr = barColorR[b], cg = barColorG[b], cb = barColorB[b];

		for (int x = x_start; x < x_end; x++)
		{
			/* Main bar: bright at top, darker at bottom */
			if (height > 0)
			{
				for (int y = bar_top; y <= BAR_BASELINE; y++)
				{
					int dist = y - bar_top;
					int bright = 255 - (dist * 130) / (height > 0 ? height : 1);
					u8 r = (u8)(cr * bright / 255);
					u8 g = (u8)(cg * bright / 255);
					u8 b_ = (u8)(cb * bright / 255);
					setPixel(fb, x, y, r, g, b_);
				}

				/* Top glow: bright white-ish highlight on top 3 rows */
				for (int gy = 0; gy < 3 && (bar_top + gy) <= BAR_BASELINE; gy++)
				{
					int glow = 200 - gy * 60;
					u8 r = (u8)((cr + glow > 255) ? 255 : cr + glow);
					u8 g = (u8)((cg + glow > 255) ? 255 : cg + glow);
					u8 b_ = (u8)((cb + glow > 255) ? 255 : cb + glow);
					setPixel(fb, x, bar_top + gy, r, g, b_);
				}
			}

			/* Mirror reflection (faded, below baseline) */
			if (height > 0)
			{
				int mirrorH = height < MIRROR_HEIGHT ? height : MIRROR_HEIGHT;
				for (int m = 0; m < mirrorH; m++)
				{
					int y = BAR_BASELINE + 1 + m;
					if (y >= SCREEN_HEIGHT) break;
					int fade = 60 - (m * 60) / MIRROR_HEIGHT;
					u8 r = (u8)(cr * fade / 255) + BG_R;
					u8 g = (u8)(cg * fade / 255) + BG_G;
					u8 b_ = (u8)(cb * fade / 255) + BG_B;
					setPixel(fb, x, y, r, g, b_);
				}
			}

			/* Peak hold dot */
			if (peakHeights[b] > 0)
			{
				int peakY = BAR_BASELINE - (int)peakHeights[b];
				if (peakY >= 0 && peakY < SCREEN_HEIGHT)
				{
					setPixel(fb, x, peakY, 255, 255, 255);
					if (peakY + 1 <= BAR_BASELINE)
						setPixel(fb, x, peakY + 1, cr, cg, cb);
				}
			}
		}
	}

	/* Group labels below mirror */
	int labelY = BAR_BASELINE + MIRROR_HEIGHT + 12;
	int bassMid = barX[0] + (BASS_BARS * BAR_WIDTH_PX) / 2 - 12;
	int midsMid = barX[BASS_BARS] + (MID_BARS * BAR_WIDTH_PX) / 2 - 15;
	int highMid = barX[BASS_BARS + MID_BARS] + (HIGH_BARS * BAR_WIDTH_PX) / 2 - 12;

	drawString(fb, bassMid, labelY, "BASS",  barColorR[0], barColorG[0], barColorB[0], 2);
	drawString(fb, midsMid, labelY, "VOCAL", barColorR[BASS_BARS], barColorG[BASS_BARS], barColorB[BASS_BARS], 2);
	drawString(fb, highMid, labelY, "HIGH",  barColorR[BASS_BARS+MID_BARS], barColorG[BASS_BARS+MID_BARS], barColorB[BASS_BARS+MID_BARS], 2);

	Xil_DCacheFlushRange((UINTPTR)fb, FRAME_BUF_SIZE);

	/* Swap: tell VDMA to display the frame we just finished, then switch draw target */
	DisplayChangeFrame(&sDispCtrl, drawFrame);
	drawFrame = (drawFrame + 1) % DISPLAY_NUM_FRAMES;
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

	float gainScale = gainBoost ? 1.5f : 1.0f;

	/* Per-group gain: bass is naturally louder in FFT, so attenuate it
	 * and boost mids/highs to balance the display across groups. */
	static const float groupGain[3] = { 0.4f, 1.0f, 1.8f };

	for (int b = 0; b < NUM_BARS; b++)
	{
		float peak = 0.0f;
		for (int i = binStart[b]; i <= binEnd[b]; i++)
			if (magnitudes[i] > peak) peak = magnitudes[i];

		int g = (b < BASS_BARS) ? 0 : (b < BASS_BARS + MID_BARS) ? 1 : 2;
		float avg = peak * gainScale * groupGain[g];
		u32 h = (u32)(avg / MAG_SCALE);
		if (h > BAR_MAX_HEIGHT) h = BAR_MAX_HEIGHT;

		/* Smooth decay: bars fall gradually instead of snapping down */
		u32 prev = barHeights[b];
		if (h >= prev)
			barHeights[b] = h;
		else
			barHeights[b] = (u32)(prev * SMOOTH_DECAY);

		/* Peak hold: track highest point, hold, then fall */
		if (barHeights[b] >= peakHeights[b])
		{
			peakHeights[b] = barHeights[b];
			peakHold[b] = PEAK_HOLD_FRAMES;
		}
		else if (peakHold[b] > 0)
		{
			peakHold[b]--;
		}
		else
		{
			if (peakHeights[b] > PEAK_FALL_RATE)
				peakHeights[b] -= PEAK_FALL_RATE;
			else
				peakHeights[b] = 0;
		}
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

	initBinMapping();
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
