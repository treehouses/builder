#!/bin/sh

echo $PWD
ls -al

cat $PWD/mnt/img_root/root/.ssh/authorized_keys
ls -al mnt/img_root/root/.ssh/

set -e

ROOT=mnt/img_root
version=$(git tag --sort=-creatordate | sed -n '1p')
echo "writing version.txt: $version"
echo "$version" > $ROOT/boot/version.txt
