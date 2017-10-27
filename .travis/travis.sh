#!/bin/bash
set -ex

# Install an Alpine Linux chroot environment
wget https://raw.githubusercontent.com/alpinelinux/alpine-chroot-install/master/alpine-chroot-install
sed -i "s/\(QEMU_UBUNTU_REL=\).*/\1artful/" alpine-chroot-install
chmod +x alpine-chroot-install
./alpine-chroot-install -b edge -p "alpine-sdk bash"

# Install keys for signing packages
KEYNAME=DDoSolitary@gmail.com-00000000.rsa
set +x
echo "$PRIVKEY" | base64 -d > "$KEYNAME"
set -x
openssl rsa -in "$KEYNAME" -pubout -out "/alpine/etc/apk/keys/$KEYNAME.pub"
cat >> /alpine/etc/abuild.conf <<- EOF
	PACKAGER="DDoSolitary <DDoSolitary@gmail.com>"
	PACKAGER_PRIVKEY="$PWD/$KEYNAME"
EOF

# Mount the web server's filesystem
MOUNT_POINT="/alpine/home/builder/packages/alpine-repo/$ARCH"
set +x
echo "$DEPLOYKEY" | base64 -d > /root/.ssh/id_ed25519
set -x
chmod 600 /root/.ssh/id_ed25519
cp .travis/known_hosts /root/.ssh/
mkdir -p "$MOUNT_POINT"
sshfs -o allow_other \
	"ddosolitary@web.sourceforge.net:/home/project-web/alpine-repo/htdocs/packages/$ARCH" \
	"$MOUNT_POINT"

# Build the packages
/alpine/enter-chroot bash -c "adduser -D builder && addgroup builder abuild"
BUILD_ERR=0
for i in */APKBUILD; do
	pushd "$(dirname "$i")"
	chmod 777 .
	set +e
	/alpine/enter-chroot -u builder bash -c "abuild -Rk"
	if [ "$?" == "0" ]; then
		set -e
		/alpine/enter-chroot -u builder bash -c "abuild cleanoldpkg"
	else
		set -e
		BUILD_ERR=1
	fi
	popd
done

# Unmount the web server's filesystem
fusermount -u "$MOUNT_POINT"

exit "$BUILD_ERR"
