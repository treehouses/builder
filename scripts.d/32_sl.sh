#!/bin/bash
exit 0 
source lib.sh

_op _chroot ln -sr /usr/games/sl /usr/local/bin/sl
ls -al mnt/img_root/usr/local/bin/sl
