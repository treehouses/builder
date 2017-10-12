#!/bin/bash

source lib.sh

function _getfilename {
  echo $@ | tr '/' '-'
}

function _docker {
  sudo docker pull $@
  mkdir -p mnt/img_root/root/dockerimages/
  sudo docker save $@ | gzip -c9 > mnt/img_root/root/dockerimages/$(_getfilename $@).tar.gz
}

#image=dogi/rpi-couchdb
#sudo docker pull $image
#mkdir -p mnt/img_root/root/dockerimages/
#sudo docker save $image | gzip -c9 > mnt/img_root/root/dockerimages/rpi-couchdb.tar.gz
_docker dogi/rpi-couchdb
_docker portainer/portainer
_op _chroot adduser pi docker
