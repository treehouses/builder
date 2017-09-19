#!/bin/bash

source lib.sh

INSTALL_PACKAGES=(
    avahi-daemon vim lshw iotop screen #essentials
#    debian-archive-keyring apt-transport-https #hypriot
    docker-hypriot #docker
    quicksynergy #dogi
    matchbox-keyboard #virtual keyboard
    mdadm initramfs-tools rsync # for RAID1
    elinks # text mode web browser
    hostapd dnsmasq # rpi access point
    dos2unix # for converting dos characters to unix in autorunonce
    nodejs # installs new node
)

if [[ ${INSTALL_PACKAGES:-} ]] ; then
    echo "Installing ${INSTALL_PACKAGES[@]}"
    _apt install ${INSTALL_PACKAGES[@]} || die "Could not install ${INSTALL_PACKAGES[@]}"
fi
