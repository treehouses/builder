#! /bin/bash

git clone https://github.com/kenorb-contrib/tg --recursive

cd tg || exit 1
./configure
CXX=arm-linux-gnueabihf-gcc make
cd .. || exit 1
cp tg/bin/telegram-cli mnt/img_root/usr/local/bin/telegram-cli
mkdir -p mnt/img_root/etc/telegram-cli
cp tg/server.pub mnt/img_root/etc/telegram-cli/server.pub
