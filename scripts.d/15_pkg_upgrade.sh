#!/bin/bash

source lib.sh

echo "Holding nodejs Package"
_op _chroot apt-mark hold nodejs
_op _chroot apt-mark hold arandr
_op _chroot apt-mark hold bind9-host
_op _chroot apt-mark hold bzip2
_op _chroot apt-mark hold chromium-browser
_op _chroot apt-mark hold chromium-browser-l10n
_op _chroot apt-mark hold chromium-codecs-ffmpeg-extra
_op _chroot apt-mark hold cron
_op _chroot apt-mark hold dmsetup
_op _chroot apt-mark hold libbind9-161
_op _chroot apt-mark hold libbz2-1.0
_op _chroot apt-mark hold libdevmapper1.02.1
_op _chroot apt-mark hold libdns-export1104
_op _chroot apt-mark hold libdns1104
_op _chroot apt-mark hold libexpat1
_op _chroot apt-mark hold libexpat1-dev
_op _chroot apt-mark hold libfm-data
_op _chroot apt-mark hold libfm-extra4
_op _chroot apt-mark hold libfm-gtk-data
_op _chroot apt-mark hold libfm-gtk4
_op _chroot apt-mark hold libfm-modules
_op _chroot apt-mark hold libfm4
_op _chroot apt-mark hold libgssapi-krb5-2
_op _chroot apt-mark hold libisc-export1100
_op _chroot apt-mark hold libisc1100
_op _chroot apt-mark hold libisccc161
_op _chroot apt-mark hold libisccfg163
_op _chroot apt-mark hold libk5crypto3
_op _chroot apt-mark hold libkrb5-3
_op _chroot apt-mark hold libkrb5support0
_op _chroot apt-mark hold liblwres161
_op _chroot apt-mark hold libpaper-utils
_op _chroot apt-mark hold libpaper1
_op _chroot apt-mark hold libsmbclient
_op _chroot apt-mark hold libwbclient0
_op _chroot apt-mark hold libzmq5
_op _chroot apt-mark hold nano
_op _chroot apt-mark hold omxplayer
_op _chroot apt-mark hold raspberrypi-bootloader
_op _chroot apt-mark hold raspberrypi-kernel
_op _chroot apt-mark hold raspi-gpio
_op _chroot apt-mark hold rpi-chromium-mods
_op _chroot apt-mark hold samba-libs

echo "Installing Updates"
_apt update || die "Could not update package sources"
_apt dist-upgrade || die "Could not upgrade system"

_op _chroot apt-mark unhold arandr
_op _chroot apt-mark unhold bind9-host
_op _chroot apt-mark unhold bzip2
_op _chroot apt-mark unhold chromium-browser
_op _chroot apt-mark unhold chromium-browser-l10n
_op _chroot apt-mark unhold chromium-codecs-ffmpeg-extra
_op _chroot apt-mark unhold cron
_op _chroot apt-mark unhold dmsetup
_op _chroot apt-mark unhold libbind9-161
_op _chroot apt-mark unhold libbz2-1.0
_op _chroot apt-mark unhold libdevmapper1.02.1
_op _chroot apt-mark unhold libdns-export1104
_op _chroot apt-mark unhold libdns1104
_op _chroot apt-mark unhold libexpat1
_op _chroot apt-mark unhold libexpat1-dev
_op _chroot apt-mark unhold libfm-data
_op _chroot apt-mark unhold libfm-extra4
_op _chroot apt-mark unhold libfm-gtk-data
_op _chroot apt-mark unhold libfm-gtk4
_op _chroot apt-mark unhold libfm-modules
_op _chroot apt-mark unhold libfm4
_op _chroot apt-mark unhold libgssapi-krb5-2
_op _chroot apt-mark unhold libisc-export1100
_op _chroot apt-mark unhold libisc1100
_op _chroot apt-mark unhold libisccc161
_op _chroot apt-mark unhold libisccfg163
_op _chroot apt-mark unhold libk5crypto3
_op _chroot apt-mark unhold libkrb5-3
_op _chroot apt-mark unhold libkrb5support0
_op _chroot apt-mark unhold liblwres161
_op _chroot apt-mark unhold libpaper-utils
_op _chroot apt-mark unhold libpaper1
_op _chroot apt-mark unhold libsmbclient
_op _chroot apt-mark unhold libwbclient0
_op _chroot apt-mark unhold libzmq5
_op _chroot apt-mark unhold nano
_op _chroot apt-mark unhold omxplayer
_op _chroot apt-mark unhold raspberrypi-bootloader
_op _chroot apt-mark unhold raspberrypi-kernel
_op _chroot apt-mark unhold raspi-gpio
_op _chroot apt-mark unhold rpi-chromium-mods
_op _chroot apt-mark unhold samba-libs

