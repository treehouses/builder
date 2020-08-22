#! /bin/bash

git clone https://github.com/vysheng/tg --recursive

cd tg || exit 1
sed -i '107d' ./tgl/mtproto-utils.c
sed -i '101d' ./tgl/mtproto-utils.c
sed -i "s/\-rdynamic //" Makefile.in
sed -i "s/\-fPIC//" Makefile.in
sed -i "s/\-Werror //" Makefile.in
./configure
CXX=arm-linux-gnueabihf-g++ make
cd .. || exit 1
cp tg/bin/telegram-cli mnt/img_root/usr/local/bin/telegram-cli
mkdir -p mnt/img_root/etc/telegram-cli
cp tg/server.pub mnt/img_root/etc/telegram-cli/server.pub
