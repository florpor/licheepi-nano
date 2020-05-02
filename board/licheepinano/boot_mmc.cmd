setenv bootargs console=tty0 console=ttyS0,115200 panic=5 rootwait root=/dev/mmcblk0p3 rw rootfstype=ext4
load mmc 0:2 0x80008000 zImage
load mmc 0:2 0x80C00000 suniv-f1c100s-licheepi-nano.dtb
bootz 0x80008000 - 0x80C00000
