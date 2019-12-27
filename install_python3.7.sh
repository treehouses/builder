#!/bin/bash

source lib.sh
# Install python 3.7.4
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
tar zxf Python-3.7.0.tgz
cd Python-3.7.0
./configure
make -j 4
make altinstall
