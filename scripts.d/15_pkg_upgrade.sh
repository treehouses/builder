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

while true; do
    echo "Fetching list of upgradeable packages"
    mapfile -t upgradeable_packages < <(_op _chroot apt list --upgradable 2>/dev/null | awk -F/ 'NR>1 {print $1}' | grep -v '^$')
    
    if [ ${#upgradeable_packages[@]} -eq 0 ]; then
        echo "No more packages to upgrade. Exiting loop."
        break
    fi
    
    echo "Upgradeable packages:"
    printf '%s\n' "${upgradeable_packages[@]}"
    
    echo "Upgrading first package: ${upgradeable_packages[0]}"
    _op _chroot apt install -y "${upgradeable_packages[0]}" || die "Failed to upgrade ${upgradeable_packages[0]}"
done

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done

echo "Upgrade process completed."
