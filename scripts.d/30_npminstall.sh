#!/bin/bash

source lib.sh

echo "Installing @treehouses/cli script"

mkdir node_root
npm config set prefix "$PWD/node_root"
npm install --unsafe-perm -g @treehouses/cli@1.12.0
(cd node_root || exit 1; tar c .) | (cd mnt/img_root/usr || exit 1; tar x)
echo "$PWD"
ln -sr "$PWD/mnt/img_root/usr/lib/node_modules/@treehouses/cli/_treehouses" "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses"

ls -al "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses"
npm config delete prefix
rm -rf node_root
