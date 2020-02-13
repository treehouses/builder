#!/bin/bash

source lib.sh

sed -i 's|rootwait|rootwait init=/usr/lib/enable_wifi.sh|' mnt/img_root/boot/cmdline.txt
{ 
  echo mount -t proc proc /proc
  echo mount -t sysfs sys /sys
  echo mount -t tmpfs tmp /run
  echo mkdir -p /run/systemd

  echo mount /boot
  echo mount / -o remount,rw

  echo sed -i 's|rootwait|rootwait init=/usr/lib/enable_wifi\.sh|' mnt/img_root/boot/cmdline.txt
} > mnt/img_root/usr/lib/enable_wifi.sh

chmod +x mnt/img_root/usr/lib/enable_wifi.sh
