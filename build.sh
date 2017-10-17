#!/bin/sh

for i in $(find -mindepth 1 -maxdepth 1 -type d ! -path "./.git"); do
	cd "$i"
	abuild -R
	cd ..
done
