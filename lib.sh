#!/bin/bash
# Constants
# shellcheck disable=SC2034
NL="$(echo)"

function die {
    echo 1>&2 ERROR: "$*"
    exit 1
}

function _op {
    "$@" &> >(sed -e 's/^/| /')
}

function _chroot {
    chroot mnt/img_root "$@"
}

function _apt {
    _op _chroot apt-get -o Acquire::ForceIPv4=true -qq "$@"
}

function _pip3 {
    _op _chroot pip3 install "$@"
}

