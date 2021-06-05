#!/bin/bash

git clone https://github.com/stefanhaustein/TerminalImageViewer.git
(
  cd TerminalImageViewer || exit 0
  workingver=e69c53e4cc03f370fd335b65ccdeb97d3ece294c
  currentver=$(git rev-parse HEAD)
  [[ "$workingver" != "$currentver" ]] && echo "TODO: a new version has been released, check https://github.com/stefanhaustein/TerminalImageViewer"
  git checkout $workingver
)
CXX=arm-linux-gnueabihf-g++ make -C TerminalImageViewer/src/main/cpp
mv TerminalImageViewer/src/main/cpp/tiv mnt/img_root/usr/local/bin/
