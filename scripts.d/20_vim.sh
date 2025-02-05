#!/bin/bash

source lib.sh

_op _chroot which update-alternatives
_op _chroot /usr/bin/update-alternatives --display editor
_op _chroot ls -l /usr/bin/vim.basic


_op _chroot update-alternatives --set editor /usr/bin/vim.basic

_op _chroot /usr/bin/update-alternatives --display editor
