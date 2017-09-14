
#!/bin/bash

source lib.sh

_op _chroot  which npm
_op _chroot  echo `which npm`
_op _chroot  npm -v
_op _chroot  echo `npm -v`
