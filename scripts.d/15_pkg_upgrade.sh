#!/bin/bash

source lib.sh

echo "Holding nodejs Package"
_op _chroot apt-mark hold nodejs
# temporay fix to not break GUI icons and background
_op _chroot apt-mark hold libfm-data
_op _chroot apt-mark hold libfm-extra4
_op _chroot apt-mark hold libfm-gtk-data
_op _chroot apt-mark hold libfm-gtk4
_op _chroot apt-mark hold libfm-modules
_op _chroot apt-mark hold libfm4
_op _chroot apt-mark hold raspberrypi-ui-mods
_op _chroot apt-mark hold linux-headers-rpi-v8
_op _chroot apt-mark hold linux-image-rpi-v8
_op _chroot apt-mark hold linux-headers-rpi-2712
_op _chroot apt-mark hold linux-image-rpi-2712

echo "Installing Updates"
_apt update || die "Could not update package sources"
_apt dist-upgrade || die "Could not upgrade system"

_op _chroot apt-mark unhold libfm-data
_op _chroot apt-mark unhold libfm-extra4
_op _chroot apt-mark unhold libfm-gtk-data
_op _chroot apt-mark unhold libfm-gtk4
_op _chroot apt-mark unhold libfm-modules
_op _chroot apt-mark unhold libfm4
_op _chroot apt-mark unhold raspberrypi-ui-mods
_op _chroot apt-mark unhold linux-headers-rpi-v8
_op _chroot apt-mark unhold linux-image-rpi-v8
_op _chroot apt-mark unhold linux-headers-rpi-2712
_op _chroot apt-mark unhold linux-image-rpi-2712
