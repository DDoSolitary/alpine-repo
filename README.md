# alpine-repo

[![Build Status](https://travis-ci.org/DDoSolitary/alpine-repo.svg)](https://travis-ci.org/DDoSolitary/alpine-repo)

This is an unofficial repository for Alpine Linux.

# How to use

To use the pre-built packages, follow these steps:

1. Make sure `ca-certificates` and `wget` has been installed.

```
apk add ca-certificates wget
```

2. Trust my public key.

```
wget -P /etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub
```

3. I only build packages against the edge releases, so [upgrade to it](https://wiki.alpinelinux.org/wiki/Upgrading_Alpine#Upgrading_to_Edge) if you're using stable releases.

4. Add this line to `/etc/apk/repositories`

```
https://alpine-repo.sourceforge.io/packages
```

5. Update your local index.

```
apk update
```

6. **Enjoy it!**
