#!/bin/bash

source lib.sh

port='5984'
version='0.13.19'

docker pull klaemo/couchdb:1.6.1
docker run -d -p $port:5984 --name bell -v "$(pwd -P)/mnt/img_root/srv/bell/data:/usr/local/var/lib/couchdb" klaemo/couchdb:1.6.1

# download BeLL-Apps
wget https://github.com/open-learning-exchange/BeLL-Apps/archive/$version.zip
unzip -qq ./*.zip
sync
ln -s BeLL-Apps-* BeLL-Apps
cd BeLL-Apps || die "ERROR: BeLL-Apps folder doesn't exist, exiting"
chmod +x node_modules/.bin/couchapp

cd app || die "ERROR: app folder doesn't exist, exiting"
python minify_html.py
mv MyApp/index.html MyApp/index1.html
mv MyApp/index2.html MyApp/index.html
mv nation/index.html nation/index1.html
mv nation/index2.html nation/index.html
cd .. || die "ERROR: .. folder doesn't exist, exiting"
sync

# install community

# check if docker is running
while ! curl -X GET http://127.0.0.1:5984/_all_dbs ; do
  sleep 1
done

## create databases & push design docs into them
for database in databases/*.js; do
  curl -X PUT "http://127.0.0.1:$port/${database:10:-3}"
  ## do in all except communities languages configurations
  case ${database:10:-3} in
    "communities" | "languages" | "configurations" ) ;;
    * ) node_modules/.bin/couchapp push "$database" "http://127.0.0.1:$port/${database:10:-3}" ;;
  esac
done

## add bare minimal required data to couchdb for launching bell-apps smoothly
for filename in init_docs/languages/*.txt; do
  curl -d "@$filename" -H "Content-Type: application/json" -X POST http://127.0.0.1:$port/languages;
done

cd .. || die "ERROR: .. folder doesn't exist, exiting"

mkdir -p mnt/img_root/srv/bell/conf
cp -r BeLL-Apps/init_docs/ConfigurationsDoc-* mnt/img_root/srv/bell/conf/.

# favicon.ico
wget https://open-learning-exchange.github.io/favicon.ico -O mnt/img_root/srv/bell/data/favicon.ico
curl -X PUT 'http://127.0.0.1:'$port'/_config/httpd_global_handlers/favicon.ico' -d '"{couch_httpd_misc_handlers, handle_favicon_req, \"/usr/local/var/lib/couchdb\"}"'

curl -X GET http://127.0.0.1:$port/configurations/_all_docs
curl -X GET http://127.0.0.1:$port/languages/_all_docs

# sync and stop docker
sync; sync; sync
docker stop bell
