#!/bin/bash

exit 0
# :P

source lib.sh

# download Planet
cd /root || exit 1
wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/planet.yml
#wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/volumes.yml
{

} > volumes.yml

wget https://raw.githubusercontent.com/open-learning-exchange/planet/master/docker/install.yml

sync; sync; sync

docker-compose -f planet.yml -f volumes.yml -f install.yml -p planet pull
docker tag treehouses/planet:db-init treehouses/planet:db-init-local
docker tag treehouses/planet:latest treehouses/planet:local

sync; sync; sync

docker-compose -f planet.yml -f volumes.yml -p planet up -d

sync; sync; sync


----------------------------
port='5984'
version='0.13.19'

docker pull klaemo/couchdb:1.6.1
docker run -d -p $port:5984 --name bell -v "$(pwd -P)/mnt/img_root/srv/bell/data:/usr/local/var/lib/couchdb" klaemo/couchdb:1.6.1


mkdir -p mnt/img_root/srv/bell/conf
cp BeLL-Apps/init_docs/ConfigurationsDoc-* mnt/img_root/srv/bell/conf/.

# favicon.ico
wget https://open-learning-exchange.github.io/favicon.ico -O mnt/img_root/srv/bell/data/favicon.ico
curl -X PUT 'http://127.0.0.1:'$port'/_config/httpd_global_handlers/favicon.ico' -d '"{couch_httpd_misc_handlers, handle_favicon_req, \"/usr/local/var/lib/couchdb\"}"'

curl -X GET http://127.0.0.1:$port/configurations/_all_docs
curl -X GET http://127.0.0.1:$port/languages/_all_docs

-------------------------------

# sync and stop docker
sync; sync; sync
docker-compose -f planet.yml -f volumes.yml -p planet stop
