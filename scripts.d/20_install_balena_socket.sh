#!/bin/bash

cat << EOF > mnt/img_root/etc/systemd/system/balena.socket
[Unit]
Description=Balena Socket for the API
PartOf=balena.service

[Socket]
ListenStream=/var/run/balena.sock
SocketMode=0660
SocketUser=root
SocketGroup=balena

[Install]
WantedBy=sockets.target
EOF