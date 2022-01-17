#!/bin/bash -e

if [ "$CI" == "true" ]; then
	mkdir -p ~/.ssh
	echo "$DEPLOYKEY" | base64 -d > ~/.ssh/id_ed25519
	chmod 600 ~/.ssh/id_ed25519
	eval $(ssh-agent)
	ssh-add ~/.ssh/id_ed25519
fi

docker run -t -p 2200:22 quay.io/ddosolitary/alpine-builder:$ARCH &
ssh="ssh -p 2200 \
	-o UserKnownHostsFile=/dev/null \
	-o StrictHostKeyChecking=no \
	-o ForwardAgent=yes \
	builder@127.0.0.1"
while [ "$($ssh echo test 2> /dev/null)" != "test" ]; do sleep 1; done
echo $PRIVKEY | base64 -d | $ssh "cat > DDoSolitary@gmail.com-00000000.rsa"
tar c build.sh build-order $(dirname */APKBUILD) | $ssh "tar xC alpine-repo"
$ssh "cd alpine-repo && ARCH=$ARCH ./build.sh"
