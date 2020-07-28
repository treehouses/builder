#!/bin/bash

source lib.sh
echo "Installing files"
#(cd install || die "ERROR: install folder doesn't exist, exiting"; tar c .) | _op _chroot tar vx --owner=root --group=root

cat << EOF > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

if [ -f "/etc/tunnel" ];
then
  /etc/tunnel
fi

exit 0
EOF

cat << EOF > /usr/local/bin/do_autorun
#!/bin/bash

rebootrequired=0

led_mode() {
  mode="$1"
  trigger=/sys/class/leds/led0/trigger
  [ -e $trigger ] && echo "$mode" > $trigger
}

log() {
    echo "do_autorun:" "$@"
}

find_script() {
  base_name="$1"

  for ext in "" .sh .txt; do
    script="$base_name$ext"

    if [ -e "$script" ]; then
        echo "$script"
        return
    fi
  done
}

wifiunblock(){
  if [[ $(rfkill list wifi -o soft -n) == "blocked" ]]; then
    rfkill unblock wifi
    log "wifi unblocked"
  fi
}

autorunonce(){
  log "searching for autorunonce script"
  script=$(find_script "$1/autorunonce")

  if [ -z "$script" ]; then
    log "no autorunonce found"
    return 1
  fi

  newname="$(basename "$script" | sed -e 's/run/ran/')"
  newscript="$(dirname "$script")/$newname"
  log "moving autorunonce script: $script -> $newscript"
  mv -v "$script" "$newscript"
  log "converting dos newlines to unix"
  dos2unix "$newscript"
  sync
  log "running autorunonce script $script"
  led_mode timer
  bash "$newscript"
  log "autorunonce script is done"
}

autorun(){
  log "searching for autorun script"
  script=$(find_script "$1/autorun")

  if [ -z "$script" ]; then
    log "no autorun script found"
    return 1
  fi

  log "converting dos newlines to unix"
  dos2unix "$script"

  log "running autorun script $script"
  led_mode heartbeat
  sudo screen -dmS treehouses bash -c 'sudo '"$script"
  log "autorun script started in screen"
}

onenodeforall() {
  arch=$(uname -m)
  log "onenodeforall"
  if [ "$arch" == "armv6l" ]
  then
    log "$arch - rpi0/1"
    if [ "$(readlink -- /usr/bin/node)" != "node-armv6l" ]
    then
      unlink /usr/bin/node
      ln -sr /usr/bin/node-armv6l /usr/bin/node
    fi
  elif [ "$arch" == "armv7l" ]
  then
    log "$arch - rpi2/3"
    if [ "$(readlink -- /usr/bin/node)" != "node-armv7l" ]
    then
      unlink /usr/bin/node
      ln -sr /usr/bin/node-armv7l /usr/bin/node
    fi
  else
    log "$arch - something went wrong"
  fi  
}

onebalenaforall() {
  arch=$(uname -m)
  log "onebalenaforall"
  if [ "$arch" == "armv6l" ]
  then
    log "$arch - rpi0/1"
    if [ "$(readlink -- /usr/bin/balena)" != "balena-engine-armv6l" ]
    then
      unlink /usr/bin/balena-engine
      ln -sr /usr/bin/balena-engine-armv6l /usr/bin/balena-engine
    fi
  elif [ "$arch" == "armv7l" ]
  then
    log "$arch - rpi2/3"
    if [ "$(readlink -- /usr/bin/balena-engine)" != "balena-engine-armv7l" ]
    then
      unlink /usr/bin/balena-engine
      ln -sr /usr/bin/balena-engine-armv7l /usr/bin/balena-engine
    fi
  else
    log "$arch - something went wrong"
  fi
}

usbgadget() {
  case "$(treehouses detectrpi)" in
        RPIZ|RPIZW)
            if grep -q -w "^#dtoverlay=dwc2" /boot/config.txt
            then 
              sed -i -e 's/#dtoverlay=dwc2/dtoverlay=dwc2/g' /boot/config.txt
              rebootrequired=1
            fi

            if grep -q "#modules-load=dwc2,g_ether" /boot/cmdline.txt
            then
              sed -i -e 's/#modules-load=dwc2,g_ether/modules-load=dwc2,g_ether/g' /boot/cmdline.txt
              rebootrequired=1
            fi
            ;;
        *)
            if grep -q -w "^dtoverlay=dwc2" /boot/config.txt
            then 
              sed -i -e 's/dtoverlay=dwc2/#dtoverlay=dwc2/g' /boot/config.txt
              rebootrequired=1
            fi

            if grep -q " modules-load=dwc2,g_ether" /boot/cmdline.txt
            then
              sed -i -e 's/ modules-load=dwc2,g_ether/ #modules-load=dwc2,g_ether/g' /boot/cmdline.txt
              rebootrequired=1
            fi
  esac
}

start() {
  led_mode default-on
  log "starting"
  wifiunblock
  usbgadget
  onenodeforall
  onebalenaforall
  if [[ rebootrequired -eq 1 ]]
  then
    reboot
  fi
  mkdir -p /data
  if [ -b /dev/sda1 ]
  then
    log "usb stick"
    mountpoint -q /data || mount /dev/sda1 /data
    cd /data || exit 1
    autorunonce /data || autorun /data
  else
    log "no usb stick"
    cd /boot || exit 1
    autorunonce /boot || autorun /boot
  fi
}

stop() {
  log "stopping"
  sudo screen -X -S "treehouses" quit
}


# Some things that run always
touch /var/lock/autorun

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

exit 0
EOF

cat << EOF > /etc/systemd/system/autorun.service
[Unit]
Description=run autorun(once)(.sh) scripts from USB stick or in /boot
After=local_fs.target remote_fs.target network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/do_autorun start
Restart=no

[Install]
WantedBy=multi-user.target

EOF

cat << EOF > /etc/systemd/system/balena.service
[Unit]
Description=Balena Application Container Engine
Documentation=https://www.balena.io/engine/
After=network-online.target balena.socket firewalld.service
Wants=network-online.target
Requires=balena.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by balena
ExecStart=/usr/bin/balena-engine-daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/balena-engine.sock
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of balena containers
Delegate=yes
# kill only the balena process, not all processes in the cgroup
KillMode=process
# restart the balena process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /etc/systemd/system/balena.socket
[Unit]
Description=Balena Socket for the API
PartOf=balena.service

[Socket]
ListenStream=/var/run/balena.sock
SocketMode=0660
SocketUser=root
SocketGroup=balena

[Install]
WantedBy=sockets.target
EOF

cat << EOF > /etc/systemd/system/rpibluetooth.service
[Unit]
Description=Bluetooth server
After=rpibluetooth.service
Requires=rpibluetooth.service bluetooth.service

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
Restart=always
RestartSec=5s

ExecStart=/usr/bin/python3 /usr/local/bin/bluetooth-server.py &

[Install]
WantedBy=multi-user.target
EOF

ln -s /etc/systemd/system/autorun.service /etc/systemd/system/multi-user.target/autorun.service