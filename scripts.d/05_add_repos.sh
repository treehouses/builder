#!/bin/bash

source lib.sh

is_installed() {
    pkg="$1"
    dpkg-query -s "$pkg" 2>/dev/null | grep -qx 'Status: install ok installed'
}

install_stuff() {
    local need_install
    pkgs="debian-archive-keyring apt-transport-https"

    for pkg in $pkgs; do
        if ! is_installed $pkg; then
            need_install="$need_install $pkg"
            echo "need to install $pkg"
        fi
    done

    if [ -n "$need_install" ]; then
        echo "updating package sources"
        _apt update || die "Could not update package sources"
        _apt install $pkgs
    fi
}

# List of extra APT repositories
ADD_REPOS=(
    "deb https://packagecloud.io/Hypriot/Schatzkiste/raspbian/ jessie main"
    "deb-src https://packagecloud.io/Hypriot/Schatzkiste/raspbian/ jessie main"
)

LIST=mnt/img_root/etc/apt/sources.list.d/treehouse-builder.list

if [[ "${ADD_REPOS:-}" && ! -f "$LIST" ]] ; then
    install_stuff
    for repo in "${ADD_REPOS[@]}" ; do
        echo "$repo"
    done > $LIST || die "Could not add repos ${ADD_REPOS[@]}"
    _apt update || die "Could not update package sources"
fi
