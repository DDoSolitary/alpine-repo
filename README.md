# alpine-repo

![Build Status](https://github.com/DDoSolitary/alpine-repo/workflows/.github/workflows/build.yml/badge.svg)

This is an unofficial repository for Alpine Linux.

# How to use

1. Trust my public key.

```
wget -P /etc/apk/keys https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub
```
This public key is signed by my GPG key. If you want to verify the public key, you can download the signature from [here](https://alpine-repo.sourceforge.io/DDoSolitary@gmail.com-00000000.rsa.pub.sig), and get my public key from the SKS keyservers. The fingerprint of my GPG key is `688E1D093C3638F588890D4450268311C7AD3F62`.

2. I only build packages for the edge releases, so [upgrade to it](https://wiki.alpinelinux.org/wiki/Upgrading_Alpine#Upgrading_to_Edge) if you're using stable releases.

3. Add this line to `/etc/apk/repositories`

```
https://alpine-repo.sourceforge.io/packages
```

4. Update your local index.

```
apk update
```

5. **Enjoy it!**

# Limitations

- Downloading may be slow in some regions (e.g. China).

- No packages for stable releases, and old packages are deleted immediately after newer ones are built. However, as a fan of Arch Linux, I consider this limitation "a feature".
