#!/bin/bash

adduser -D builder
addgroup builder abuild

cat >> /etc/abuild.conf <<- EOF
	PACKAGER="DDoSolitary <DDoSolitary@gmail.com>"
	PACKAGER_PRIVKEY="$PWD/DDoSolitary@gmail.com-00000000.rsa"
EOF

cp DDoSolitary@gmail.com-00000000.rsa.pub /etc/apk/keys/

for i in $(cat build-list); do
	chmod 777 "$i"
done
