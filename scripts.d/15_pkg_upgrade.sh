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
upgradable_packages=$(apt list --upgradable 2>/dev/null | awk -F'/' 'NR>1 {print $1}')

# Convert the list into an array
mapfile -t upgradable_array <<< "$upgradable_packages"

echo "Packages to be upgraded: ${upgradable_array[*]}"

# Function to install a package and its dependencies
install_package_with_deps() {
    local package=$1

    # Skip if package is empty (prevents infinite loop issues)
    if [[ -z "$package" ]]; then
        echo "ERROR: Empty package name encountered. Skipping..."
        return
    fi

    echo "Processing $package..."

    # Get package dependencies
    dependencies=$(apt-cache depends "$package" 2>/dev/null | awk '/Depends:/ {print $2}' | grep -v "<")

    if [[ -n "$dependencies" ]]; then
        echo "Dependencies found for $package: $dependencies"
        for dep in $dependencies; do
            # Only upgrade dependencies that are in the upgradable list
            if [[ " ${upgradable_array[*]} " =~ " ${dep} " ]]; then
                echo "Upgrading dependency first: $dep"
                _apt install --only-upgrade -y "$dep" || echo "Failed to upgrade $dep"
                # Remove the dependency from the list of upgradable packages
                upgradable_array=("${upgradable_array[@]/$dep}")
            fi
        done
    else
        echo "No dependencies found for $package"
    fi

    # Install the main package
    echo "Upgrading $package..."
    _apt install --only-upgrade -y "$package" || echo "Failed to upgrade $package"

    # Remove package from the upgradable list
    for i in "${!upgradable_array[@]}"; do
        if [[ "${upgradable_array[i]}" == "$package" ]]; then
            unset "upgradable_array[i]"
            break
        fi
    done
}

# Loop through upgradable packages and process them one by one
while [[ ${#upgradable_array[@]} -gt 0 ]]; do
    install_package_with_deps "${upgradable_array[0]}"
    upgradable_array=("${upgradable_array[@]}")  # Remove empty array slots
done

echo "Releasing held packages..."
for pkg in "${packages_to_hold[@]}"; do
    _op _chroot apt-mark unhold "$pkg"
done
