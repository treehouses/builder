#!/bin/bash
source lib.sh
_op _chroot service uptimed stop
_op _chroot systemctl disable uptimed
