#!/bin/bash

source lib.sh

cat << EOF > mnt/root/etc/apt/sources.list
deb http://mirrors.ocf.berkeley.edu/raspbian/raspbian buster main contrib non-free rpi
#deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
#deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
EOF