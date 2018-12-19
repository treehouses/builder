#!/bin/bash

source lib.sh

ROOT=mnt/img_root

_install() {
    owner="$1"
    home="$2"
    install -o "$owner" -g "$owner" -m 700 -d "$home/.ssh"
    install -o "$owner" -g "$owner" -m 600 authorized_keys "$home/.ssh"
}

echo "installing SSH keys for root"
_install root $ROOT/root
echo "installing SSH keys for pi"
_install 1000 $ROOT/home/pi
