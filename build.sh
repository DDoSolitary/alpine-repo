#!/bin/bash
set -e

for i in $(cat build-list); do
	cd "$i"
	abuild cleanoldpkg
	abuild -Rk
	cd ..
done
