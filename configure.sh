#!/bin/sh

case $1 in
x86_64)
	echo KERNEL_FLAVOR=lts
	echo QEMU_ARCH=x86_64
	echo QEMU_CONSOLE_DEV=ttyS0
	echo QEMU_DEV_SUFFIX=pci
	;;
x86)
	echo KERNEL_FLAVOR=lts
	echo QEMU_ARCH=i386
	echo QEMU_CONSOLE_DEV=ttyS0
	echo QEMU_DEV_SUFFIX=pci
	;;
aarch64)
	echo KERNEL_FLAVOR=lts
	echo FW_URL=http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-AARCH64/RELEASE_GCC5/QEMU_EFI.fd
	echo QEMU_ARCH=aarch64
	echo QEMU_ARGS=\"-M virt -cpu cortex-a57\"
	echo QEMU_CONSOLE_DEV=ttyAMA0
	echo QEMU_DEV_SUFFIX=pci
	max_cpus=8
	;;
armv7)
	echo KERNEL_FLAVOR=lts
	echo FW_URL=http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-ARM/RELEASE_GCC5/QEMU_EFI.fd
	echo QEMU_ARCH=arm
	echo QEMU_ARGS=\"-M virt -cpu cortex-a15\"
	echo QEMU_CONSOLE_DEV=ttyAMA0
	echo QEMU_DEV_SUFFIX=device
	max_cpus=8
	;;
armhf)
	echo KERNEL_FLAVOR=rpi2
	echo FW_URL=http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-ARM/RELEASE_GCC5/QEMU_EFI.fd
	echo QEMU_ARCH=arm
	echo QEMU_ARGS=\"-M virt -cpu cortex-a15\"
	echo QEMU_CONSOLE_DEV=ttyAMA0
	echo QEMU_DEV_SUFFIX=device
	max_cpus=8
	;;
ppc64le)
	echo KERNEL_FLAVOR=lts
	echo QEMU_ARCH=ppc64
	echo QEMU_CONSOLE_DEV=hvc0
	echo QEMU_DEV_SUFFIX=pci
	;;
s390x)
	echo KERNEL_FLAVOR=lts
	echo QEMU_ARCH=s390x
	echo QEMU_CONSOLE_DEV=ttysclp0
	echo QEMU_DEV_SUFFIX=ccw
	;;
*)
	echo Unsupported architechture. >&2
	exit 1
esac

smp_cpus=$(nproc)
if [ -n "$max_cpus" ] && [ "$smp_cpus" -gt "$max_cpus" ]; then
	smp_cpus=$max_cpus
fi
echo QEMU_SMP=$smp_cpus
