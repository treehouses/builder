#!/bin/bash

source lib.sh

cat << EOF > mnt/img_root/etc/systemd/system/rpibluetooth.service
[Unit]
Description=Bluetooth server
After=bluetooth.service
Requires=rpibluetooth.service bluetooth.service

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
Restart=always
RestartSec=5s

ExecStart=/usr/bin/python3 /usr/local/bin/bluetooth-server.py &

[Install]
WantedBy=multi-user.target
EOF

_op _chroot chmod +x /etc/systemd/system/rpibluetooth.service
_op _chroot systemctl enable rpibluetooth
