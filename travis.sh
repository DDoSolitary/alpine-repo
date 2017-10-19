#!/bin/bash
set -e

# Install an Alpine Linux chroot environment
wget https://raw.githubusercontent.com/alpinelinux/alpine-chroot-install/master/alpine-chroot-install
chmod +x alpine-chroot-install
sudo ./alpine-chroot-install -b edge -p "alpine-sdk bash"

# Find the packages to build
find -mindepth 1 -maxdepth 1 -type d ! -path "./.git" > build-list

# Run the initiallize script
/alpine/enter-chroot ./init.sh

# Install keys for signing packages
echo $PRIVKEY | base64 -d > DDoSolitary@gmail.com-00000000.rsa
sudo wget -P /alpine/etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub

# Prepare for connecting to the web server
echo $DEPLOYKEY | base64 -d > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
cp known_hosts ~/.ssh/
MOUNT_POINT=/alpine/home/builder/packages/alpine-repo

# Mount the web server's filesystem
sudo mkdir -p "$MOUNT_POINT"
sudo bash -c 'echo user_allow_other >> /etc/fuse.conf'
sshfs -o allow_other \
	ddosolitary@web.sourceforge.net:/home/project-web/alpine-repo/htdocs/packages \
	"$MOUNT_POINT"

# Build the packages
/alpine/enter-chroot -u builder ./build.sh

# Unmount the web server's filesystem
fusermount -u "$MOUNT_POINT"
