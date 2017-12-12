#!/bin/bash

port='5984'
version='0.13.19'

docker pull klaemo/couchdb:1.6.1
docker run -d -p $port:5984 --name bell -v `pwd -P`/bell:/usr/local/var/lib/couchdb klaemo/couchdb:1.6.1

# download BeLL-Apps
wget https://github.com/open-learning-exchange/BeLL-Apps/archive/$version.zip
unzip *.zip
sync
ln -s BeLL-Apps-* BeLL-Apps
cd BeLL-Apps
chmod +x node_modules/.bin/couchapp

cd app
python minify_html.py
mv MyApp/index.html MyApp/index1.html
mv MyApp/index2.html MyApp/index.html
mv nation/index.html nation/index1.html
mv nation/index2.html nation/index.html
cd ..
sync

# install community

# check if docker is running
while ! curl -X GET http://127.0.0.1:5984/_all_dbs ; do
  sleep 1
done

## create databases & push design docs into them
for database in databases/*.js; do
  curl -X PUT http://127.0.0.1:$port/${database:10:-3}
  ## do in all except communities languages configurations
  case ${database:10:-3} in
    "communities" | "languages" | "configurations" ) ;;
    * ) node_modules/.bin/couchapp push $database http://127.0.0.1:$port/${database:10:-3} ;;
  esac
done

## add bare minimal required data to couchdb for launching bell-apps smoothly
curl -d @init_docs/ConfigurationsDoc-Community.txt -H "Content-Type: application/json" -X POST http://127.0.0.1:$port/configurations
for filename in init_docs/languages/*.txt; do
  curl -d @$filename -H "Content-Type: application/json" -X POST http://127.0.0.1:$port/languages;
done

cd ..

# favicon.ico
wget https://open-learning-exchange.github.io/favicon.ico -O bell/favicon.ico
curl -X PUT 'http://127.0.0.1:'$port'/_config/httpd_global_handlers/favicon.ico' -d '"{couch_httpd_misc_handlers, handle_favicon_req, \"/usr/local/var/lib/couchdb\"}"'

curl -X GET http://127.0.0.1:$port/configurations

# sync and stop docker
sync; sync; sync
docker stop bell

# copy *.couch from bell to /srv/data/bell
ROOT=mnt/img_root
mkdir -p $ROOT/srv/data
cp -r bell $ROOT/srv/data/.
