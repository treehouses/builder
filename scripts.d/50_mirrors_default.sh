#!/bin/bash

source lib.sh

if uname -m | grep -q "aarch64" ; then
    exit 0
fi

cat << EOF > mnt/img_root/etc/apt/sources.list
deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
#deb http://mirrordirector.raspbian.org/raspbian/ buster main contrib non-free rpi
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
#deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
EOF

_apt update || die "Could not update package sources"