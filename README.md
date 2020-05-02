# Lichee Pi Nano Buildroot External Tree

This repo includes a Buildroot external tree to build U-Boot and Linux images for the Sipeed Lichee Pi Nano development board.
It is based on Buildroot v2020.02.1.

Both booting from flash and from MMC are supported (with different Buildroot configs).

Patched U-Boot is based on v2020.01 and is available [here](https://github.com/florpor/u-boot/tree/licheepi-nano-v2020.01) and Linux is based on v5.4.36 and is available [here](https://github.com/florpor/linux/tree/licheepi-nano-v5.4.y).

## Building

To build images start by initializing submodules to pull Buildroot source:

```bash
$ git submodule update --init
```

Then to start building (will take a while from a clean source tree) cd into its directory and run:

```bash
$ cd buildroot
$ make BR2_EXTERNAL=$PWD/../ licheepi_nano_defconfig
$ make
```

### Flash images to device

To flash to the device's chip use [sunxi-tools](https://github.com/linux-sunxi/sunxi-tools)'s sunxi-fel:

```bash
$ sudo ./sunxi-fel -p spiflash-write 0 output/images/flash.bin
```

For this to work the device must be in FEL mode (meaning the BootROM has activated a program communicating with hosts via USB using the [FEL protocol](https://linux-sunxi.org/FEL/Protocol)).
To make this happen the BootROM needs to believe it has nothing to boot in the flash memory.

This can be achieved by erasing the beginning of the device's memory if you have access to a U-Boot shell:
```bash
=> sf probe 0
=> sf erase 0 0x10000
=> reset
```

If you don't have access to U-Boot or it is does not allow you to erase flash memory for some reason, you can also short pins 1 and 4 of the flash chip as you connect power to your board. Once power is connected you can un-short the pins and FEL mode should be available.

### Flash vs MMC

Besides the default setting for storing everything (bootloader, device tree, kernel and root filesystem) on the 16M flash memory chip you can also boot from an MMC card.
To do this use the mmc config when configuring Buildroot:

```bash
$ make BR2_EXTERNAL=$PWD/../ licheepi_nano_mmc_defconfig
$ make
```

You will then end up with 2 images - one for the flash memory and another for the sd card.

The flash.bin image can be flashed to the device's chip as above (also, you can just flash the u-boot-sunxi-with-spl.bin file instead of flash.bin for the same effect).

The sdcard.img should be flashed to an sd card using dd or whatever method you prefer:

```bash
$ sudo dd if=output/images/sdcard.img of=/dev/mmcblkX
```
