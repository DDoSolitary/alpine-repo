#!/bin/sh

for i in $(find -maxdepth 1 -type d); do
	cd "$i"
	abuild -ri
	cd ..
done
