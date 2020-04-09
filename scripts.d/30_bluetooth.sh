#!/bin/bash

source lib.sh

curl "https://raw.githubusercontent.com/treehouses/control/newversion/server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py

echo "Switching bluetooth device class to 0x00010c - computer"
sed -i -e 's/#Class = .*/Class = 0x00010c/g' mnt/img_root/etc/bluetooth/main.conf

_pip3_install 'pybluez==0.23'
