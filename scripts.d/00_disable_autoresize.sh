#!/bin/bash

source lib.sh

sed -i 's| quiet init=/usr/lib/raspberrypi-sys-mods/firstboot||' mnt/img_root/boot/firmware/cmdline.txt || die "Could notdisable autoresize"
