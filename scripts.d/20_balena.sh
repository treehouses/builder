#!/bin/bash

source lib.sh

echo "Balena installation"

# get the latest version
releases=$(curl -s https://api.github.com/repos/balena-io/balena-engine/releases/latest | jq -r ".assets[].browser_download_url")
armv6link=$(echo "$releases" | tr " " "\\n" | grep armv6)
armv7link=$(echo "$releases" | tr " " "\\n" | grep armv7)

# armv7
wget -c "$armv7link"
tar xvzf "$(basename "$armv7link")" balena/balena
mv balena/balena mnt/img_root/usr/bin/balena-armv7l
_op _chroot chown root:root /usr/bin/balena-armv7l
rm -rf balena/

# armv6
wget -c "$armv6link"
tar xvzf "$(basename "$armv6link")" balena/balena
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

_op _chroot groupadd balena
_op _chroot usermod -aG balena pi
_op _chroot usermod -aG balena root

_op _chroot rm -rf /var/lib/balena
_op _chroot ln -sr /var/lib/docker /var/lib/balena
