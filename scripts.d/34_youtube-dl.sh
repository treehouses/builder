#!/bin/bash
exit 0 
curl -L https://yt-dl.org/downloads/latest/youtube-dl -k -o mnt/img_root/usr/local/bin/youtube-dl #without certificate
chmod a+rx mnt/img_root/usr/local/bin/youtube-dl
