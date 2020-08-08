#!/bin/bash

source lib.sh

cat << EOF > mnt/img_root/etc/systemd/system/autorun.service
[Unit]
Description=run autorun(once)(.sh) scripts from USB stick or in /boot
After=local_fs.target remote_fs.target network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/do_autorun start
Restart=no

[Install]
WantedBy=multi-user.target

EOF

mkdir -p "mnt/img_root/etc/systemd/system/multi-user.target.wants"
_op _chroot ln -sn /etc/systemd/system/autorun.service /etc/systemd/system/multi-user.target.wants/autorun.service