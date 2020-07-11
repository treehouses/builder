#!/bin/bash

exit 0

source lib.sh

sed -i 's| quiet init=/usr/lib/raspi-config/init_resize.sh||' mnt/img_root/boot/cmdline.txt || die "Could notdisable autoresize"
