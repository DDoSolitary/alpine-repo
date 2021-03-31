ARG ALPINE_HOST=edge
FROM alpine:$ALPINE_HOST
ARG ARCH
ARG QEMU_MEM=1G
ADD configure.sh /
RUN eval $(./configure.sh $ARCH) && \
	apk upgrade && \
	apk add qemu-system-$QEMU_ARCH qemu-img netcat-openbsd python3 openssh && \
	dl_url=http://dl-cdn.alpinelinux.org/alpine/edge/releases/$ARCH/netboot && \
	wget $dl_url/vmlinuz-$KERNEL_FLAVOR && \
	wget $dl_url/initramfs-$KERNEL_FLAVOR && \
	wget $dl_url/modloop-$KERNEL_FLAVOR && \
	ssh-keygen -t ed25519 -N "" -C "" -f id && \
	qemu-img create -f qcow2 disk.qcow2 20G && \
	(python3 -m http.server -b 127.0.0.1 8000 &) && \
	(qemu-system-$QEMU_ARCH $QEMU_ARGS -m $QEMU_MEM -smp $QEMU_SMP \
		-kernel vmlinuz-$KERNEL_FLAVOR -initrd initramfs-$KERNEL_FLAVOR \
		-append "console=$QEMU_CONSOLE_DEV ip=dhcp \
			alpine_repo=http://dl-cdn.alpinelinux.org/alpine/edge/main/ \
			modloop=http://10.0.2.100/modloop-$KERNEL_FLAVOR \
			ssh_key=http://10.0.2.100/id.pub" \
		-drive id=vda,if=none,file=disk.qcow2 \
		-device virtio-blk-$QEMU_DEV_SUFFIX,drive=vda \
		-netdev "user,id=eth0,hostfwd=::22-:22,guestfwd=:10.0.2.100:80-cmd:nc 127.0.0.1 8000" \
		-device virtio-net-$QEMU_DEV_SUFFIX,netdev=eth0 \
		-device virtio-rng-$QEMU_DEV_SUFFIX -nographic &) && \
	ssh="ssh -i id \
		-o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		127.0.0.1" && \
	(while [ "$($ssh echo test 2> /dev/null)" != "test" ]; do sleep 1; done) && \
	$ssh "sed -i \
		's/\(local kernel_opts=\"\)quiet\"/\1console=$QEMU_CONSOLE_DEV\"/' \
		/sbin/setup-disk" && \
	$ssh "USE_EFI=$([ -n "$FW_URL" ] && echo 1) ERASE_DISKS=/dev/vda \
		setup-disk -m sys -s 0 /dev/vda" && \
	part_no=$(if [ "$ARCH" == "ppc64le" ]; then echo 3; else echo 2; fi) && \
	$ssh "mount /dev/vda$part_no /mnt" && \
	$ssh "apk add --root /mnt alpine-sdk sshfs fuse3 coreutils findutils sudo" && \
	$ssh "setup-interfaces -a -p /mnt" && \
	$ssh "ln -s /etc/init.d/ntpd /mnt/etc/runlevels/default/ntpd" && \
	$ssh "chroot /mnt adduser -D builder" && \
	$ssh "chroot /mnt passwd -d builder" && \
	$ssh "chroot /mnt addgroup builder abuild" && \
	$ssh 'echo "builder ALL=(ALL) NOPASSWD:ALL" >> /mnt/etc/sudoers' && \
	$ssh "echo http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
		>> /mnt/etc/apk/repositories" && \
	$ssh "echo PasswordAuthentication yes >> /mnt/etc/ssh/sshd_config" && \
	$ssh "echo PermitEmptyPasswords yes >> /mnt/etc/ssh/sshd_config" && \
	echo 'PACKAGER="DDoSolitary <DDoSolitary@gmail.com>"' \
		| $ssh "cat >> /mnt/etc/abuild.conf" && \
	$ssh "echo PACKAGER_PRIVKEY=/home/builder/DDoSolitary@gmail.com-00000000.rsa \
		>> /mnt/etc/abuild.conf" && \
	$ssh "echo fuse >> /mnt/etc/modules" && \
	$ssh "echo user_allow_other >> /mnt/etc/fuse.conf" && \
	$ssh "install -d -o 1000 -g 1000 /mnt/home/builder/.ssh" && \
	$ssh "ssh-keyscan web.sourceforge.net > /mnt/home/builder/.ssh/known_hosts" && \
	$ssh "install -d -o 1000 -g 1000 \
		/mnt/home/builder/packages/alpine-repo/$ARCH" && \
	$ssh "install -d -o 1000 -g 1000 /mnt/home/builder/alpine-repo" && \
	$ssh "umount /mnt" && \
	killall qemu-system-$QEMU_ARCH python3 && \
	rm id id.pub *-$KERNEL_FLAVOR && \
	apk del qemu-img netcat-openbsd python3 openssh && \
	([ -n "$FW_URL" ] && wget $FW_URL || [ -z "$FW_URL" ])
EXPOSE 22
ENV ARCH=$ARCH
ENV QEMU_MEM=$QEMU_MEM
CMD eval $(./configure.sh $ARCH) && \
	qemu-system-$QEMU_ARCH $QEMU_ARGS -m $QEMU_MEM -smp $QEMU_SMP \
		$([ -n "$FW_URL" ] && echo -bios QEMU_EFI.fd) \
		-drive id=vda,if=none,file=disk.qcow2 \
		-device virtio-blk-$QEMU_DEV_SUFFIX,drive=vda \
		-netdev user,id=eth0,hostfwd=::22-:22 \
		-device virtio-net-$QEMU_DEV_SUFFIX,netdev=eth0 \
		-device virtio-rng-$QEMU_DEV_SUFFIX -nographic
