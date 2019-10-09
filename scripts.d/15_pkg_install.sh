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
    speedtest-cli # speedtest.net
    libffi-dev # for building docker-compose using pip
    python3-coral-enviro # Coral environmental board
    libusb-1.0-0 python3-pil python3-numpy libc++1 libc++abi1 libunwind8 libgcc1 # For Coral TPU
)

if [[ ${INSTALL_PACKAGES:-} ]] ; then
    echo "Installing ${INSTALL_PACKAGES[*]}"
    _apt install "${INSTALL_PACKAGES[@]}" || die "Could not install ${INSTALL_PACKAGES[*]}"
fi

_op _chroot apt-mark hold tor #TODO bring back to upstream
