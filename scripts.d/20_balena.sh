#!/bin/bash

source lib.sh

echo "Balena installation"
# armv7
wget -c https://github.com/resin-os/balena/releases/download/17.06-rc5/balena-17.06-rc5-armv7.tar.gz
tar xvzf balena-17.06-rc5-armv7.tar.gz balena/balena
mv balena/balena mnt/img_root/usr/bin/balena-armv7l
_op _chroot chown root:root /usr/bin/balena-armv7l
rm -rf balena/

# armv6
wget -c https://github.com/resin-os/balena/releases/download/17.06-rc5/balena-17.06-rc5-armv6.tar.gz
tar xvzf balena-17.06-rc5-armv6.tar.gz balena/balena
mv balena/balena mnt/img_root/usr/bin/balena-armv6l
_op _chroot chown root:root /usr/bin/balena-armv6l
rm -rf balena/


_op _chroot ln -sr /usr/bin/balena-armv7l /usr/bin/balena
_op _chroot ln -sr /usr/bin/balena /usr/bin/balena-containerd
_op _chroot ln -sr /usr/bin/balena /usr/bin/balena-containerd-ctr
_op _chroot ln -sr /usr/bin/balena /usr/bin/balena-containerd-shim
_op _chroot ln -sr /usr/bin/balena /usr/bin/balenad
_op _chroot ln -sr /usr/bin/balena /usr/bin/balena-proxy
_op _chroot ln -sr /usr/bin/balena /usr/bin/balena-runc
