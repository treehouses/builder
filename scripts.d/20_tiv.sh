#!/bin/bash
exit 0
git clone https://github.com/stefanhaustein/TerminalImageViewer.git
(
  cd TerminalImageViewer || exit 0
  git checkout e5ef996c4432054c05e5af6965d405933c8391d1
)
CXX=arm-linux-gnueabihf-g++ make -C TerminalImageViewer/src/main/cpp
mv TerminalImageViewer/src/main/cpp/tiv mnt/img_root/usr/local/bin/
