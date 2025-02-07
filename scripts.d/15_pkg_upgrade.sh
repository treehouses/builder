#!/bin/bash
source lib.sh

# Temporary fix to not break GUI icons and background
packages_to_hold=(
    libfm-data libfm-extra4 libfm-gtk-data libfm-gtk4 libfm-modules libfm4
    raspberrypi-ui-mods linux-headers-rpi-v8 linux-image-rpi-v8
    linux-headers-rpi-2712 linux-image-rpi-2712 initramfs-tools
)

for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark hold "$pkg"
done

echo "Installing Updates"
_apt update || die "Could not update package sources"
_apt dist-upgrade || die "Could not upgrade system"

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done

echo "Upgrade process completed."
