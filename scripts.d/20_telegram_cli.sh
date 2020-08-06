#! /bin/bash

git clone https://github.com/vysheng/tg --recursive
cd tg
sed '116d' ./tgl/mtproto-utils.c
sed '105d' ./tgl/mtproto-utils.c
./configure
make
cp ./bin/telegram-cli /mnt/img_root/usr/local/bin/telegram-cli
cd ../
rm -rf tg
