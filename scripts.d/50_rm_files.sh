#!/bin/bash

source lib.sh
# List of files/directories to remove
REMOVE=(
)

for file in "${REMOVE[@]}" ; do
  _op _chroot rm -rf "$file"
  echo "- '$file' removed"
done

sync; sync; sync
_op _chroot tree /home/
