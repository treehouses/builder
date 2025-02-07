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

# Get the list of upgradable packages and store in an array
mapfile -t upgradable_array < <(apt list --upgradable 2>/dev/null | awk -F'/' 'NR>1 {print $1}' | sort -u)

echo "Packages to be upgraded: ${upgradable_array[*]}"

# Function to install a package and its dependencies
install_package_with_deps() {
    local package=$1

    # Ensure we don’t process empty or null values
    if [[ -z "$package" ]]; then
        echo "ERROR: Empty package name encountered. Skipping..."
        return
    fi

    echo "Processing $package..."

    # Get package dependencies
    dependencies=$(apt-cache depends "$package" 2>/dev/null | awk '/Depends:/ {print $2}' | grep -v "<" | sort -u)

    if [[ -n "$dependencies" ]]; then
        echo "Dependencies found for $package: $dependencies"
        for dep in $dependencies; do
            # Ensure the dependency is in the upgradable list
            if [[ " ${upgradable_array[*]} " =~ " ${dep} " ]]; then
                echo "Upgrading dependency first: $dep"
                _apt install --only-upgrade -y "$dep" || echo "Failed to upgrade $dep"

                # Remove installed dependency from the array
                upgradable_array=("${upgradable_array[@]/$dep}")
            fi
        done
    else
        echo "No dependencies found for $package"
    fi

    # Install the main package
    echo "Upgrading $package..."
    _apt install --only-upgrade -y "$package" || echo "Failed to upgrade $package"

    # Remove the installed package from the list
    upgradable_array=("${upgradable_array[@]/$package}")

    # Rebuild the array to remove empty slots
    upgradable_array=($(echo "${upgradable_array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
}

# Process each package in the queue
while [[ ${#upgradable_array[@]} -gt 0 ]]; do
    install_package_with_deps "${upgradable_array[0]}"
done

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done
