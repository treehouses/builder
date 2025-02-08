#!/bin/bash

source lib.sh

curl --silent --show-error --fail "https://raw.githubusercontent.com/treehouses/control/master/server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py

cat mnt/img_root/usr/local/bin/bluetooth-server.py | grep ^class

echo "Switching bluetooth device class to 0x00010c - computer"
sed -i -e 's/#Class = .*/Class = 0x00010c/g' mnt/img_root/etc/bluetooth/main.conf
cat mnt/img_root/etc/bluetooth/main.conf

sed -i -e 's#libexec/bluetooth/bluetoothd#sbin/bluetoothd --noplugin=sap#' mnt/img_root/lib/systemd/system/bluetooth.service
cat mnt/img_root/lib/systemd/system/bluetooth.service
