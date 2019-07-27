#!/bin/bash

source lib.sh

is_installed() {
    pkg="$1"
    _chroot dpkg-query -s "$pkg" 2>/dev/null | grep -qx 'Status: install ok installed'
}

install_stuff() {
    local need_install
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
    "deb-src https://deb.nodesource.com/node_10.x buster main"
    # curl -fsSL https://download.docker.com/linux/debian/gpg > keys/0EBFCD88.key
    "deb [arch=armhf] https://download.docker.com/linux/raspbian stretch stable"
    # curl -fsSL http://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc > keys/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.key
    "deb http://deb.torproject.org/torproject.org buster main"
    "deb-src http://deb.torproject.org/torproject.org buster main"
    # curl https://packages.cloud.google.com/apt/doc/apt-key.gpg > keys/6A030B21BA07F4FB.key
    "deb https://packages.cloud.google.com/apt coral-cloud-stable main"
)

LIST=mnt/img_root/etc/apt/sources.list.d/treehouses.list

if [[ "${ADD_REPOS:-}" && ! -f "$LIST" ]] ; then
    install_stuff
    for repo in "${ADD_REPOS[@]}" ; do
        echo "$repo"
    done > $LIST || die "Could not add repos ${ADD_REPOS[*]}"
    _apt update --allow-releaseinfo-change || die "Could not update package sources"
fi
