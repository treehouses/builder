#!/bin/bash

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
cd TerminalImageViewer/src/main/cpp
CXX=arm-linux-gnueabihf-g++ make
ls -al #where is tiv
echo "$PWD"
mv tiv "$PWD/mnt/img_root/usr/local/bin/"