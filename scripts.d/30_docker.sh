#!/bin/bash

source lib.sh

IMAGES=(
    dogi/rpi-couchdb
    portainer/portainer
    arm32v7/postgres
    treehouses/moodle:rpi-latest
)

for image in "${IMAGES[@]}" ; do
    sudo docker pull $image
done

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
