#!/bin/bash

source lib.sh

IMAGES=(
    dogi/rpi-couchdb
    portainer/portainer
    arm32v7/postgres
    treehouses/moodle:rpi-latest
)

OLD=`pwd -P`
cd /var/lib

service docker stop
mv docker docker.temp
mkdir -p $OLD/mnt/img_root/var/lib/docker
ln -s $OLD/mnt/img_root/var/lib/docker docker
service docker start

for image in "${IMAGES[@]}" ; do
    docker pull $image
done

_op _chroot adduser pi docker

service docker stop
unlink docker
mv docker.temp docker
service docker start

cd $OLD
