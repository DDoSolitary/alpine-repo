#!/bin/sh

for i in $(cat build-list); do
	cd "$i"
	abuild -r
	cd ..
done
