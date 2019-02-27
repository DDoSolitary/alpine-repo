sudo apt-get install -y -qq build-essential gcc-powerpc64le-linux-gnu bison flex bc libssl-dev squashfs-tools > /dev/null
curl -O http://dl-cdn.alpinelinux.org/alpine/v3.8/releases/ppc64le/netboot/modloop-vanilla
unsquashfs -d lib modloop-vanilla
rm modloop-vanilla
kver_full=$(find lib/modules -maxdepth 1 -name "*-vanilla" -printf %f)
kver=$(echo $kver_full | cut -d "-" -f 1)
krel=$(echo $kver_full | cut -d "-" -f 2)
kverm=$(echo $kver | cut -d "." -f 1)
kvern=$(echo $kver | cut -d "." -f 2)
curl https://cdn.kernel.org/pub/linux/kernel/v$kverm.x/linux-$kverm.$kvern.tar.xz | tar xJ
cd linux-$kverm.$kvern
curl https://cdn.kernel.org/pub/linux/kernel/v$kverm.x/patch-$kver.xz | unxz -c | patch -Nsp1
curl -o .config https://git.alpinelinux.org/aports/plain/main/linux-vanilla/config-vanilla.ppc64le?h=3.8-stable
sed -i "s/.*\(CONFIG_HW_RANDOM_VIRTIO\).*/\1=m/" .config
curl http://dl-cdn.alpinelinux.org/alpine/v3.8/main/ppc64le/linux-vanilla-dev-$kver-r$krel.apk | tar xz --warning=none --strip=3 usr/src/linux-headers-$kver_full/Module.symvers
make_cmd="make ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu-"
$make_cmd olddefconfig prepare modules_prepare
$make_cmd M=drivers/char/hw_random virtio-rng.ko
cp {,../lib/modules/$kver_full/kernel/}drivers/char/hw_random/virtio-rng.ko
cd ..
depmod -b . $kver_full
mksquashfs lib modloop-vanilla

QEMU_SYSTEM=qemu-system-ppc64
KERNEL_ARGS="console=hvc0"
DEVICE_SUFFIX=pci
