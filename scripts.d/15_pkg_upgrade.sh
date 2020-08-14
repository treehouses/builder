#!/bin/bash

source lib.sh

#_apt update || die "Could not update package sources"
#exit 0

echo "Holding nodejs Package"
_op _chroot apt-mark hold nodejs
# temporay fix to not break GUI icons and background
_op _chroot apt-mark hold libfm-data
_op _chroot apt-mark hold libfm-extra4
_op _chroot apt-mark hold libfm-gtk-data
_op _chroot apt-mark hold libfm-gtk4
_op _chroot apt-mark hold libfm-modules
_op _chroot apt-mark hold libfm4
_op _chroot apt-mark hold raspberrypi-ui-mods

_op _chroot apt-mark hold xserver-common
_op _chroot apt-mark hold xserver-xorg-core
_op _chroot apt-mark hold dbus
_op _chroot apt-mark hold dbus-user-session
_op _chroot apt-mark hold dbus-x11
_op _chroot apt-mark hold libdbus-1-3
_op _chroot apt-mark hold lxpanel
_op _chroot apt-mark hold lxpanel-data
_op _chroot apt-mark hold lxplug-bluetooth
_op _chroot apt-mark hold lxplug-network
_op _chroot apt-mark hold lxplug-ptbatt
_op _chroot apt-mark hold lxplug-volume


echo "Installing Updates"
_apt update || die "Could not update package sources"
_apt dist-upgrade || die "Could not upgrade system"

_op _chroot apt-mark unhold libfm-data
_op _chroot apt-mark unhold libfm-extra4
_op _chroot apt-mark unhold libfm-gtk-data
_op _chroot apt-mark unhold libfm-gtk4
_op _chroot apt-mark unhold libfm-modules
_op _chroot apt-mark unhold libfm4
_op _chroot apt-mark unhold raspberrypi-ui-mods

_op _chroot apt-mark unhold xserver-common
_op _chroot apt-mark unhold xserver-xorg-core
_op _chroot apt-mark unhold dbus
_op _chroot apt-mark unhold dbus-user-session
_op _chroot apt-mark unhold dbus-x11
_op _chroot apt-mark unhold libdbus-1-3
_op _chroot apt-mark unhold lxpanel
_op _chroot apt-mark unhold lxpanel-data
_op _chroot apt-mark unhold lxplug-bluetooth
_op _chroot apt-mark unhold lxplug-network
_op _chroot apt-mark unhold lxplug-ptbatt
_op _chroot apt-mark unhold lxplug-volume

exit 0

libinput-bin
libinput10
libjavascriptcoregtk-4.0-18
libjson-c3
liblirc-client0
libnss3
libopenmpt-modplug1
libopenmpt0
libpostproc55
libraspberrypi-bin
libraspberrypi-dev
libraspberrypi-doc
libraspberrypi0
libswresample3
libswscale5
libunwind8
libwebkit2gtk-4.0-37
pcmanfm
pi-bluetooth
pi-greeter
pi-package
pi-package-data
pi-package-session
piclone
pipanel
piwiz
pprompt
raspberrypi-bootloader
raspberrypi-kernel
raspberrypi-kernel-headers
raspberrypi-sys-mods
raspi-config
realvnc-vnc-server
rp-bookshelf
rp-prefapps
rpi-chromium-mods
rpi-eeprom
rpi-eeprom-images
libavcodec58
libavdevice58
libavfilter7
libavformat58
libavresample4
libavutil56
libexif12

vlc
vlc-bin
vlc-data
vlc-l10n
vlc-plugin-base
vlc-plugin-notify
vlc-plugin-qt
vlc-plugin-samba
vlc-plugin-skins2
vlc-plugin-video-output
vlc-plugin-video-splitter
vlc-plugin-visualization
libvlc-bin
libvlc5
libvlccore9
arandr
ca-certificates
python-pil
python3-pil
python3.7
python3.7-dev
python3.7-minimal
python3.7-venv
libpython3.7
libpython3.7-dev
libpython3.7-minimal
libpython3.7-stdlib
ffmpeg
firmware-atheros
firmware-brcm80211
firmware-libertas
firmware-misc-nonfree
firmware-realtek
nfs-common
glib-networking
glib-networking-common
glib-networking-services
