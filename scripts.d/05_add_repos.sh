#!/bin/bash

source lib.sh

is_installed() {
    pkg="$1"
    _chroot dpkg-query -s "$pkg" 2>/dev/null | grep -qx 'Status: install ok installed'
}

install_stuff() {
    local need_install
    #pkgs=("raspbian-archive-keyring" "apt-transport-https")
    pkgs=("raspbian-archive-keyring" "apt-transport-https")

    for pkg in ${pkgs[*]}; do
        if ! is_installed "$pkg"; then
            need_install="$need_install $pkg"
            echo "need to install $pkg"
        fi
    done

    if [ -n "$need_install" ]; then
        echo "updating package sources"
        _apt update --allow-releaseinfo-change || die "Could not update package sources"
        _apt install "${pkgs[@]}"
    fi
}

# List of extra APT repositories
ADD_REPOS=(
    # curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key > keys/68576280.key
    "deb https://deb.nodesource.com/node_10.x buster main"
    # curl -fsSL https://download.docker.com/linux/debian/gpg > keys/0EBFCD88.key
    "deb [arch=arm64] https://download.docker.com/linux/raspbian stretch stable"
    # curl https://cli.github.com/packages/githubcli-archive-keyring.gpg > keys/C99B11DEB97541F0.key
    "deb [arch=arm64] https://cli.github.com/packages buster main"
    # curl https://packages.cloud.google.com/apt/doc/apt-key.gpg > keys/8B57C5C2836F4BEB.key
    "deb https://packages.cloud.google.com/apt coral-cloud-stable main"
    #"deb http://deb.debian.org/debian stretch-backports main"
)

LIST=mnt/img_root/etc/apt/sources.list.d/treehouses.list

if [[ "${ADD_REPOS:-}" && ! -f "$LIST" ]] ; then
    install_stuff
    for repo in "${ADD_REPOS[@]}" ; do
        echo "$repo"
    done > $LIST || die "Could not add repos ${ADD_REPOS[*]}"
    _apt update --allow-releaseinfo-change || die "Could not update package sources"
fi
