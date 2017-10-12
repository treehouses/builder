#!/bin/bash

source lib.sh

image=dogi/rpi-couchdb
sudo docker pull $image
mkdir -p mnt/img_root/root/dockerimages/
sudo docker save $image | gzip -c9 > mnt/img_root/root/dockerimages/rpi-couchdb.tar.gz

image2=portainer/portainer
sudo docker pull $image2
mkdir -p mnt/img_root/root/dockerimages/
sudo docker save $image2 | gzip -c9 > mnt/img_root/root/dockerimages/portainer.tar.gz

_op _chroot adduser pi docker
