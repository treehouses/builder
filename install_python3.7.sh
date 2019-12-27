#!/bin/bash

source lib.sh

apt-get install -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev

# Install python 3.7.4
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
tar zxf Python-3.7.0.tgz
cd Python-3.7.0
./configure
make -j 4
make altinstall
