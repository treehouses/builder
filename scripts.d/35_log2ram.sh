#!/bin/bash

tar xf log2ram.tar.gz
rm log2ram.tar.gz
cd log2ram-master || exit
chmod +x install.sh && ./install.sh
cd ..
rm -r log2ram-master
