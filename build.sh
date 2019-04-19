#!/bin/sh -e

sudo apk upgrade
keyname="$(basename ~/*.rsa)"
sudo openssl rsa -pubout -in ~/"$keyname" -out "/etc/apk/keys/$keyname.pub"
sshfs ddosolitary@web.sourceforge.net:/home/project-web/alpine-repo/htdocs/packages/$ARCH ~/packages/alpine-repo/$ARCH
build_err=0
for i in $(find -maxdepth 2 -path "*/APKBUILD" -exec dirname "{}" \;); do
	cd "$i"
	abuild -Rk && abuild cleanoldpkg || build_err=1
	cd ..
done
fusermount3 -u ~/packages/alpine-repo/$ARCH
exit $build_err
