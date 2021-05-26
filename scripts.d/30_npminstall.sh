#!/bin/bash

source lib.sh

echo "Installing @treehouses/cli script"

mkdir node_root
npm config set prefix "$PWD/node_root"
npm install --unsafe-perm -g @treehouses/cli@1.25.58
npm install --unsafe-perm -g bats-support@0.3.0
npm install --unsafe-perm -g bats-assert@2.0.0
(cd node_root || exit 1; tar c .) | (cd mnt/img_root/usr || exit 1; tar x)
echo "$PWD"
if [ ! -L "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses" ]; then ln -sr "$PWD/mnt/img_root/usr/lib/node_modules/@treehouses/cli/_treehouses" "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses"; fi
ls -al "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses"
npm config delete prefix
rm -rf node_root
