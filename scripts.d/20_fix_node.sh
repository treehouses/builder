#!/bin/bash

architecture="$1"
source lib.sh

case "$architecture" in
  "armhf" | "")
    echo "TODO: Fix node"
    # armv6l
    wget https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-armv6l.tar.gz
    tar xvzf node-v10.16.0-linux-armv6l.tar.gz node-v10.16.0-linux-armv6l/bin/node
    mv node-v10.16.0-linux-armv6l/bin/node mnt/img_root/usr/bin/node-armv6l
    _op _chroot chown root:root /usr/bin/node-armv6l
    rm -rf node-v10.16.0-linux-armv6l
    # armv7l
    _op _chroot mv /usr/bin/node /usr/bin/node-armv7l
    _op _chroot ln -sr /usr/bin/node-armv7l /usr/bin/node
  ;;
  "arm64")
    # arm64
    _op _chroot mv /usr/bin/node /usr/bin/node-arm64
    _op _chroot ln -sr /usr/bin/node-arm64 /usr/bin/node
   ;;
esac