#!/bin/bash -e

. build-$ARCH.sh

curl -O http://dl-cdn.alpinelinux.org/alpine/edge/releases/$ARCH/netboot/vmlinuz-vanilla
curl -O http://dl-cdn.alpinelinux.org/alpine/edge/releases/$ARCH/netboot/initramfs-vanilla
curl -O http://dl-cdn.alpinelinux.org/alpine/edge/releases/$ARCH/netboot/modloop-vanilla

mkdir -p ~/.ssh
ssh-keygen -t ed25519 -N "" -C "" -f ~/.ssh/id_ed25519
mv ~/.ssh/id_ed25519.pub .
python3 -m http.server -b 127.0.0.1 8000 &

qemu-img create -f qcow2 disk.qcow2 20G
$QEMU_SYSTEM --version
sudo $QEMU_SYSTEM $QEMU_ARGS -smp 2 -m 2G -kernel vmlinuz-vanilla -initrd initramfs-vanilla -append "$KERNEL_ARGS ip=dhcp alpine_repo=http://dl-cdn.alpinelinux.org/alpine/edge/main/ modloop=http://10.0.2.100/modloop-vanilla ssh_key=http://10.0.2.100/id_ed25519.pub" -drive id=vda,if=none,file=disk.qcow2 -device virtio-blk-$DEVICE_SUFFIX,drive=vda -netdev "user,id=eth0,hostfwd=:127.0.0.1:2200-:22,guestfwd=:10.0.2.100:80-cmd:nc 127.0.0.1 8000" -device virtio-net-$DEVICE_SUFFIX,netdev=eth0 -device virtio-rng-$DEVICE_SUFFIX -nographic &

while [ "$(ssh -o StrictHostKeyChecking=no -p 2200 root@127.0.0.1 "echo test" 2> /dev/null)" != test ]; do sleep 1; done
ssh="ssh -p 2200 root@127.0.0.1"
if [ "$ARCH" == s390x ]; then
	for i in $(seq 6); do
		$ssh "ln -sf zero /dev/tty$i"
	done
fi
$ssh "ip addr add 127.0.0.1/8 dev lo || true"
$ssh "ntpd -nqp time.google.com"
$ssh "apk add e2fsprogs sshfs"
$ssh "mkfs.ext4 /dev/vda"
$ssh "mount -t ext4 /dev/vda /mnt"
$ssh "mkdir /mnt/etc"
$ssh "cp /etc/resolv.conf /mnt/etc/"
$ssh "mkdir /mnt/etc/apk"
$ssh "cp -r /etc/apk/keys /mnt/etc/apk/"
$ssh "printf 'http://dl-cdn.alpinelinux.org/alpine/edge/main/\nhttp://dl-cdn.alpinelinux.org/alpine/edge/community/\n' > /mnt/etc/apk/repositories"
$ssh "apk --root /mnt --initdb --update-cache add alpine-base alpine-sdk"
$ssh "mount -t proc none /mnt/proc"
$ssh "mount --rbind /sys /mnt/sys"
$ssh "mount --rbind /dev /mnt/dev"
$ssh "chroot /mnt adduser -D builder"
$ssh "chroot /mnt addgroup builder abuild"
function ssh_builder {
	$ssh "chroot /mnt su - builder -c '$1'"
}
keyname=DDoSolitary@gmail.com-00000000.rsa
echo $PRIVKEY | base64 -d | ssh_builder "cat > $keyname"
echo $PRIVKEY | base64 -d | openssl rsa -pubout | $ssh "cat > /mnt/etc/apk/keys/$keyname.pub"
$ssh "cat >> /mnt/etc/abuild.conf" <<- EOF
	PACKAGER="DDoSolitary <DDoSolitary@gmail.com>"
	PACKAGER_PRIVKEY="/home/builder/$keyname"
EOF
echo $DEPLOYKEY | base64 -d | $ssh "cat > .ssh/id_ed25519"
$ssh "chmod 600 .ssh/id_ed25519"
$ssh "ssh-keyscan web.sourceforge.net > .ssh/known_hosts"
ssh_builder "mkdir -p packages/alpine-repo/$ARCH"
$ssh "modprobe fuse"
$ssh "sshfs -o allow_other ddosolitary@web.sourceforge.net:/home/project-web/alpine-repo/htdocs/packages/$ARCH /mnt/home/builder/packages/alpine-repo/$ARCH"
ssh_builder "mkdir alpine-repo"
if [ "$APPVEYOR_SSH_BLOCK" == "true" ]; then
	curl -sflL https://raw.githubusercontent.com/appveyor/ci/master/scripts/enable-ssh.sh | bash -e
fi
build_err=0
for i in $(cat build-list); do
	tar cz $i | ssh_builder "cd alpine-repo && tar xz"
	if ! ssh_builder "cd alpine-repo/$i && abuild -Rk && abuild cleanoldpkg"; then
		build_err=1
	fi
done
exit $build_err
