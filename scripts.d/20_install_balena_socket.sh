#!/bin/bash

source lib.sh

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


_op _chroot chmod +x /etc/systemd/system/balena.socket