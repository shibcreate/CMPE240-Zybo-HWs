/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
int main()
{
    init_platform();
    xil_printf("\n UART working \n");
    u32* address = (u32*) XPAR_AXI_BRAM_CTRL_0_BASEADDR;
    for (u32 i = 0; i < 10; i++)
    {
        xil_printf ("Memory address %u has %u\n", i, *(address+i) );
    }
    cleanup_platform();
    return 0;
}
