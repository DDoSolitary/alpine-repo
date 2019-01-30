curl -o APKBUILD https://git.alpinelinux.org/aports/plain/main/linux-vanilla/APKBUILD?h=3.8-stable
kver=$(awk -F = '$1 == "pkgver" { print $2 }' APKBUILD)
krel=$(awk -F = '$1 == "pkgrel" { print $2 }' APKBUILD)
dtb_name=vexpress-v2p-ca15-tc1.dtb
curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/armhf/linux-vanilla-$kver-r$krel.apk | tar xz --warning=none --strip=3 usr/lib/linux-$kver-$krel-vanilla/$dtb_name

QEMU_SYSTEM=qemu-system-arm
KERNEL_ARGS="console=ttyAMA0"
DEVICE_SUFFIX=device
QEMU_ARGS="-M vexpress-a15 -dtb $dtb_name"
