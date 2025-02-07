#!/bin/bash

source lib.sh

echo "Installing @treehouses/cli script"

mkdir node_root
npm config set prefix "$PWD/node_root"
npm install --unsafe-perm -g @treehouses/cli@1.26.18
npm install --unsafe-perm -g bats-support@0.3.0
npm install --unsafe-perm -g bats-assert@2.0.0
(cd node_root || exit 1; tar c .) | (cd mnt/img_root/usr || exit 1; tar x)
echo "$PWD"
if [ ! -L "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses" ]; then ln -sr "$PWD/mnt/img_root/usr/lib/node_modules/@treehouses/cli/_treehouses" "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses"; fi
ls -al "$PWD/mnt/img_root/etc/bash_completion.d/_treehouses"
npm config delete prefix
rm -rf node_root

_op _chroot treehouses sshkey github adduser dogi
_op _chroot treehouses sshkey github adduser mutugiii
_op _chroot treehouses sshkey github adduser okuro3499
_op _chroot treehouses sshkey github adduser xyb994
_op _chroot treehouses sshkey github adduser hirotochigi
_op _chroot treehouses sshkey github adduser jessewashburn
_op _chroot treehouses sshkey github adduser pavi38
_op _chroot treehouses sshkey github adduser paulbert
_op _chroot treehouses sshkey github adduser plataformasinformaticas
#_op _chroot treehouses sshkey github addteam treehouses support $APIKEY
