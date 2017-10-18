#!/bin/bash
set -e

wget https://raw.githubusercontent.com/alpinelinux/alpine-chroot-install/master/alpine-chroot-install
chmod +x alpine-chroot-install
sudo ./alpine-chroot-install -b edge -p "alpine-sdk bash"

echo $PRIVKEY | base64 -d > DDoSolitary@gmail.com-00000000.rsa
find -mindepth 1 -maxdepth 1 -type d ! -path "./.git" > build-list
/alpine/enter-chroot ./init.sh

/alpine/enter-chroot -u builder ./build.sh
cp -r /alpine/home/builder/packages/alpine-repo packages

echo $DEPLOYKEY | base64 -d > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
cp known_hosts ~/.ssh/
printf "rm packages/x86_64/*\nrmdir packages/x86_64\nput -r packages" | sftp -b - ddosolitary@web.sourceforge.net:/home/project-web/alpine-repo/htdocs/
