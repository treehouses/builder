#!/bin/bash

source lib.sh

echo "Fix node"
# armv6l
# wget https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-armv6l.tar.gz
# tar xvzf node-v10.16.0-linux-armv6l.tar.gz node-v10.16.0-linux-armv6l/bin/node
# mv node-v10.16.0-linux-armv6l/bin/node mnt/img_root/usr/bin/node-armv6l
# _op _chroot chown root:root /usr/bin/node-armv6l
# rm -rf node-v10.16.0-linux-armv6l

case "$architecture" in
    "armhf" | "")
      archlink=armv7l
    ;;
    "arm64")
      archlink=arm64
    ;;
esac

_op _chroot mv /usr/bin/node /usr/bin/node-$archlink
_op _chroot ln -sr /usr/bin/node-$archlink /usr/bin/node
