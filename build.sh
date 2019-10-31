#!/bin/sh -e

sudo apk upgrade
keyname="$(basename ~/*.rsa)"
sudo openssl rsa -pubout -in ~/"$keyname" -out "/etc/apk/keys/$keyname.pub"
echo $S3FS_PWD > s3fs_pwd
chmod 600 s3fs_pwd
mkdir s3fs_cache
s3fs alpine-ddosolitary ~/packages/alpine-repo \
	-o allow_other \
	-o passwd_file="$PWD/s3fs_pwd" \
	-o use_cache="$PWD/s3fs_cache"
	-o url=https://ewr1.vultrobjects.com/ \
	-o use_path_request_style
build_err=0
for i in $(find -maxdepth 2 -path "*/APKBUILD" -exec dirname "{}" \;); do
	cd "$i"
	abuild -Rk && abuild cleanoldpkg || build_err=1
	cd ..
done
fusermount -u ~/packages/alpine-repo
exit $build_err
