#!/bin/bash

source lib.sh

echo "Holding nodejs Package"
_op _chroot apt-mark hold nodejs
_op _chroot apt-mark hold libraspberrypi-bin
_op _chroot apt-mark hold libraspberrypi-dev
_op _chroot apt-mark hold libraspberrypi-doc
_op _chroot apt-mark hold libraspberrypi0
_op _chroot apt-mark hold lxappearance-obconf
_op _chroot apt-mark hold lxpanel-data
_op _chroot apt-mark hold lxpanel
_op _chroot apt-mark hold lxplug-bluetooth
_op _chroot apt-mark hold obconf
_op _chroot apt-mark hold pi-greeter
_op _chroot apt-mark hold pipanel
_op _chroot apt-mark hold raspberrypi-ui-mods
_op _chroot apt-mark hold raspi-config
_op _chroot apt-mark hold rc-gui
_op _chroot apt-mark hold rp-prefapps
_op _chroot apt-mark hold xdg-utils

echo "Installing Updates"
_apt update || die "Could not update package sources"
_apt dist-upgrade || die "Could not upgrade system"

_op _chroot apt-mark unhold
_op _chroot apt-mark unhold libraspberrypi-bin
_op _chroot apt-mark unhold libraspberrypi-dev
_op _chroot apt-mark unhold libraspberrypi-doc
_op _chroot apt-mark unhold libraspberrypi0
_op _chroot apt-mark unhold lxappearance-obconf
_op _chroot apt-mark unhold lxpanel-data
_op _chroot apt-mark unhold lxpanel
_op _chroot apt-mark unhold lxplug-bluetooth
_op _chroot apt-mark unhold obconf
_op _chroot apt-mark unhold pi-greeter
_op _chroot apt-mark unhold pipanel
_op _chroot apt-mark unhold raspberrypi-ui-mods
_op _chroot apt-mark unhold raspi-config
_op _chroot apt-mark unhold rc-gui
_op _chroot apt-mark unhold rp-prefapps
_op _chroot apt-mark unhold xdg-utils
