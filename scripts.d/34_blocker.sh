#!/bin/bash

cd "$PWD/mnt/img_root/usr/lib/node_modules/@treehouses/cli/"
wget -q -O 1_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
wget -q -O 2_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts
wget -q -O 3_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts
wget -q -O 4_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
wget -q -O 5_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts
cd -