#!/bin/bash

ls -al mnt/img_root/usr/local/bin/
curl -L https://yt-dl.org/downloads/latest/youtube-dl -k -o mnt/img_root/usr/local/bin/youtube-dl 
ls -al mnt/img_root/usr/local/bin/youtube-dl
chmod a+rx mnt/img_root/usr/local/bin/youtube-dl
