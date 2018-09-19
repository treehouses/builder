#!/bin/bash

source lib.sh

planetdir='tenalp'

# download Planet
cd /root || exit 1

wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/planet.yml
wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/install.yml
#wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/volumes.yml
{
echo "services:"
echo "  couchdb:"
echo "    volumes:"
echo "      - \"$(pwd -P)/mnt/img_root/srv/$planetdir/data:/opt/couchdb/data\""
echo "      - \"$(pwd -P)/mnt/img_root/srv/$planetdir/log:/opt/couchdb/var/log\""
echo "  planet:"
echo "    volumes:"
echo "      - \"$(pwd -P)/mnt/img_root/srv/$planetdir/pwd:/usr/share/nginx/html/credentials\""
echo "version: \"2\""
} > volumes.yml

sync; sync; sync

docker-compose -f planet.yml -f volumes.yml -f install.yml -p planet pull
docker tag treehouses/planet:db-init treehouses/planet:db-init-local
docker tag treehouses/planet:latest treehouses/planet:local

sync; sync; sync

docker-compose -f planet.yml -f volumes.yml -p planet up -d

# sync and stop docker
sync; sync; sync
docker-compose -f planet.yml -f volumes.yml -p planet stop
