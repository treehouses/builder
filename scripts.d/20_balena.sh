#!/bin/bash

architecture="$1"

source lib.sh

echo "Balena installation"

# get the latest version
releases=$(curl -s https://api.github.com/repos/balena-os/balena-engine/releases/latest -H "Authorization: token $APIKEY" | jq -r ".assets[].browser_download_url")

# Sets the release and link variable based on architecture
case "$architecture" in
    "armhf" | "")
      archlink=armv7l
      armrelease=$(echo "$releases" | tr " " "\\n" | grep armv7)
    ;;
    "arm64")
      archlink=aarch64l
      armrelease=$(echo "$releases" | tr " " "\\n" | grep aarch64)
    ;;
esac

wget -c "$armrelease"
tar xvzf "$(basename "$armrelease")" ./balena-engine/balena-engine
mv balena-engine/balena-engine mnt/img_root/usr/bin/balena-engine-$archlink
_op _chroot chown root:root /usr/bin/balena-engine-$archlink
rm -rf balena-engine/

_op _chroot touch /usr/bin/balena-engine
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd-ctr
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-containerd-shim
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-daemon
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-proxy
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena-engine-runc
_op _chroot ln -sr /usr/bin/balena-engine /usr/bin/balena
_op _chroot rm /usr/bin/balena-engine
_op _chroot ln -sr /usr/bin/balena-engine-$archlink /usr/bin/balena-engine

_op _chroot groupadd balena
_op _chroot usermod -aG balena pi
_op _chroot usermod -aG balena root

_op _chroot rm -rf /var/lib/balena-engine
_op _chroot ln -sr /var/lib/docker /var/lib/balena-engine

#install balena service scripts

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

cat << EOF > mnt/img_root/etc/systemd/system/balena.service
[Unit]
Description=Balena Application Container Engine
Documentation=https://www.balena.io/engine/
After=network-online.target balena.socket firewalld.service
Wants=network-online.target
Requires=balena.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by balena
ExecStart=/usr/bin/balena-engine-daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/balena-engine.sock
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of balena containers
Delegate=yes
# kill only the balena process, not all processes in the cgroup
KillMode=process
# restart the balena process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

_op _chroot chmod +x /etc/systemd/system/balena.service
_op _chroot chmod +x /etc/systemd/system/balena.socket