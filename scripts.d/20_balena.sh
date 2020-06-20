#!/bin/bash

source lib.sh

echo "Balena installation"

# get the latest version
releases=$(curl -s https://api.github.com/repos/balena-os/balena-engine/releases/latest -H "Authorization: token $GITHUB_KEY" | jq -r ".assets[].browser_download_url")
aarch64=$(echo "$releases" | tr " " "\\n" | grep aarch64)

# aarch64
wget -c "$aarch64"
tar xvzf "$(basename "$aarch64")" ./balena-engine/balena-engine
mv balena-engine/balena-engine mnt/img_root/usr/bin/balena-engine-aarch64
_op _chroot chown root:root /usr/bin/balena-engine-aarch64
rm -rf balena-engine/

_op _chroot touch /usr/bin/balena-engine
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd-ctr
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd-shim
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-daemon
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-proxy
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-runc
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena
_op _chroot rm /usr/bin/balena-engine
_op _chroot ln -sr /usr/bin/balena-engine-aarch64 /usr/bin/balena-engine

_op _chroot groupadd balena
_op _chroot usermod -aG balena pi
_op _chroot usermod -aG balena root

_op _chroot rm -rf /var/lib/balena-engine
_op _chroot ln -sr /var/lib/docker /var/lib/balena-engine
