#!/bin/bash

source lib.sh

echo "Installing ip script"

mkdir node_root
npm config set prefix "$PWD/node_root"
npm install --unsafe-perm -g @pirateship/cli@0.4.0
npm install --unsafe-perm -g @treehouses/cli@1.2.4
(cd node_root || exit 1; tar c .) | (cd mnt/img_root/usr || exit 1; tar x)
npm config delete prefix
rm -rf node_root
