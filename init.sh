#!/bin/bash

adduser -D builder
addgroup builder abuild

cat >> /etc/abuild.conf <<- EOF
	PACKAGER="DDoSolitary <DDoSolitary@gmail.com>"
	PACKAGER_PRIVKEY="$PWD/privkey"
EOF

cp pubkey /etc/apk/keys/

for i in $(cat build-list); do
	chmod 777 "$i"
done
