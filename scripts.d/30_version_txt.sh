#!/bin/sh

set -e

ROOT=mnt/img_root
version=$(git tag --sort=-creatordate | sed -n '1p')
echo "writing version.txt: $version"
echo "$version" > $ROOT/boot/version.txt
