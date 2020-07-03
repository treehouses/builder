#!/bin/bash

source lib.sh

INSTALL_PACKAGES=(
    avahi-daemon vim lshw iotop screen tmux # essentials
    docker-ce aufs-dkms- # docker
    quicksynergy # dogi
    matchbox-keyboard # virtual keyboard
    mdadm initramfs-tools rsync # for RAID1
    elinks links lynx # text mode web browser
    hostapd dnsmasq # rpi access point
    dos2unix # for converting dos characters to unix in autorunonce
    nodejs # version 8.5.0-1nodesource1
    autossh
    python3-pip python3-dbus
    bluez minicom bluez-tools libbluetooth-dev # bluetooth hotspot
    avahi-autoipd # for usb0
    rng-tools # for ap bridge
    tor=0.3.5.10-1 #TODO bring back to upstream
    openvpn
    jq # for parsing json / treehouses command
    net-tools # netstat
    iproute2 # ss command
    nmap # network mapping package
    htop
    speedtest-cli # speedtest.net
    libffi-dev # for building docker-compose using pip
    python3-coral-enviro # Coral environmental board
    bc # for memory command
    libusb-dev # for usb.sh
    dnsutils
    uptimed # for measuring rpi uptime
    pagekite # tunnels command
    sl
    mc ranger
    bats # unit testing
    libhdf5-dev libatlas-base-dev libjasper1 libqt4-test # opencv
    imagemagick # tiv
)

if [[ ${INSTALL_PACKAGES:-} ]] ; then
    echo "Installing ${INSTALL_PACKAGES[*]}"
    _apt install "${INSTALL_PACKAGES[@]}" || die "Could not install ${INSTALL_PACKAGES[*]}"
fi

_op _chroot apt-mark hold tor #TODO bring back to upstream
