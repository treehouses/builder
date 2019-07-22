#!/bin/bash

sleep 15

type='latest'
#type='stable'

echo timer > /sys/class/leds/led0/trigger
cd /data
rm -f new.sha1
if wget http://dev.ole.org/$type.img.gz.sha1 -O new.sha1; then
  if [[ ! -e $type.img.gz ]] || [[ ! -e $type.img.gz.sha1 ]] || [[ `cat new.sha1` != `cat $type.img.gz.sha1` ]]; then
    rm -f $type.img.gz.sha1
    wget http://dev.ole.org/$type.img.gz.sha1
    rm -f $type.img.gz
    wget http://dev.ole.org/$type.img.gz
  fi
fi

echo heartbeat > /sys/class/leds/led0/trigger
if [[ -b /dev/sdb ]] ; then
  if [[ -e $type.img.gz ]]; then
    zcat $type.img.gz > /dev/sdb
  else
    echo u > /proc/sysrq-trigger
    dd if=/dev/mmcblk0 bs=1M of=/dev/sdb count=4K
  fi
  sync
  sync
  sync
  echo none > /sys/class/leds/led0/trigger
else
  echo default-on > /sys/class/leds/led0/trigger
fi
