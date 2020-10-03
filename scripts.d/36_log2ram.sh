#!/bin/bash

source lib.sh

_op _chroot curl -Lo log2ram.tar.gz https://github.com/azlux/log2ram/archive/master.tar.gz
_op _chroot tar xf log2ram.tar.gz
_op _chroot rm log2ram.tar.gz
_op _chroot cd log2ram-master 
_op _chroot ./install.sh
_op _chroot cd ..
_op _chroot rm -r log2ram-master
_op _chroot systemctl stop log2ram
_op _chroot systemctl disable log2ram

