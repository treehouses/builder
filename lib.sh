
# Constants
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
    _op _chroot apt-get -qq "$@"
}

