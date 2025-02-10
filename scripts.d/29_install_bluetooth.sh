#!/bin/bash

source lib.sh

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

_op _chroot chmod +x /etc/systemd/system/rpibluetooth.service
_op _chroot systemctl enable rpibluetooth
