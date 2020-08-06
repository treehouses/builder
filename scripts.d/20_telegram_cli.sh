#! /bin/bash

git clone https://github.com/vysheng/tg --recursive
cd tg
sed -i '116d' ./tgl/mtproto-utils.c
sed -i '105d' ./tgl/mtproto-utils.c
./configure
make
cp ./bin/telegram-cli /mnt/img_root/usr/local/bin/telegram-cli
mkdir -p /mnt/img_root/etc/telegram-cli
cp ./server.pub /mnt/img_root/etc/telegram-cli/server.pub
cd ../
rm -rf tg
