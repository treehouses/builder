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

mkdir -p ~/.docker
echo '{"experimental": "enabled"}' > ~/.docker/config.json

for multi in "${MULTIS[@]}" ; do
    name=$(echo $multi | cut -d ":" -f 1)
    tag=$(echo $multi | cut -d ":" -f 2)
    hash=$(echo `docker manifest inspect $multi | jq '.manifests' | jq -c 'map(select(.platform.architecture | contains("arm")))' | jq '.[0]' | jq '.digest'` | sed -e 's/^"//' -e 's/"$//')
    docker pull $name@$hash
    docker tag $name@$hash $name:$tag 
done

sync; sync; sync

service docker stop
unlink docker
mv docker.temp docker
service docker start

cd "$OLD" || die "ERROR: $OLD folder doesn't exist, exiting"

_op _chroot adduser pi docker
