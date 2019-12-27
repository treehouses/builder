#!/bin/bash

source lib.sh

INSTALL_PACKAGES=(
    avahi-daemon vim lshw iotop screen # essentials
    docker-ce aufs-dkms- # docker
    quicksynergy # dogi
    matchbox-keyboard # virtual keyboard
    mdadm initramfs-tools rsync # for RAID1
    elinks # text mode web browser
    hostapd dnsmasq # rpi access point
    dos2unix # for converting dos characters to unix in autorunonce
    nodejs # version 8.5.0-1nodesource1
    autossh
    python3-pip python3-dbus
    bluez minicom bluez-tools libbluetooth-dev # bluetooth hotspot
    avahi-autoipd # for usb0
    rng-tools # for ap bridge
    tor=0.3.5.8-1 #TODO bring back to upstream
    openvpn
    jq # for parsing json / treehouses command
    net-tools # netstat
    nmap # network mapping package
    htop
    speedtest-cli # speedtest.net
    libffi-dev # for building docker-compose using pip
    python3-coral-enviro # Coral environmental board
    bc # for memory command
    dnsutils 
    build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev # pwnagotchi dependencies
    libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev 
    liblzma-dev zlib1g-dev libffi-dev
)

if [[ ${INSTALL_PACKAGES:-} ]] ; then
    echo "Installing ${INSTALL_PACKAGES[*]}"
    _apt install "${INSTALL_PACKAGES[@]}" || die "Could not install ${INSTALL_PACKAGES[*]}"
fi

_op _chroot apt-mark hold tor #TODO bring back to upstream
