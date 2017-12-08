#!/bin/bash

source lib.sh

function _getfilename {
  echo $@ | tr '/' '-'
}

function _docker {
  sudo docker pull $@
  sudo docker save $@ | gzip -c9 > mnt/img_root/root/images/$(_getfilename $@).tar.gz
}

mkdir -p mnt/img_root/root/images/
_docker dogi/rpi-couchdb
_docker portainer/portainer
_op _chroot adduser pi docker
