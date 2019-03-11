dtb_name=vexpress-v2p-ca15-tc1.dtb
curl -O http://dl-cdn.alpinelinux.org/alpine/edge/releases/armhf/netboot/dtbs/$dtb_name

QEMU_SYSTEM=qemu-system-arm
KERNEL_ARGS="console=ttyAMA0"
DEVICE_SUFFIX=device
QEMU_ARGS="-M vexpress-a15 -dtb $dtb_name"
