# alpine-repo

[![Build Status](https://travis-ci.org/DDoSolitary/alpine-repo.svg)](https://travis-ci.org/DDoSolitary/alpine-repo)

This is an unofficial repository for Alpine Linux.

# How to use

To use the pre-built packages, follow these steps:

1. Make sure `ca-certificates` and `libressl` has been installed.

```
apk add ca-certificates libressl
```

2. Trust my public key.

```
wget -P /etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub
```
This public key is signed by my GPG key. If you want to verify the public key, you can download the signature from [here](https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub.sig), and get my public key from the SKS keyservers. The fingerprint of my GPG key is `688E1D093C3638F588890D4450268311C7AD3F62`.

3. I only build packages for the edge releases, so [upgrade to it](https://wiki.alpinelinux.org/wiki/Upgrading_Alpine#Upgrading_to_Edge) if you're using stable releases.

4. Add this line to `/etc/apk/repositories`

```
https://alpine-repo.sourceforge.io/packages
```

5. Update your local index.

```
apk update
```

6. **Enjoy it!**

# Limitations

- No CDN, downloading may be slow in some regions (e.g. China).

- No packages for the s390x. Though this architecture is supported by Alpine Linux, qemu doesn't work well with it. So I can't build for it as the only build envrironment I can use is Travis CI's x86_64 servers.

- No packages for stable releases, and old packages are deleted immediately after newer ones are built. However, as a fan of Arch Linux, I consider this limitation "a feature".
