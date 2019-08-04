#!/bin/bash

source lib.sh

echo "Balena installation"

# get the latest version
releases=$(curl -s https://api.github.com/repos/balena-os/balena-engine/releases/latest -H "Authorization: token $GITHUB_KEY" | jq -r ".assets[].browser_download_url")
armv6link=$(echo "$releases" | tr " " "\\n" | grep armv6)
armv7link=$(echo "$releases" | tr " " "\\n" | grep armv7)

# armv7
wget -c "$armv7link"
tar xvzf "$(basename "$armv7link")" balena-engine/balena-engine
mv balena-engine/balena-engine mnt/img_root/usr/bin/balena-engine-armv7l
_op _chroot chown root:root /usr/bin/balena-engine-armv7l
rm -rf balena-engine/

# armv6
wget -c "$armv6link"
tar xvzf "$(basename "$armv6link")" balena-engine/balena-engine
mv balena-engine/balena-engine mnt/img_root/usr/bin/balena-engine-armv6l
_op _chroot chown root:root /usr/bin/balena-engine-armv6l
rm -rf balena-engine/


_op _chroot ln -sr /usr/bin/balena-engine-armv7l /usr/bin/balena-engine
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd-ctr
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd-shim
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-daemon
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-proxy
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-runc

_op _chroot groupadd balena
_op _chroot usermod -aG balena pi
_op _chroot usermod -aG balena root

_op _chroot rm -rf /var/lib/balena
_op _chroot ln -sr /var/lib/docker /var/lib/balena
