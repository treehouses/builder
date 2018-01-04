#!/bin/bash

source lib.sh
echo "Installing files"
(cd install || exit 1; tar c .) | _op _chroot tar vx --owner=root --group=root
