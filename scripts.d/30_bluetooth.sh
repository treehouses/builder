#!/bin/bash

source lib.sh

curl --silent --show-error --fail "https://raw.githubusercontent.com/treehouses/control/master/server.py" -o mnt/img_root/usr/local/bin/bluetooth-server.py

cat mnt/img_root/usr/local/bin/bluetooth-server.py | grep ^class

echo "Switching bluetooth device class to 0x00010c - computer"
sed -i -e 's/#Class = .*/Class = 0x00010c/g' mnt/img_root/etc/bluetooth/main.conf
sed -i -e 's/#DiscoverableTimeout = 0/DiscoverableTimeout = 0/g' mnt/img_root/etc/bluetooth/main.conf
sed -i -e 's/#JustWorksRepairing = never/JustWorksRepairing = always/g' mnt/img_root/etc/bluetooth/main.conf
sed -i -e 's/#FastConnectable = false/FastConnectable = true/g' mnt/img_root/etc/bluetooth/main.conf
cat mnt/img_root/etc/bluetooth/main.conf

sed -i -e 's#libexec/bluetooth/bluetoothd#sbin/bluetoothd#' mnt/img_root/lib/systemd/system/bluetooth.service
cat mnt/img_root/lib/systemd/system/bluetooth.service

mkdir -p mnt/img_root/etc/systemd/system/bluetooth.service.d
echo -e "[Service]\nExecStart=\nExecStart=/usr/sbin/bluetoothd --noplugin=input --compat" > mnt/img_root/etc/systemd/system/bluetooth.service.d/override.conf
cat mnt/img_root/etc/systemd/system/bluetooth.service.d/override.conf

cat << EOF > mnt/img_root/etc/systemd/system/rpibluetooth.service
[Unit]
Description=Bluetooth Server
After=bluetooth.service
Requires=bluetooth.service

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/bluetooth-server.py
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

_op _chroot chmod 644 /etc/systemd/system/rpibluetooth.service
_op _chroot systemctl enable rpibluetooth
