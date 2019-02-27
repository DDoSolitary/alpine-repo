#!/bin/bash -e

rel_name=disco
sudo bash -c "echo 'deb http://archive.ubuntu.com/ubuntu/ $rel_name main universe' > /etc/apt/sources.list.d/ubuntu-$rel_name.list"
sudo bash -c "cat > /etc/apt/preferences.d/ubuntu-$rel_name" <<- EOF
	Package: *
	Pin: release n=$rel_name
	Pin-Priority: -1
EOF
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get update -qq
sudo -E apt-get install -y -qq netcat > /dev/null

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
	suffix=s390x
	;;
esac
	
sudo -E apt-get install -t $rel_name -y -qq qemu-system-$suffix qemu-utils > /dev/null
