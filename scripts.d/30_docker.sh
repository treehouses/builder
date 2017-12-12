#!/bin/bash

source lib.sh

function _getfilename {
  echo $@ | tr '/' '-'
}

function _docker {
  sudo docker pull $@
}

_docker dogi/rpi-couchdb
_docker portainer/portainer
_docker arm32v7/postgres
_docker treehouses/moodle:rpi-latest
_op _chroot adduser pi docker

sudo rm -rf mnt/var/lib/docker

was_docker_started=0
if [ "`systemctl is-active docker`" == "active" ]
then
  was_docker_started=1
  sudo systemctl stop docker
fi

sudo rsync -Pax /var/lib/docker mnt/var/lib/

if [ "$was_docker_started" == 1 ]
then
  sudo systemctl start docker
fi
