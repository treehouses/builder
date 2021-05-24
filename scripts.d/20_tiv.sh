#!/bin/bash
exit 0

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
CXX=arm-linux-gnueabihf-g++ make -C TerminalImageViewer/src/main/cpp
mv TerminalImageViewer/src/main/cpp/tiv mnt/img_root/usr/local/bin/
