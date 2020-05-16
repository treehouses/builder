#!/bin/bash
git clone https://github.com/cli/cli.git gh-cli
env GOOS=linux GOARCH=arm GOOARM=6 make -C gh-cli
mv gh-cli/bin/gh mnt/img_root/usr/local/bin/
rm -rf gh-cli