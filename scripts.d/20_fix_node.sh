#!/bin/bash

source lib.sh

echo "Fix node"
# armv6l
wget https://nodejs.org/dist/v8.5.0/node-v8.5.0-linux-armv6l.tar.gz
tar xvzf node-v8.5.0-linux-armv6l.tar.gz node-v8.5.0-linux-armv6l/bin/node
mv node-v8.5.0-linux-armv6l/bin/node node-v8.5.0-linux-armv6l/bin/node-armv6l
(cd node-v8.5.0-linux-armv6l/bin; tar c .) | _op _chroot tar vx --owner=root --group=root

# armv7l
_op _chroot mv /usr/bin/node /usr/bin/node-armv7l
_op _chroot (cd /usr/bin; ln -s node-armv7l node)
