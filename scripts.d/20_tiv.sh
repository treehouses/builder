#!/bin/bash

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
cd TerminalImageViewer/src/main/cpp
CXX=arm-linux-gnueabihf-g++ make
ls -al #where is tiv
mv tiv mnt/img_root/usr/local/bin/
