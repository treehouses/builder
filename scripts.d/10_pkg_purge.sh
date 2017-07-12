#!/bin/bash

source lib.sh

# List of packages to remove
PURGE_PACKAGES=(
    wolfram-engine
    sonic-pi
    scratch
    squeak-plugins-scratch squeak-vm
)

PURGE_PACKAGES=( $(
    for package in "${PURGE_PACKAGES[@]}" ; do
        if _chroot dpkg -s "$package" &>/dev/null ; then
            echo "$package"
        fi
    done
) )

if [[ ${PURGE_PACKAGES:-} ]] ; then
    echo "Removing unwanted packages ${PURGE_PACKAGES[@]}"
    _apt purge "${PURGE_PACKAGES[@]}" ||\
        die "Could not remove ${PURGE_PACKAGES[@]}"
fi

