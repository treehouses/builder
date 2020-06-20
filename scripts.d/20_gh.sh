#!/bin/bash

source lib.sh
# git clone https://github.com/cli/cli.git gh-cli
# env GOOS=linux GOARCH=arm GOOARM=6 make -C gh-cli
# mv gh-cli/bin/gh mnt/img_root/usr/local/bin/

wget -N https://github.com/cli/cli/releases/download/v0.10.0/gh_0.10.0_linux_amd64.deb mnt/img_root/root
_op _chroot pwd
_apt install gh_0.10.0_linux_amd64.deb