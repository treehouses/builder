#!/bin/bash

source lib.sh

curl --silent --show-error --fail "https://raw.githubusercontent.com/treehouses/control/master/server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py

cat mnt/img_root/usr/local/bin/bluetooth-server.py | grep ^class

echo "Switching bluetooth device class to 0x00010c - computer"
sed -i -e 's/#Class = .*/Class = 0x00010c/g' mnt/img_root/etc/bluetooth/main.conf
sed -i -e 's/#DiscoverableTimeout = 0/DiscoverableTimeout = 0/g' mnt/img_root/etc/bluetooth/main.conf
sed -i -e 's/#JustWorksRepairing = never/JustWorksRepairing = always/g' mnt/img_root/etc/bluetooth/main.conf
sed -i -e 's/#FastConnectable = false/FastConnectable = true/g' mnt/img_root/etc/bluetooth/main.conf
echo "\n[Agent]\nDefaultAgent = true\nEnableSecurity = false" >> mnt/img_root/etc/bluetooth/main.conf
cat mnt/img_root/etc/bluetooth/main.conf

sed -i -e 's#libexec/bluetooth/bluetoothd#sbin/bluetoothd#' mnt/img_root/lib/systemd/system/bluetooth.service
cat mnt/img_root/lib/systemd/system/bluetooth.service

mkdir -p mnt/img_root/etc/systemd/system/bluetooth.service.d
echo "[Service]\nExecStart=\nExecStart=/usr/sbin/bluetoothd --compat" > mnt/img_root/etc/systemd/system/bluetooth.service.d/override.conf
cat mnt/img_root/etc/systemd/system/bluetooth.service.d/override.conf
