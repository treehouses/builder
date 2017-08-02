#!/bin/bash

image=dogi/rpi-couchdb
sudo docker pull $image
sudo docker save -o mnt/img_root/root/rpi-couchdb.docker $image
