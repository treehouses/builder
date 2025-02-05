#!/bin/bash
source lib.sh

pkgs=("apt-transport-https")

echo "updating package sources"
_apt update --allow-releaseinfo-change || die "Could not update package sources"
_apt install "${pkgs[@]}"

mkdir -p /etc/apt/trusted.gpg.d/
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor -o mnt/img_root/etc/apt/trusted.gpg.d/nodesource.gpg
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o mnt/img_root/etc/apt/trusted.gpg.d/docker.gpg

ADD_REPOS=(
    "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_20.x bookworm main"
    "deb [signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/debian bookworm stable"
    # curl https://cli.github.com/packages/githubcli-archive-keyring.gpg > keys/C99B11DEB97541F0.key
    #"deb [arch=aarch64] https://cli.github.com/packages stable main"
    # curl https://packages.cloud.google.com/apt/doc/apt-key.gpg > keys/8B57C5C2836F4BEB.key
    #"deb https://packages.cloud.google.com/apt coral-cloud-stable main"
)

LIST=mnt/img_root/etc/apt/sources.list.d/treehouses.list

if [[ "${ADD_REPOS:-}" && ! -f "$LIST" ]] ; then
    for repo in "${ADD_REPOS[@]}" ; do
        echo "$repo"
    done > $LIST || die "Could not add repos ${ADD_REPOS[*]}"
    _apt update --allow-releaseinfo-change || die "Could not update package sources"
fi
