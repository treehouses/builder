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
    vim # pwnagotchi packages >
    screen
    golang
    git
    build-essential
    python3-pip
    python3-mpi4py
    python3-smbus
    unzip
    gawk
    libopenmpi-dev
    libatlas-base-dev
    libjasper-dev
    libqtgui4
    libqt4-test
    libopenjp2-7
    libtiff5
    tcpdump
    lsof
    libilmbase23
    libopenexr23
    libgstreamer1.0-0
    libavcodec58
    libavformat58
    libswscale5
    libpcap-dev
    libusb-1.0-0-dev
    libnetfilter-queue-dev
    libopenmpi3
    dphys-swapfile
    kalipi-kernel
    kalipi-bootloader
    kalipi-re4son-firmware
    kalipi-kernel-headers
    libraspberrypi0
    libraspberrypi-dev
    libraspberrypi-doc
    libraspberrypi-bin
    fonts-dejavu
    fonts-dejavu-core
    fonts-dejavu-extra
    python3-pil
    python3-smbus
    libfuse-dev
    fonts-freefont-ttf
    fbi
    python3-flask
    python3-flask-cors
    python3-flaskext.wtf # < pwnagotchi packages
)

if [[ ${INSTALL_PACKAGES:-} ]] ; then
    echo "Installing ${INSTALL_PACKAGES[*]}"
    _apt install "${INSTALL_PACKAGES[@]}" || die "Could not install ${INSTALL_PACKAGES[*]}"
fi

_op _chroot apt-mark hold tor #TODO bring back to upstream
