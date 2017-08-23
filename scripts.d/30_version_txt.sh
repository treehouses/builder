#!/bin/sh

set -e

ROOT=mnt/img_root
version=$(git describe --tags --always --dirty)
echo "writing version.txt: $version"
echo $version > $ROOT/boot/version.txt
