#!/bin/bash

exit 0

source lib.sh
echo "Installing files"
#(cd install || die "ERROR: install folder doesn't exist, exiting"; tar c .) | _op _chroot tar vx --owner=root --group=root