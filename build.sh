#!/bin/sh -e

sudo apk upgrade
keyname="$(basename ~/*.rsa)"
sudo openssl rsa -pubout -in ~/"$keyname" -out "/etc/apk/keys/$keyname.pub"
sshfs -o allow_root \
	ddosolitary@web.sourceforge.net:/home/project-web/alpine-repo/htdocs/packages/$ARCH \
	~/packages/alpine-repo/$ARCH

tmp1="$(mktemp)"
tmp2="$(mktemp)"
tsort build-order >> "$tmp1"
find . -maxdepth 2 -path "*/APKBUILD" | xargs -n1 dirname | xargs -n1 basename >> "$tmp2"
pkglist="$(cat "$tmp1") $(sort "$tmp1" | comm -3 - "$tmp2")"

build_err=0
for i in $pkglist; do
	cd "$i"
	abuild -rk && abuild cleanoldpkg || build_err=1
	cd ..
done

fusermount3 -u ~/packages/alpine-repo/$ARCH
exit $build_err
