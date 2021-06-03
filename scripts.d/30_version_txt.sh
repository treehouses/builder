#!/bin/sh
architecture="$1"
set -e

ROOT=mnt/img_root
case "$architecture" in
  "armhf" | "") 
    version=$(git tag --sort=-creatordate | sed -n '1p')
  ;;
  "arm64") 
    version="$(git tag --sort=-creatordate | sed -n '1p')-$architecture"
  ;;
esac
echo "writing version.txt: $version"
echo "$version" > $ROOT/boot/version.txt