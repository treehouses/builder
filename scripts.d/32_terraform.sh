#!/bin/bash

wget https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_linux_arm.zip
unzip terraform_0.13.3_linux_arm.zip

mkdir -p mnt/img_root/usr/local/bin/
mv terraform mnt/img_root/usr/local/bin/.
