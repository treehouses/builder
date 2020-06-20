#! /bin/bash

source lib.sh

wget https://ftp.gnu.org/pub/gnu/emacs/emacs-26.1.tar.gz
tar -zxvf emacs-26.1.tar.gz
cd emacs-26.1 || exit
./configure --without-x --with-gnutls=no
make --quiet
_op _chroot make install --quiet
cd ../ && rm -rf emacs-26.1 && rm -rf emacs-26.1.tar.gz
