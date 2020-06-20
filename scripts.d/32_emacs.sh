#! /bin/bash

source lib.sh

wget https://ftp.gnu.org/pub/gnu/emacs/emacs-26.1.tar.gz
tar -zxvf emacs-26.1.tar.gz
cd emacs-26.1 || exit
./configure --without-x --prefix=/usr/local/emacs --with-gnutls=no
make
_chroot make install
cd ../ && rm -rf emacs-26.1
