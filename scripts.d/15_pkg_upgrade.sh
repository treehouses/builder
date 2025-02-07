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

echo "Fetching list of upgradable packages..."
_apt update || die "Could not update package sources"

# Get the list of upgradable packages
mapfile -t upgradable_array < <(_apt list --upgradable 2>/dev/null | awk -F'/' 'NR>1 {print $1}' | sort -u)

declare -A dependency_count

echo "Grouping packages by dependency count..."
for pkg in "${upgradable_array[@]}"; do
    dep_count=$(_op _chroot apt-cache depends "$pkg" 2>/dev/null | awk '/Depends:/ {print $2}' | grep -v "<" | wc -l)
    dependency_count[$pkg]=$dep_count

done

max_round=10  # Prevent infinite loops
round=0

while [[ ${#dependency_count[@]} -gt 0 && $round -lt $max_round ]]; do
    echo "Starting round $((round+1))..."
    
    # Find packages with the current dependency count
    selected_packages=()
    for pkg in "${!dependency_count[@]}"; do
        if [[ ${dependency_count[$pkg]} -eq $round ]]; then
            selected_packages+=("$pkg")
        fi
    done
    
    if [[ ${#selected_packages[@]} -eq 0 ]]; then
        ((round++))
        continue
    fi
    
    echo "Upgrading: ${selected_packages[*]}"
    for pkg in "${selected_packages[@]}"; do
        _apt install --only-upgrade -y "$pkg" || echo "Failed to upgrade $pkg" >> upgrade_errors.log
        unset dependency_count[$pkg]  # Remove upgraded package
    done
    
    ((round++))
done

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done

echo "Upgrade process completed."
