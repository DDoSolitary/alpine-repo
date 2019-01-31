#!/bin/bash -e

sudo bash -c "echo 'deb [trusted=yes] https://deb.debian.org/debian unstable main contrib' > /etc/apt/sources.list.d/debian-unstable.list"
sudo bash -c "cat > /etc/apt/preferences.d/debian-unstable" <<- EOF
	Package: *
	Pin: release n=unstable
	Pin-Priority: -1
EOF
sudo apt-get update -qq
sudo apt-get install -y -qq netcat > /dev/null

case $ARCH in
x86|x86_64)
	suffix=x86
	;;
armhf|aarch64)
	suffix=arm
	;;
ppc64le)
	suffix=ppc
	;;
s390x)
	suffix=misc
	;;
esac
	
sudo DEBIAN_FRONTEND=noninteractive apt-get install -t unstable -y -qq qemu-system-$suffix qemu-utils > /dev/null
