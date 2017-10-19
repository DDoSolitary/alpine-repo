#!/bin/bash
set -e

for i in */APKBUILD; do
	pushd "$(dirname "$i")"
	abuild -Rk
	abuild cleanoldpkg
	popd
done
