#!/bin/bash

source lib.sh

#MODE="debug"  # Comment for "default" for bulk upgrade mode

# Temporary fix to not break GUI icons and background
packages_to_hold=(
    libfm-data libfm-extra4 libfm-gtk-data libfm-gtk4 libfm-modules libfm4 raspberrypi-ui-mods
    linux-headers-rpi-v8 linux-image-rpi-v8 linux-headers-rpi-2712 linux-image-rpi-2712
    initramfs-tools initramfs-tools-core udev libudev1
    systemd-timesyncd systemd libpam-systemd libsystemd-shared libsystemd0
)

for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark hold "$pkg"
done

echo "Checking held packages..."
_chroot apt-mark showhold

echo "Installing Updates"
_apt update || die "Could not update package sources"

if [ "$MODE" == "debug" ]; then
    while true; do
        echo "Fetching list of upgradeable packages"
        mapfile -t all_upgradeable_packages < <(_chroot apt list --upgradable 2>/dev/null | awk -F/ 'NR>1 {print $1}' | grep -v '^WARNING' | grep -v '^Listing' | grep -v '^$')
        
        if [ ${#all_upgradeable_packages[@]} -eq 0 ]; then
            echo "No more packages to upgrade. Exiting loop."
            break
        fi
        
        echo "Filtering out held packages..."
        upgradeable_packages=()
        for pkg in "${all_upgradeable_packages[@]}"; do
            if [[ " ${packages_to_hold[*]} " =~ " $pkg " ]]; then
                echo "Skipping held package: $pkg"
            else
                upgradeable_packages+=("$pkg")
            fi
        done
        
        if [ ${#upgradeable_packages[@]} -eq 0 ]; then
            echo "No more non-held packages to upgrade. Exiting loop."
            break
        fi
        
        echo "Upgradeable packages:"
        printf '%s\n' "${upgradeable_packages[@]}"
        
        echo "Upgrading package: ${upgradeable_packages[0]}"
        _op _chroot apt install -y "${upgradeable_packages[0]}" || echo "Failed to upgrade ${upgradeable_packages[0]}"
    done
else
    echo "Fetching list of upgradeable packages"
    mapfile -t all_upgradeable_packages < <(_chroot apt list --upgradable 2>/dev/null | awk -F/ 'NR>1 {print $1}' | grep -v '^WARNING' | grep -v '^Listing' | grep -v '^$')
    
    echo "Filtering out held packages..."
    upgradeable_packages=()
    for pkg in "${all_upgradeable_packages[@]}"; do
        if [[ " ${packages_to_hold[*]} " =~ " $pkg " ]]; then
            echo "Skipping held package: $pkg"
        else
            upgradeable_packages+=("$pkg")
        fi
    done
    
    if [ ${#upgradeable_packages[@]} -eq 0 ]; then
        echo "No more non-held packages to upgrade. Exiting."
    else
        echo "Upgrading all non-held packages at once:"
        printf '%s\n' "${upgradeable_packages[@]}"
        _op _chroot apt install -y "${upgradeable_packages[@]}" || echo "Failed to upgrade some packages"
    fi
fi

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done

echo "Upgrade process completed."
