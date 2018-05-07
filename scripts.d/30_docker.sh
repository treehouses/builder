#!/bin/bash

source lib.sh

IMAGES=(
    portainer/portainer:linux-arm
    arm32v7/postgres
    treehouses/moodle:rpi-latest
)

MULTIS=(
    treehouses/couchdb:1.7.1
    treehouses/couchdb:2.1.1
    treehouses/planet-multi:latest
    treehouses/planet-multi:db-init
)

OLD=$(pwd -P)
cd /var/lib || die "ERROR: /var/lib folder doesn't exist, exiting"

service docker stop
mv docker docker.temp
mkdir -p "$OLD/mnt/img_root/var/lib/docker"
ln -s "$OLD/mnt/img_root/var/lib/docker" docker
service docker start

for image in "${IMAGES[@]}" ; do
    docker pull "$image"
done

for multi in "${MULTIS[@]}" ; do
    docker manifest inspect "$multi" 
    # TODO
    # https://docs.docker.com/edge/engine/reference/commandline/manifest_inspect/
done

service docker stop
unlink docker
mv docker.temp docker
service docker start

cd "$OLD" || die "ERROR: $OLD folder doesn't exist, exiting"

_op _chroot adduser pi docker
