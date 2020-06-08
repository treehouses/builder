#!/bin/bash

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
cd TerminalImageViewer/src/main/cpp
CXX=arm-linux-gnueabihf-g++ make
mv tiv mnt/img_root/usr/local/bin/
