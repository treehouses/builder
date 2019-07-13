#!/bin/bash

source lib.sh

echo "Holding nodejs Package"
_op _chroot apt-mark hold nodejs

echo "Installing Updates"
_apt update || die "Could not update package sources"
#_apt dist-upgrade || die "Could not upgrade system"
