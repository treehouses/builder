#!/bin/bash

source lib.sh

function _getfilename {
  echo $@ | tr '/' '-'
}

function _docker {
  sudo docker pull $@
  sudo docker save $@ | gzip -c9 > mnt/img_root/root/dockerimages/$(_getfilename $@).tar.gz
}

mkdir -p mnt/img_root/root/dockerimages/
_docker dogi/rpi-couchdb
_docker portainer/portainer
_docker arm32v7/postgres
_docker treehouses/moodle:rpi-latest
_op _chroot adduser pi docker
