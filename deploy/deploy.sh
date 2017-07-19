#!/bin/bash
image=$(ls images/*.img | head -1) # XXX
test -n "$image" || exit 1
image_gz=${image}.gz
ssh='ssh -i deploy/id_deploy -o "GlobalKnownHostsFile deploy/known_hosts"'
set -x
chmod 600 deploy/id_deploy
if [ \( ! -e $image_gz \) -o \( $image_gz -ot $image \) ]; then
     gzip --keep -9 $image
fi
rsync -P -e "$ssh" $image_gz deploy@dev.ole.org:/data/deploy
