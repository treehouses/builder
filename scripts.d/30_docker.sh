#!/bin/bash

image=dogi/rpi-couchdb
sudo docker pull $image
sudo docker save $image | gzip -c9 > mnt/img_root/root/rpi-couchdb.tar.gz
