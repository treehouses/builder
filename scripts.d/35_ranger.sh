#!/bin/bash

wget https://ranger.github.io/ranger-stable.tar.gz
mkdir ranger && tar xf ranger-stable.tar.gz -C ranger --strip-components 1
cd ranger
make install
ranger --copy-config=all 
cd ../ && rm -rf ranger; rm ranger-stable.tar.gz
