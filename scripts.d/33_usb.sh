#!/bin/bash

source lib.sh

wget https://raw.githubusercontent.com/codazoda/hub-ctrl.c/master/hub-ctrl.c
gcc -o hub-ctrl hub-ctrl.c -lusb

mkdir -p mnt/img_root/usr/local/bin/
mv hub-ctrl mnt/img_root/usr/local/bin/.