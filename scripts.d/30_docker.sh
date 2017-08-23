#!/bin/bash

source lib.sh

image=dogi/rpi-couchdb
sudo docker pull $image
sudo docker save $image | gzip -c9 > mnt/img_root/root/rpi-couchdb.tar.gz
_op _chroot systemctl enable docker-load
_op _chroot adduser pi docker
