#!/bin/bash

source lib.sh

echo "Installing node"

_apt install nodejs-legacy npm

echo "Installing ip script"

_chroot npm install -g pirate-sh
