#!/bin/bash

_op _chroot systemctl stop shadowsocks-libev
_op _chroot systemctl disable shadowsocks-libev
