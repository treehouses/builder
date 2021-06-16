#!/bin/bash

source lib.sh

mkdir -p mnt/img_root/usr/local/bin

cat <<'EOF' > mnt/img_root/usr/local/bin/do_autorun
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

oneforall() {
  service=$1
  arch=$(uname -m)
  log "one${service}forall"
  symlink=$service
  [[ $symlink == balena ]] && symlink=${symlink}-engine
  if [ "$arch" == "armv6l" ]
  then
    log "$arch - rpi0/1"
    if [ "$(readlink -- /usr/bin/${service})" != "${symlink}-armv6l" ]
    then
      unlink /usr/bin/${symlink}
      ln -sr /usr/bin/${symlink}-armv6l /usr/bin/${symlink}
    fi
  elif [ "$arch" == "armv7l" ]
  then
    log "$arch - rpi2/3"
    if [ "$(readlink -- /usr/bin/${symlink})" != "${symlink}-armv7l" ]
    then
      unlink /usr/bin/${symlink}
      ln -sr /usr/bin/${symlink}-armv7l /usr/bin/${symlink}
    fi
  elif [ "$arch" == "armv64l" ]
  then
    log "$arch - rpi2/3"
    if [ "$(readlink -- /usr/bin/${symlink})" != "${symlink}-arm64" ]
    then
      unlink /usr/bin/${symlink}
      ln -sr /usr/bin/${symlink}-arm64 /usr/bin/${symlink}
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
  installs=(node balena)
  for install in "${!installs[@]}"; do
    oneforall "${installs{install}}"
  done
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

_op _chroot chmod +x /usr/local/bin/do_autorun