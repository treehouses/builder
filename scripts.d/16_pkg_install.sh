#!/bin/bash

source lib.sh

INSTALL_PACKAGES=(
    avahi-daemon vim lshw iotop screen tmux # essentials
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin # docker
    # quicksynergy # dogi
    matchbox-keyboard # virtual keyboard
    #mdadm initramfs-tools # for RAID1
    elinks links lynx # text mode web browser
    hostapd dnsmasq # rpi access point
    dos2unix # for converting dos characters to unix in autorunonce
    nodejs
    autossh rsync htop mc gh sl jq bc nmap
    python3-pip python3-dbus
    bluez minicom bluez-tools python3-bluez libbluetooth-dev # bluetooth hotspot
    avahi-autoipd # for usb0
    rng-tools # for ap bridge
    tor
    openvpn
    shadowsocks-libev proxychains4 # socks5 proxy
    libpam-google-authenticator # two factor authentication
    net-tools # netstat
    iproute2 # ss command
    speedtest-cli # speedtest.net
    ##python3-coral-enviro # Coral environmental board # breaks with new kernel
    libusb-dev # for usb.sh
    dnsutils
    uptimed # for measuring rpi uptime
    pagekite # tunnels command
    netcat-openbsd # for arm64
    ##ranger
    bats # unit testing
    ##libhdf5-dev libatlas-base-dev libqt4-test # opencv # libjasper1 
    imagemagick # tiv
    ##python3-bcrypt python3-nacl # fix slow pip
)

_op _chroot apt-mark hold linux-headers-rpi-v8
_op _chroot apt-mark hold linux-image-rpi-v8
_op _chroot apt-mark hold linux-headers-rpi-2712
_op _chroot apt-mark hold linux-image-rpi-2712
_op _chroot apt-mark hold initramfs-tools

#if [[ ${INSTALL_PACKAGES:-} ]] ; then
#    echo "Installing ${INSTALL_PACKAGES[*]}"
#    _apt install "${INSTALL_PACKAGES[@]}" # || die "Could not install ${INSTALL_PACKAGES[*]}"
#fi

for package in "${INSTALL_PACKAGES[@]}"; do
    _apt install -y "$package"
    if [[ $? -ne 0 ]]; then
        echo "Error installing $package. Continuing..."
    fi
done

_op _chroot apt-mark hold tor #TODO bring back to upstream
_op _chroot apt-mark unhold linux-headers-rpi-v8
_op _chroot apt-mark unhold linux-image-rpi-v8
_op _chroot apt-mark unhold linux-headers-rpi-2712
_op _chroot apt-mark unhold linux-image-rpi-2712
_op _chroot apt-mark unhold initramfs-tools
