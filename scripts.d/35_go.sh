#!/bin/bash

source lib.sh

version='go1.14.3.linux-armv6l.tar.gz'
_op _chroot wget "https://dl.google.com/go/$version"
_op _chroot tar -C /usr/local -xvf "$version"
#_op _chroot touch ~/.bashrc
_op _chroot cat >> ~/.bashrc << 'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
_op _chroot bash -c "source ~/.bashrc"
_op _chroot rm "$version"
