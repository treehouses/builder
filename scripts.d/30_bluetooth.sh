#!/bin/bash
exit 0
source lib.sh

curl --silent --show-error --fail "https://raw.githubusercontent.com/treehouses/control/master/server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py

cat mnt/img_root/usr/local/bin/bluetooth-server.py | grep ^class

echo "Switching bluetooth device class to 0x00010c - computer"
sed -i -e 's/#Class = .*/Class = 0x00010c/g' mnt/img_root/etc/bluetooth/main.conf

_pip3_install 'pybluez==0.23'
