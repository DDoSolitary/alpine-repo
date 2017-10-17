#!/bin/sh

for i in $(find -maxdepth 1 -type d); do
	pushd "$i"
	abuild -ri
	popd
done
