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
    mapfile -t upgradeable_packages < <(_op _chroot apt list --upgradable 2>/dev/null | awk -F/ 'NR>1 {print $1}' | grep -v '^WARNING' | grep -v '^Listing' | grep -v '^$')
    
    if [ ${#upgradeable_packages[@]} -eq 0 ]; then
        echo "No more packages to upgrade. Exiting loop."
        break
    fi
    
    echo "Upgradeable packages:"
    printf '%s\n' "${upgradeable_packages[@]}"
    
    last_package="${upgradeable_packages[-1]}"
    if [[ -z "$last_package" || "$last_package" == *WARNING* || "$last_package" == "Listing" ]]; then
        echo "Invalid package name detected, skipping..."
        continue
    fi
    
    echo "Upgrading last package: $last_package"
    _op _chroot apt install -y "$last_package" || die "Failed to upgrade $last_package"
done

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done

echo "Upgrade process completed."
