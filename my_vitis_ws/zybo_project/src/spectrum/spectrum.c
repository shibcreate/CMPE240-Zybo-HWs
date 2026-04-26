// spectrum.c
// All custom rendering logic for the spectrum analyzer display
// Handles FFT magnitude computation, log-frequency binning, and HDMI bar rendering
// CMPE240 Spring 2026

#include "spectrum.h"
#include "xil_cache.h"
#include <math.h>

#define USABLE_BINS    128
#define NUM_BARS       24
#define NOISE_FLOOR    10.0f
#define MAG_SCALE      2.5f

#define BASS_BARS      5
#define MID_BARS       10
#define HIGH_BARS      9
#define GROUP_GAP      8

#define BAR_MAX_HEIGHT 310
#define BAR_BASELINE   350
#define BAR_TOTAL_W    (SCREEN_WIDTH * 5 / 6)
#define BAR_LEFT       ((SCREEN_WIDTH - BAR_TOTAL_W) / 2)
#define BAR_WIDTH_PX   ((BAR_TOTAL_W - 2 * GROUP_GAP) / NUM_BARS)
#define BAR_GAP        2
#define MIRROR_HEIGHT  80

#define BG_R 8
#define BG_G 8
#define BG_B 12

#define PEAK_HOLD_FRAMES 12
#define PEAK_FALL_RATE   4
#define SMOOTH_DECAY     0.7f

static float magnitudes[USABLE_BINS];
static u32   barHeights[NUM_BARS];
static u32   peakHeights[NUM_BARS];
static u8    peakHold[NUM_BARS];

static int binStart[NUM_BARS];
static int binEnd[NUM_BARS];

static u8 barColorR[NUM_BARS];
static u8 barColorG[NUM_BARS];
static u8 barColorB[NUM_BARS];

static int barX[NUM_BARS];
static int drawFrame = 0;

// framebuffer owned here, framePtrs exposed for VDMA init in demo.c
static u8 frameBuf[DISPLAY_NUM_FRAMES][SCREEN_HEIGHT][STRIDE]
	__attribute__((aligned(0x20)));
u8 *framePtrs[DISPLAY_NUM_FRAMES] = {
	frameBuf[0][0], frameBuf[1][0], frameBuf[2][0], frameBuf[3][0]
};

// 5x7 bitmap font for on-screen labels
static const u8 font5x7[][5] = {
	[' '] = {0x00,0x00,0x00,0x00,0x00},
	['A'] = {0x7E,0x11,0x11,0x11,0x7E},
	['B'] = {0x7F,0x49,0x49,0x49,0x36},
	['C'] = {0x3E,0x41,0x41,0x41,0x22},
	['D'] = {0x7F,0x41,0x41,0x22,0x1C},
	['E'] = {0x7F,0x49,0x49,0x49,0x41},
	['F'] = {0x7F,0x09,0x09,0x09,0x01},
	['G'] = {0x3E,0x41,0x49,0x49,0x3A},
	['H'] = {0x7F,0x08,0x08,0x08,0x7F},
	['I'] = {0x00,0x41,0x7F,0x41,0x00},
	['L'] = {0x7F,0x40,0x40,0x40,0x40},
	['M'] = {0x7F,0x02,0x0C,0x02,0x7F},
	['N'] = {0x7F,0x04,0x08,0x10,0x7F},
	['O'] = {0x3E,0x41,0x41,0x41,0x3E},
	['P'] = {0x7F,0x09,0x09,0x09,0x06},
	['R'] = {0x7F,0x09,0x19,0x29,0x46},
	['S'] = {0x26,0x49,0x49,0x49,0x32},
	['T'] = {0x01,0x01,0x7F,0x01,0x01},
	['U'] = {0x3F,0x40,0x40,0x40,0x3F},
	['V'] = {0x1F,0x20,0x40,0x20,0x1F},
	['Y'] = {0x07,0x08,0x70,0x08,0x07},
	['Z'] = {0x61,0x51,0x49,0x45,0x43},
};

static void setPixel(u8 *fb, int x, int y, u8 r, u8 g, u8 b)
{
	int off = y * STRIDE + x * 3;
	fb[off] = b; fb[off+1] = g; fb[off+2] = r;
}

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

void initBinMapping(void)
{
	// log-spaced bin mapping for 256-pt FFT @ 48kHz (~187.5 Hz/bin)
	// bass(5): bins 1-4, vocal(10): bins 4-35, high(9): bins 35-80
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

	for (int b = 0; b < NUM_BARS; b++)
	{
		int groupOffset = 0;
		if (b >= BASS_BARS) groupOffset += GROUP_GAP;
		if (b >= BASS_BARS + MID_BARS) groupOffset += GROUP_GAP;
		barX[b] = BAR_LEFT + b * BAR_WIDTH_PX + groupOffset;
	}

	// color gradient: blue/purple (bass) -> green/yellow (mids) -> cyan (highs)
	for (int b = 0; b < NUM_BARS; b++)
	{
		if (b < BASS_BARS)
		{
			float s = (float)b / BASS_BARS;
			barColorR[b] = (u8)(40 + 100 * s);
			barColorG[b] = (u8)(30 + 30 * s);
			barColorB[b] = (u8)(255 - 40 * s);
		}
		else if (b < BASS_BARS + MID_BARS)
		{
			float s = (float)(b - BASS_BARS) / MID_BARS;
			barColorR[b] = (u8)(40 * s);
			barColorG[b] = (u8)(200 + 55 * s);
			barColorB[b] = (u8)(30 + 20 * s);
		}
		else
		{
			float s = (float)(b - BASS_BARS - MID_BARS) / HIGH_BARS;
			barColorR[b] = (u8)(20 + 30 * s);
			barColorG[b] = (u8)(180 + 40 * s);
			barColorB[b] = (u8)(200 + 55 * s);
		}
	}
}

void initFramebuffer(void)
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

static void renderBars(DisplayCtrl *dispCtrl)
{
	u8 *fb = frameBuf[drawFrame][0];

	// gradient background
	for (int y = 0; y < SCREEN_HEIGHT; y++)
	{
		int t = y * 6 / SCREEN_HEIGHT;
		u8 br = BG_R + t;
		u8 bg = BG_G + t;
		u8 bb = BG_B + t + t;
		for (int x = 0; x < SCREEN_WIDTH; x++)
		{
			int off = y * STRIDE + x * 3;
			fb[off] = bb; fb[off+1] = bg; fb[off+2] = br;
		}
	}

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
			// main bar with brightness gradient
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

				// glow on top 3 rows
				for (int gy = 0; gy < 3 && (bar_top + gy) <= BAR_BASELINE; gy++)
				{
					int glow = 200 - gy * 60;
					u8 r = (u8)((cr + glow > 255) ? 255 : cr + glow);
					u8 g = (u8)((cg + glow > 255) ? 255 : cg + glow);
					u8 b_ = (u8)((cb + glow > 255) ? 255 : cb + glow);
					setPixel(fb, x, bar_top + gy, r, g, b_);
				}
			}

			// mirror reflection below baseline
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

			// peak hold dot
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

	// group labels
	int labelY = BAR_BASELINE + MIRROR_HEIGHT + 12;
	int bassMid = barX[0] + (BASS_BARS * BAR_WIDTH_PX) / 2 - 12;
	int midsMid = barX[BASS_BARS] + (MID_BARS * BAR_WIDTH_PX) / 2 - 15;
	int highMid = barX[BASS_BARS + MID_BARS] + (HIGH_BARS * BAR_WIDTH_PX) / 2 - 12;

	drawString(fb, bassMid, labelY, "BASS",  barColorR[0], barColorG[0], barColorB[0], 2);
	drawString(fb, midsMid, labelY, "VOCAL", barColorR[BASS_BARS], barColorG[BASS_BARS], barColorB[BASS_BARS], 2);
	drawString(fb, highMid, labelY, "HIGH",  barColorR[BASS_BARS+MID_BARS], barColorG[BASS_BARS+MID_BARS], barColorB[BASS_BARS+MID_BARS], 2);

	const char *title = "SPECTRUM ANALYZER";
	int titleLen = 17;
	int titleX = (SCREEN_WIDTH - titleLen * 6 * 2) / 2;
	drawString(fb, titleX, 10, title, 50, 55, 70, 2);

	// top color bar blended by frequency group energy
	float bassE = 0, vocalE = 0, highE = 0;
	for (int b = 0; b < BASS_BARS; b++) bassE += barHeights[b];
	for (int b = BASS_BARS; b < BASS_BARS + MID_BARS; b++) vocalE += barHeights[b];
	for (int b = BASS_BARS + MID_BARS; b < NUM_BARS; b++) highE += barHeights[b];
	float total = bassE + vocalE + highE;
	float bw = 0, vw = 0, hw = 0;
	if (total > 0) { bw = bassE / total; vw = vocalE / total; hw = highE / total; }
	u8 topR = (u8)(barColorR[0] * bw + barColorR[BASS_BARS] * vw + barColorR[BASS_BARS+MID_BARS] * hw);
	u8 topG = (u8)(barColorG[0] * bw + barColorG[BASS_BARS] * vw + barColorG[BASS_BARS+MID_BARS] * hw);
	u8 topB = (u8)(barColorB[0] * bw + barColorB[BASS_BARS] * vw + barColorB[BASS_BARS+MID_BARS] * hw);
	for (int y = 0; y < 3; y++)
		for (int x = 0; x < SCREEN_WIDTH; x++)
		{
			int fade = 255 - y * 60;
			setPixel(fb, x, y, topR * fade / 255, topG * fade / 255, topB * fade / 255);
		}

	Xil_DCacheFlushRange((UINTPTR)fb, FRAME_BUF_SIZE);

	// swap buffers
	DisplayChangeFrame(dispCtrl, drawFrame);
	drawFrame = (drawFrame + 1) % DISPLAY_NUM_FRAMES;
}

void processFFTFrame(u32 *pBuf, int gainBoost, DisplayCtrl *dispCtrl)
{
	// compute magnitude for each FFT bin
	magnitudes[0] = 0.0f;
	for (int i = 1; i < USABLE_BINS; i++)
	{
		int16_t re = (int16_t)(pBuf[i] & 0xFFFF);
		int16_t im = (int16_t)((pBuf[i] >> 16) & 0xFFFF);
		float mag = sqrtf((float)re * re + (float)im * im);
		magnitudes[i] = (mag > NOISE_FLOOR) ? mag - NOISE_FLOOR : 0.0f;
	}

	float gainScale = gainBoost ? 1.5f : 1.0f;

	// per-group gain to balance bass vs mids vs highs on display
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

		// smooth decay so bars fall gradually
		u32 prev = barHeights[b];
		if (h >= prev)
			barHeights[b] = h;
		else
			barHeights[b] = (u32)(prev * SMOOTH_DECAY);

		// peak hold dot
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

	renderBars(dispCtrl);
}
