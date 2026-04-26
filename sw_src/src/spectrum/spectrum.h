// spectrum.h
// FFT spectrum computation and HDMI bar rendering (all custom)
// CMPE240 Spring 2026

#ifndef SPECTRUM_H_
#define SPECTRUM_H_

#include "xil_types.h"
#include "display_ctrl/display_ctrl.h"

#define SCREEN_WIDTH   640
#define SCREEN_HEIGHT  480
#define STRIDE         (SCREEN_WIDTH * 3)
#define FRAME_BUF_SIZE (SCREEN_WIDTH * SCREEN_HEIGHT * 3)

extern u8 *framePtrs[DISPLAY_NUM_FRAMES];

void initBinMapping(void);
void initFramebuffer(void);
void processFFTFrame(u32 *pBuf, int gainBoost, DisplayCtrl *dispCtrl);

#endif
