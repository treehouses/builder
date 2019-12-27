#!/bin/bash

source lib.sh

# System variables
ROOT=mnt/img_root
PWNAGOTCHICONFIG=$ROOT/boot/config.yml

# Install bettercap
wget "https://github.com/bettercap/bettercap/releases/download/v2.26.1/bettercap_linux_armhf_v2.26.1.zip"
unzip bettercap_linux_armhf_v2.26.1.zip
mv bettercap $ROOT/usr/bin/
bettercap -eval "caplets.update; ui.update; quit"

# Install pwngrid
wget "https://github.com/evilsocket/pwngrid/releases/download/v1.10.3/pwngrid_linux_armhf_v1.10.3.zip"
unzip pwngrid_linux_armhf_v1.10.3.zip
mv pwngrid $ROOT/usr/bin/
pwngrid -generate -keys $ROOT/etc/pwnagotchi

# Install python 3.7.4
#wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
#tar zxf Python-3.7.0.tgz
#cd Python-3.7.0
#./configure
#make -j 4
#make altinstall

# Install pwnagotchi
wget "https://github.com/evilsocket/pwnagotchi/archive/v1.4.3.zip"
unzip v1.4.3.zip
cd pwnagotchi-1.4.3
pip-3.7 install .

# Create configuration file for pwnagotchi
cat <<EOF > $PWNAGOTCHICONFIG
main:
  name: "hostname"
  whitelist:
    - HomeNetwork
  plugins:
    grid:
      enabled: gridenabled
      report: gridreport
      exclude:
        - HomeNetwork

ui:
  display:
    enabled: displayenabled
    type: "displaytype"
    color: "colortype"
EOF
