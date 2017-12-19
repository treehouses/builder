#!/bin/bash

source lib.sh

OLD=`pwd -P`
cd /var/lib

IMAGES=(
    dogi/rpi-couchdb
    portainer/portainer
    arm32v7/postgres
    treehouses/moodle:rpi-latest
)

sudo service docker stop
sudo mv docker docker.temp
sudo rm -rf $OLD/mnt/img_root/var/lib/docker
sudo mkdir -p $OLD/mnt/img_root/var/lib/docker
sudo ln -s $OLD/mnt/img_root/var/lib/docker docker
sudo service docker start

for image in "${IMAGES[@]}" ; do
    sudo docker pull $image
done

_op _chroot adduser pi docker

sudo service docker stop
sudo unlink docker
sudo mv docker.temp docker
sudo service docker start

cd $OLD
