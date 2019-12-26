#!/bin/bash

source lib.sh

# System variables
ROOT=mnt/img_root
BETTERCAPSERVICE=$ROOT/etc/systemd/system/bettercap.service
BETTERCAPLAUNCHER=$ROOT/usr/bin/bettercap-launcher
PWNGRIDSERVICE=$ROOT/etc/systemd/system/pwngrid-peer.service
PWNAGOTCHICONFIG=$ROOT/boot/config.yml
CONFIG=$ROOT/boot/config.txt
CMDLINE=$ROOT/boot/cmdline.txt

# Install bettercap
wget "https://github.com/bettercap/bettercap/releases/download/v2.26.1/bettercap_linux_armhf_v2.26.1.zip"
unzip bettercap_linux_armhf_v2.26.1.zip
mv bettercap $ROOT/usr/bin/
bettercap -eval "caplets.update; ui.update; quit"

# Create bettercap service
cat <<EOFA > $BETTERCAPSERVICE
[Unit]
Description=bettercap api.rest service.
Documentation=https://bettercap.org
Wants=network.target
After=pwngrid.service

[Service]
Type=simple
PermissionsStartOnly=true
ExecStart=/usr/bin/bettercap-launcher
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOFA

# Create bettercap launcher
cat <<EOFB > $BETTERCAPLAUNCHER
#!/usr/bin/env bash
/usr/bin/monstart
if [[ $(ifconfig | grep usb0 | grep RUNNING) ]] || [[ $(cat /sys/class/net/eth0/carrier) ]]; then
  # if override file exists, go into auto mode
  if [ -f /root/.pwnagotchi-auto ]; then
    /usr/bin/bettercap -no-colors -caplet pwnagotchi-auto -iface mon0
  else
    /usr/bin/bettercap -no-colors -caplet pwnagotchi-manual -iface mon0
  fi
else
  /usr/bin/bettercap -no-colors -caplet pwnagotchi-auto -iface mon0
fi
EOFB

# Install pwngrid
wget "https://github.com/evilsocket/pwngrid/releases/download/v1.10.3/pwngrid_linux_armhf_v1.10.3.zip"
unzip pwngrid_linux_armhf_v1.10.3.zip
mv pwngrid $ROOT/usr/bin/
pwngrid -generate -keys $ROOT/etc/pwnagotchi

# Create pwngrid launcher
cat <<EOFC > /etc/systemd/system/pwngrid-peer.service
[Unit]
Description=pwngrid peer service.
Documentation=https://pwnagotchi.ai
Wants=network.target

[Service]
Type=simple
PermissionsStartOnly=true
ExecStart=/usr/bin/pwngrid -keys /etc/pwnagotchi -address 127.0.0.1:8666 -client-token /root/.api-enrollment.json -wait -log /var/log/pwngrid-peer.log -iface mon0
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOFC

# Install pwnagotchi
wget "https://github.com/evilsocket/pwnagotchi/archive/v1.4.3.zip"
unzip v1.4.3.zip
cd pwnagotchi-1.4.3
pip3 install .

# Create configuration file for pwnagotchi
cat <<EOFD > $PWNAGOTCHICONFIG
main:
  name: hostname
  whitelist:
    - HomeNetwork
  plugins:
    grid:
      enabled: true
      report: true
      exclude:
        - HomeNetwork

ui:
  display:
    type: display
    color: color
EOFD
