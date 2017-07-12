#!/bin/bash

source lib.sh

# List of extra APT repositories
ADD_REPOS=(
    "deb https://packagecloud.io/Hypriot/Schatzkiste/raspbian/ jessie main"
    "deb-src https://packagecloud.io/Hypriot/Schatzkiste/raspbian/ jessie main"
)

if [[ "${ADD_REPOS:-}" ]] ; then
    _apt update || die "Could not update package sources"
    # Is this necessary?
    _apt install debian-archive-keyring apt-transport-https || die "Could not install debian-archive-keyring apt-transport-https"
    for repo in "${ADD_REPOS[@]}" ; do
        echo "$repo"
    done > mnt/img_root/etc/apt/sources.list.d/treehouse-builder.list || die "Could not add repos ${ADD_REPOS[@]}"
    _apt update || die "Could not update package sources"
fi
