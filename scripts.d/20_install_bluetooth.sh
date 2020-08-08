#!/bin/bash

cat << EOF > mnt/img_root/etc/systemd/system/rpibluetooth.service
[Unit]
Description=Bluetooth server
After=rpibluetooth.service
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