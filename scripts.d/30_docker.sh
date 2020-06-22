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

#service docker stop
#mv docker docker.temp
#mkdir -p "$OLD/mnt/img_root/var/lib/docker"
#ln -s "$OLD/mnt/img_root/var/lib/docker" docker
#service docker start

#for image in "${IMAGES[@]}" ; do
#    docker pull "$image"
#done

mkdir -p ~/.docker
echo '{"experimental": "enabled"}' > ~/.docker/config.json

mkdir -p "$OLD/mnt/img_root/root/.docker"
cp ~/.docker/config.json "$OLD/mnt/img_root/root/.docker/."

#for multi in "${MULTIS[@]}" ; do
#    docker manifest inspect "$multi"
#    name=$(echo "$multi" | cut -d ":" -f 1)
#    tag=$(echo "$multi" | cut -d ":" -f 2)
#    hash=$(docker manifest inspect "$multi" | jq '.manifests' | jq -c 'map(select(.platform.architecture | contains("arm")))' | jq '.[0]' | jq '.digest' | sed -e 's/^"//' -e 's/"$//')
#    docker pull "$name@$hash"
#    docker tag "$name@$hash" "$name:$tag" 
#done

#docker tag treehouses/planet:db-init treehouses/planet:db-init-local
#docker tag treehouses/planet:latest treehouses/planet:local

sync; sync; sync

#docker images

#service docker stop
#unlink docker
#mv docker.temp docker
#service docker start

cd "$OLD" || die "ERROR: $OLD folder doesn't exist, exiting"

_op _chroot adduser pi docker

# docker-compose

# solution 1

# installs docker-compose using pip3
# bell() {
#     while true; do
#         sleep 60
#         echo -e "\\a"
#     done
# }

# bell &
# _pip3_install docker-compose --no-cache-dir

# solution 2

#curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o mnt/img_root/usr/local/bin/docker-compose
#chmod +x mnt/img_root/usr/local/bin/docker-compose
#TODO pre load the docker-compose docker image

# solution 3

echo
echo "#0"
_op _chroot cat /etc/apt/sources.list
_op _chroot sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
_op _chroot sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
echo "deb http://ports.ubuntu.com/ubuntu-ports focal main universe" >> mnt/img_root/etc/apt/sources.list
#echo "deb http://deb.debian.org/debian bullseye main contrib non-free" >> mnt/img_root/etc/apt/sources.list

echo
echo "#1"
_op _chroot cat /etc/apt/sources.list
_apt update || die "Could not update package sources"
_op _chroot apt show docker-compose
_op _chroot apt-get install -y --no-install-recommends docker-compose
sed -i '$ d' mnt/img_root/etc/apt/sources.list
_apt update || die "Could not update package sources"
echo "version"
_op _chroot docker-compose --version

echo
echo "#2"
_op _chroot cat /etc/apt/sources.list

# solution 4

# wget and dpkg -i
#Get:1 http://ports.ubuntu.com/ubuntu-ports focal/main arm64 libseccomp2 arm64 2.4.3-1ubuntu1 [39.9 kB]
#Get:2 http://ports.ubuntu.com/ubuntu-ports focal/main arm64 apparmor arm64 2.13.3-7ubuntu5 [455 kB]
#Get:3 http://ports.ubuntu.com/ubuntu-ports focal/universe arm64 python3-docker all 4.1.0-1 [83.8 kB]
#Get:4 http://ports.ubuntu.com/ubuntu-ports focal/universe arm64 docker-compose all 1.25.0-1 [92.7 kB]
