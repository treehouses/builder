#!/bin/bash

ROOT=mnt/img_root
mkdir -p $ROOT/boot/examples
cp -r examples/* $ROOT/boot/examples
cp autorunonce $ROOT/boot/autorunonce
