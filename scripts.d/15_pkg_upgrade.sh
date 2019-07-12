#!/bin/bash

source lib.sh

echo "Holding nodejs Package"
_op _chroot apt-mark hold nodejs
_op _chroot apt-mark hold libgdk-pixbuf2.0-dev

echo "Installing Updates"
_apt update || die "Could not update package sources"
_apt dist-upgrade || die "Could not upgrade system"

_op _chroot apt-mark unhold libgdk-pixbuf2.0-dev
