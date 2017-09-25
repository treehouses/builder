#!/bin/bash

source lib.sh

echo "Installing ip script"

mkdir node_root
npm config set prefix $PWD/node_root
npm install -g @pirateship/cli@0.2.4
(cd node_root; tar c .) | (cd mnt/img_root/usr; tar x)
npm config delete prefix
rm -rf node_root
