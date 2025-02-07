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

echo "Updating package lists"
_apt update || die "Could not update package sources"

echo "Fetching list of upgradeable packages without dependencies"
upgradeable_packages=($( _op _chroot apt list --upgradable | awk -F/ 'NR>1 {print $1}' ))

echo "Found ${#upgradeable_packages[@]} upgradeable packages."

if [ ${#upgradeable_packages[@]} -eq 0 ]; then
    echo "No packages to upgrade."
else
    installable_packages=()
    for pkg in "${upgradeable_packages[@]}"; do
        echo "Checking dependencies for $pkg"
        dependencies=$( _op _chroot apt-cache depends "$pkg" | grep "Depends:" | awk '{print $2}' )
        upgrade_needed=false
        for dep in $dependencies; do
            if printf '%s\n' "${upgradeable_packages[@]}" | grep -q "^$dep$"; then
                upgrade_needed=true
                break
            fi
        done
        if [ "$upgrade_needed" = false ]; then
            installable_packages+=("$pkg")
        fi
    done
    
    echo "Found ${#installable_packages[@]} standalone packages to upgrade."
    
    if [ ${#installable_packages[@]} -eq 0 ]; then
        echo "No standalone packages to upgrade."
    else
        echo "Upgrading standalone packages"
        for pkg in "${installable_packages[@]}"; do
            echo "Upgrading $pkg"
            _op _chroot apt install -y "$pkg" || die "Failed to upgrade $pkg"
        done
    fi
fi

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done

echo "Upgrade process completed."
