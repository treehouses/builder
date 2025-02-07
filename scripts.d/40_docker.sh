#!/bin/bash
source lib.sh

# IMAGES=(
#     portainer/portainer:linux-arm
#     #pihole/pihole:4.3.1-4_armhf 
#     #firehol/netdata:armv7hf
# )

#MULTIS=(
#    treehouses/couchdb:2.3.1
#    treehouses/planet:latest
#    treehouses/planet:db-init
#    treehouses/planet:chatapi
#    portainer/portainer:alpine
#)

OLD=$(pwd -P)
cd /var/lib || die "ERROR: /var/lib folder doesn't exist, exiting"

service docker stop
mv docker docker.temp
mkdir -p "$OLD/mnt/img_root/var/lib/docker"
ln -s "$OLD/mnt/img_root/var/lib/docker" docker
service docker start

# for image in "${IMAGES[@]}" ; do
#     docker pull "$image"
# done

mkdir -p ~/.docker
echo '{"experimental": "enabled"}' > ~/.docker/config.json

mkdir -p "$OLD/mnt/img_root/root/.docker"
cp ~/.docker/config.json "$OLD/mnt/img_root/root/.docker/."

#for multi in "${MULTIS[@]}" ; do
#    docker manifest inspect "$multi"
#    name=$(echo "$multi" | cut -d ":" -f 1)
#    tag=$(echo "$multi" | cut -d ":" -f 2)
#    hash=$(docker manifest inspect "$multi" | jq '.manifests' | jq -c "map(select(.platform.architecture | contains(\"arm64\")))" | jq '.[0]' | jq '.digest' | sed -e 's/^"//' -e 's/"$//')
#    docker pull "$name@$hash"
#    docker tag "$name@$hash" "$name:$tag" 
#done

docker pull treehouses/planet:latest
docker pull treehouses/planet:db-init
docker pull treehouses/planet:chatapi
docker pull couchdb:2.3.1

docker tag treehouses/planet:latest treehouses/planet:local
docker tag treehouses/planet:db-init treehouses/planet:db-init-local
docker tag treehouses/planet:chatapi treehouses/planet:chatapi-local
docker tag couchdb:2.3.1 treehouses/couchdb:2.3.1

sync; sync; sync

docker images

planetdir='tenalp'
mkdir -p "$OLD/mnt/img_root/srv/$planetdir"
cd "$OLD/mnt/img_root/srv/$planetdir"

# download Planet
wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/planet.yml
wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/install.yml
wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/volumes.yml
touch .chat.env

{
  echo "services:"
  echo "  couchdb:"
  echo "    volumes:"
  echo "      - \"$OLD/mnt/img_root/srv/$planetdir/data:/opt/couchdb/data\""
  echo "      - \"$OLD/mnt/img_root/srv/$planetdir/log:/opt/couchdb/var/log\""
  echo "  planet:"
  echo "    volumes:"
  echo "      - \"$OLD/mnt/img_root/srv/$planetdir/pwd:/usr/share/nginx/html/credentials\""
} > volumestravis.yml

sync; sync; sync

docker compose -f planet.yml -f volumestravis.yml -p planet up -d

# check if couch-db is working
while ! curl -X GET http://127.0.0.1:2200/_all_dbs ; do
  sleep 5
  docker ps -a
  docker logs planet-couchdb-1
done
echo "couch is up"

sync; sync; sync

docker ps -f name=planet_db-init* -a -q
# check if couch-db docker has finish
while [[ $(docker inspect -f '{{.State.Running}}' "$(docker ps -f name=planet_db-init* -a -q)") == "true" ]]; do
  sleep 1
done
echo "couch has finished"

tree -f "mnt/img_root/srv/$planetdir"

# sync and stop docker
sync; sync; sync
docker compose -f planet.yml -f volumestravis.yml -p planet stop

cd -

service docker stop
unlink docker
mv docker.temp docker
service docker start

cd "$OLD" || die "ERROR: $OLD folder doesn't exist, exiting"

#_op _chroot adduser pi docker
