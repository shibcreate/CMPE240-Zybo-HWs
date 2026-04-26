// dma.c
// AXI DMA interrupt handlers and configuration
// Based on Digilent audio demo, modified for FFT data transfer
// CMPE240 Spring 2026

#include "dma.h"
#include "../demo.h"

extern volatile DemoState Demo;
extern XAxiDma_Config *pCfgPtr;

void fnS2MMInterruptHandler (void *Callback)
{
	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);

	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK))
		return;

	/* USER CODE BEGIN S2MM Error Handling */
	// DMA error fires each frame due to TLAST mismatch but data is still valid
	// reset the channel since it halts on any error
	if (IrqStatus & XAXIDMA_IRQ_ERROR_MASK)
	{
		Demo.fDmaError = 1;
		XAxiDma_Reset(AxiDmaInst);
		TimeOut = 1000;
		while (TimeOut)
		{
			if(XAxiDma_ResetIsDone(AxiDmaInst))
				break;
			TimeOut -= 1;
		}
	}

	// flag completion regardless of error since FFT data is valid
	if (IrqStatus & XAXIDMA_IRQ_IOC_MASK)
	{
		Demo.fDmaS2MMEvent = 1;
	}
	/* USER CODE END S2MM Error Handling */
}

void fnMM2SInterruptHandler (void *Callback)
{
	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DMA_TO_DEVICE);
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DMA_TO_DEVICE);

	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK))
		return;

	if (IrqStatus & XAXIDMA_IRQ_ERROR_MASK){
		Demo.fDmaError = 1;
		XAxiDma_Reset(AxiDmaInst);
		TimeOut = 1000;
		while (TimeOut)
		{
			if(XAxiDma_ResetIsDone(AxiDmaInst))
				break;
			TimeOut -= 1;
		}
		return;
	}
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK))
	{
		Demo.fDmaMM2SEvent = 1;
	}
}

XStatus fnConfigDma(XAxiDma *AxiDma)
{
	int Status;
	XAxiDma_Config *pCfgPtr;

	pCfgPtr = XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
	if (!pCfgPtr)
	{
		if (Demo.u8Verbose)
			xil_printf("\r\nNo config found for %d", XPAR_AXIDMA_0_DEVICE_ID);
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(AxiDma, pCfgPtr);
	if (Status != XST_SUCCESS)
	{
		if (Demo.u8Verbose)
			xil_printf("\r\nInitialization failed %d");
		return XST_FAILURE;
	}

	if(XAxiDma_HasSg(AxiDma))
	{
		if (Demo.u8Verbose)
			xil_printf("\r\nDevice configured as SG mode");
		return XST_FAILURE;
	}

	XAxiDma_IntrDisable(AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

	/* USER CODE BEGIN DMA Config */
	// only enable S2MM interrupts (MM2S unused, passthrough is in PL)
	XAxiDma_IntrEnable(AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	/* USER CODE END DMA Config */

	return XST_SUCCESS;
}
