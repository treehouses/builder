#!/bin/bash

source lib.sh

_op _chroot wget https://raw.githubusercontent.com/codazoda/hub-ctrl.c/master/hub-ctrl.c
_op _chroot gcc -o hub-ctrl hub-ctrl.c -lusb

mkdir -p mnt/img_root/usr/local/bin/
_op _chroot mv hub-ctrl usr/local/bin/.
chmod +x mnt/img_root/usr/local/bin/hub-ctrl
