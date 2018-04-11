#!/bin/bash

source lib.sh

curl "https://raw.githubusercontent.com/ole-vi/bluetooth-server/master/bluetooth-server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py
echo "before sed"
cat mnt/img_root/etc/bluetooth/main.conf
sed -i -e 's/#Class = .*/Class = 0x00010c/g' mnt/img_root/etc/bluetooth/main.conf
echo "after sed"
cat mnt/img_root/etc/bluetooth/main.conf
