#!/bin/bash

source lib.sh
echo "Installing files"
(cd install; tar c .) | _op _chroot tar vx --owner=root --group=root
