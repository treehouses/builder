#!/bin/bash

source lib.sh

echo "Holding nodejs Package"
_op _chroot apt-mark hold nodejs

chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra
libfm-data libfm-extra4 libfm-gtk-data libfm-gtk4 libfm-modules libfm4

# temporay fix to not break GUI icons and background
_op _chroot apt-mark hold libfm-data
_op _chroot apt-mark hold libfm-extra4
_op _chroot apt-mark hold libfm-gtk-data
_op _chroot apt-mark hold libfm-gtk4
_op _chroot apt-mark hold libfm-modules
_op _chroot apt-mark hold libfm4

echo "Installing Updates"
_apt update || die "Could not update package sources"
_apt dist-upgrade || die "Could not upgrade system"

_op _chroot apt-mark unhold libfm-data
_op _chroot apt-mark unhold libfm-extra4
_op _chroot apt-mark unhold libfm-gtk-data
_op _chroot apt-mark unhold libfm-gtk4
_op _chroot apt-mark unhold libfm-modules
_op _chroot apt-mark unhold libfm4
