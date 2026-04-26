// dma.h
// AXI DMA driver interface
// CMPE240 Spring 2026

#ifndef DMA_H_
#define DMA_H_

#include "xparameters.h"
#include "xil_printf.h"
#include "xaxidma.h"

void fnS2MMInterruptHandler (void *Callback);
void fnMM2SInterruptHandler (void *Callback);
XStatus fnConfigDma(XAxiDma *AxiDma);

#endif /* DMA_H_ */
