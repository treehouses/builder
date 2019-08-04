#!/bin/bash

source lib.sh

curl "https://raw.githubusercontent.com/treehouses/control/master/server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py

echo "Switching bluetooth device class to 0x00100 - networking server"
sed -i -e 's/#Class = .*/Class = 0x00100/g' mnt/img_root/etc/bluetooth/main.conf
