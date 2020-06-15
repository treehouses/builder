#!/bin/bash

source lib.sh

IMAGES=(
    portainer/portainer:linux-arm
    #pihole/pihole:4.3.1-4_armhf 
    #firehol/netdata:armv7hf
)

MULTIS=(
    treehouses/couchdb:2.3.1
    treehouses/planet:latest
    treehouses/planet:db-init
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

mkdir -p "$OLD/mnt/img_root/root/.docker"
cp ~/.docker/config.json "$OLD/mnt/img_root/root/.docker/."

for multi in "${MULTIS[@]}" ; do
    docker manifest inspect "$multi"
    name=$(echo "$multi" | cut -d ":" -f 1)
    tag=$(echo "$multi" | cut -d ":" -f 2)
    hash=$(docker manifest inspect "$multi" | jq '.manifests' | jq -c 'map(select(.platform.architecture | contains("arm")))' | jq '.[0]' | jq '.digest' | sed -e 's/^"//' -e 's/"$//')
    docker pull "$name@$hash"
    docker tag "$name@$hash" "$name:$tag" 
done

docker tag treehouses/planet:db-init treehouses/planet:db-init-local
docker tag treehouses/planet:latest treehouses/planet:local

sync; sync; sync

docker images

service docker stop
unlink docker
mv docker.temp docker
service docker start

cd "$OLD" || die "ERROR: $OLD folder doesn't exist, exiting"

_op _chroot adduser pi docker

# installs docker-compose using pip3
_pip3_install docker-compose --no-cache-dir
