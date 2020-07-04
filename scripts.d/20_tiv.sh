#!/bin/bash

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
CXX=aarch64-linux-gnu-g++ make -C TerminalImageViewer/src/main/cpp
mv TerminalImageViewer/src/main/cpp/tiv mnt/img_root/usr/local/bin/
