#!/bin/bash
set -e

for i in */APKBUILD; do
	pushd "$(dirname "$i")"
	abuild cleanoldpkg
	abuild -Rk
	popd
done
