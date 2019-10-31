#!/bin/bash -e

docker run -t -p 2200:22 ddosolitary/alpine-builder:$ARCH &
ssh="ssh -p 2200 \
	-o UserKnownHostsFile=/dev/null \
	-o StrictHostKeyChecking=no \
	builder@127.0.0.1"
while [ "$($ssh echo test 2> /dev/null)" != "test" ]; do sleep 1; done
echo $PRIVKEY | base64 -d | $ssh "cat > DDoSolitary@gmail.com-00000000.rsa"
tar c build.sh $(echo */APKBUILD | xargs dirname) | $ssh "tar xC alpine-repo"
$ssh "cd alpine-repo && S3FS_PWD=$S3FS_PWD ARCH=$ARCH ./build.sh"
