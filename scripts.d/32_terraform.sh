#!/bin/bash

wget https://releases.hashicorp.com/terraform/0.12.7/terraform_0.12.7_linux_arm.zip
unzip terraform_0.12.7_linux_arm.zip

mkdir -p mnt/img_root/usr/local/bin/
mv terraform mnt/img_root/usr/local/bin/.

tree -f mnt/img_root/usr/local/bin/
