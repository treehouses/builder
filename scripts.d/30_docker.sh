#!/bin/bash

source lib.sh

IMAGES=(
    dogi/rpi-couchdb
    portainer/portainer
    arm32v7/postgres
    treehouses/moodle:rpi-latest
    treehouses/rpi-couchdb:2.0.0
)

for image in "${IMAGES[@]}" ; do
    sudo docker pull $image
done

sudo docker rmi treehouses/rpi-couchdb:2.0.0

_op _chroot adduser pi docker

sudo rm -rf mnt/img_root/var/lib/docker
sudo service docker stop
sync; sync; sync
sudo du -s -x /var/lib/docker/overlay2/*
sudo rsync -aqxP /var/lib/docker mnt/img_root/var/lib/
sudo du -s -x mnt/img_root/var/lib/docker/overlay2/*
sudo service docker start
