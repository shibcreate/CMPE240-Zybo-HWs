# Zybo Z7-10 Spectrum Analyzer - Project Notes

## Vivado 2025.2 GP1 APER_CLK Bug

When M_AXI_GP1 is enabled on the Zynq PS7, Vivado does NOT update `ps7_init.c`/`ps7_init.tcl` to enable the GP1 AMBA peripheral clock. This causes all AXI transactions on GP1 to hang silently.

**Fix:** After every XSA export / platform update, check `_ide/psinit/ps7_init.tcl` for register `0xF800012C` (APER_CLK_CTRL). Bit 20 must be set:

- Wrong: `mask_write 0XF800012C 0x01FFCCCD 0x01EC044D`
- Correct: `mask_write 0XF800012C 0x01FFCCCD 0x01FC044D`

There are 3 occurrences in the file — all must be patched. Vivado may revert this on every XSA export.

## HDMI IPs on GP1

The HDMI peripherals (VDMA, VTC, dynclk) are connected via M_AXI_GP1 through `axi_interconnect_hdmi`:
- VDMA: `0x83000000`
- dynclk: `0x83C00000`
- VTC: `0x83C10000`

## Bitstream / XSA Update Checklist

After generating a new bitstream:
1. Check ps7_init.tcl GP1 patch (see above)
2. Export XSA from Vivado
3. Update platform in Vitis
4. Re-check ps7_init.tcl (export can overwrite the patch)
5. Copy bitstream: `cp hw.runs/impl_1/system_wrapper.bit my_vitis_ws/zybo_project/_ide/bitstream/`
6. Build and run
