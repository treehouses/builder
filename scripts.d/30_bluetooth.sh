#!/bin/bash

source lib.sh

curl "https://raw.githubusercontent.com/treehouses/control/master/server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py

echo "Switching bluetooth device class to 0x20108 - networking server"
sed -i -e 's/#Class = .*/Class = 0x20108/g' mnt/img_root/etc/bluetooth/main.conf

_pip3_install pybluez

# Disabling the hostname BlueZ plugin that resets the device
bluetoothd -P hostname

# Setting the same device class with hciconfig
hciconfig hci0 class 020108

