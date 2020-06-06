#!/bin/bash

source lib.sh

# List of packages to remove
PURGE_PACKAGES=(
    wolfram-engine
    apt-listchanges
#    sonic-pi
#    scratch
#    squeak-plugins-scratch squeak-vm
#    dphys-swapfile
)

# shellcheck disable=SC2207
PURGE_PACKAGES=( $(
    for package in "${PURGE_PACKAGES[@]}" ; do
        if _chroot dpkg -s "$package" &>/dev/null ; then
            echo "$package"
        fi
    done
) )

if [[ ${PURGE_PACKAGES:-} ]] ; then
    echo "Removing unwanted packages ${PURGE_PACKAGES[*]}"
    _apt purge "${PURGE_PACKAGES[@]}" ||\
        die "Could not remove ${PURGE_PACKAGES[*]}"
    _apt autoremove ||\
        die "Error in auto remove"
fi

