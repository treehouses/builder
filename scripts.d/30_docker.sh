#!/bin/bash

source lib.sh

image=dogi/rpi-couchdb
sudo docker pull $image
mkdir -p mnt/img_root/root/dockerimages/
sudo docker save $image | gzip -c9 > mnt/img_root/root/dockerimages/rpi-couchdb.tar.gz
_op _chroot adduser pi docker
