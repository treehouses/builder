#!/bin/bash

exit 0

wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_arm.zip
unzip terraform_0.12.24_linux_arm.zip

mkdir -p mnt/img_root/usr/local/bin/
mv terraform mnt/img_root/usr/local/bin/.
