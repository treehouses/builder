#!/bin/bash

source lib.sh

_op _chroot ln -sf /usr/share/zoneinfo/UTC /etc/localtime
_op _chroot rfkill unblock wifi
