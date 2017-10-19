# alpine-repo

[![Build Status](https://travis-ci.org/DDoSolitary/alpine-repo.svg)](https://travis-ci.org/DDoSolitary/alpine-repo)

This is an unofficial repository for Alpine Linux.

# How to use

To use the pre-built packages, follow these steps:

1. Make sure `ca-certificates` has been installed.

```
apk add ca-certificates
```

2. Trust my public key.

```
wget -P /etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub
```

3. Add this line to `/etc/apk/repositories`

```
https://alpine-repo.sourceforge.io/packages
```

4. Update your local index.

```
apk update
```

5. **Enjoy it!**
