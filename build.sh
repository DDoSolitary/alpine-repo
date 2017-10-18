#!/bin/sh

for i in $(cat build-list); do
	cd "$i"
	abuild -R
	cd ..
done

cp -r ~/packages/alpine-repo packages
