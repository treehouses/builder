#! /bin/bash

wget -P mnt/img_root/usr/local/bin https://github.com/darthnoward/tg/releases/download/1.3.1/telegram-cli || exit 1
chmod +x mnt/img_root/usr/local/bin/telegram-cli
mkdir -p mnt/img_root/etc/telegram-cli
wget -P mnt/img_root/etc/telegram-cli https://github.com/vysheng/tg/raw/master/tg-server.pub || exit 1
