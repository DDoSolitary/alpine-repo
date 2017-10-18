# alpine-repo

This is an unofficial repository for Alpine Linux.

# How to use

To use the pre-built packages, follow these setps:

1. Make sure `ca-certificates` has been installed.

```
apk add ca-certificates
```

2. Trust my public key.

```
wget -P /etc/apk/keys https://github.com/DDoSolitary/alpine-repo/raw/master/DDoSolitary%40gmail.com-00000000.rsa.pub
```

3. Add this line to `/etc/apk/repositories`

```
https://alpine-repo.sourceforge.io/packages
```

4. Update your local index.

```
apk update
```

5. Enjoy it!
