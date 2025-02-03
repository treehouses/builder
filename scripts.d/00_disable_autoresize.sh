#!/bin/bash

source lib.sh

echo cmdline.txt
cat mnt/img_root/boot/cmdline.txt
sed -i 's| quiet init=/usr/lib/raspberrypi-sys-mods/firstboot||' mnt/img_root/boot/cmdline.txt || die "Could notdisable autoresize"
