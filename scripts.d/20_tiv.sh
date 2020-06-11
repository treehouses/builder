#!/bin/bash

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
CXX=arm-linux-gnueabihf-g++ make -C TerminalImageViewer/src/main/cpp
ls -al #where is tiv
echo "$PWD"
mv TerminalImageViewer/src/main/cpp/tiv "$PWD/mnt/img_root/usr/local/bin/"