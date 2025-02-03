#!/bin/bash

source lib.sh

echo old cmdline.txt
cat mnt/img_root/boot/cmdline.txt
sed -i 's| quiet init=/usr/lib/raspberrypi-sys-mods/firstboot||' mnt/img_root/boot/cmdline.txt || die "Could notdisable autoresize"
echo new cmdline.txt
cat mnt/img_root/boot/cmdline.txt
