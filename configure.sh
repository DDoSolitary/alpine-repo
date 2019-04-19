#!/bin/sh

case $1 in
x86_64)
	echo QEMU_ARCH=x86_64
	echo QEMU_CONSOLE_DEV=ttyS0
	echo QEMU_DEV_SUFFIX=pci
	;;
x86)
	echo QEMU_ARCH=i386
	echo QEMU_CONSOLE_DEV=ttyS0
	echo QEMU_DEV_SUFFIX=pci
	;;
aarch64)
	echo FW_URL=http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-AARCH64/RELEASE_GCC5/QEMU_EFI.fd
	echo QEMU_ARCH=aarch64
	echo QEMU_ARGS=\"-M virt -cpu cortex-a57\"
	echo QEMU_CONSOLE_DEV=ttyAMA0
	echo QEMU_DEV_SUFFIX=pci
	;;
armhf|armv7)
	echo FW_URL=http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-ARM/RELEASE_GCC5/QEMU_EFI.fd
	echo QEMU_ARCH=arm
	echo QEMU_ARGS=\"-M virt -cpu cortex-a15\"
	echo QEMU_CONSOLE_DEV=ttyAMA0
	echo QEMU_DEV_SUFFIX=device
	;;
ppc64le)
	echo QEMU_ARCH=ppc64
	echo QEMU_CONSOLE_DEV=hvc0
	echo QEMU_DEV_SUFFIX=pci
	;;
s390x)
	echo QEMU_ARCH=s390x
	echo QEMU_CONSOLE_DEV=ttysclp0
	echo QEMU_DEV_SUFFIX=ccw
	;;
*)
	echo Unsupported architechture. >&2
	exit 1
esac
