#!/bin/bash

source lib.sh

IMAGES=(
    dogi/rpi-couchdb
    portainer/portainer
    arm32v7/postgres
    treehouses/moodle:rpi-latest
)

sudo service docker stop
sudo mv /var/lib/docker /var/lib/docker.temp
sudo ln -sr `pwd -P`/mnt/img_root/var/lib/docker /var/lib/docker
sudo service docker start

for image in "${IMAGES[@]}" ; do
    sudo docker pull $image
done

_op _chroot adduser pi docker

sudo service docker stop
sudo unlink /var/lib/docker
sudo mv /var/lib/docker.temp /var/lib/docker
sudo service docker start
