#!/bin/bash
image=$(ls images/*.img | head -1) # XXX
image_gz=${image}.gz
ssh=ssh -i deploy/id_deploy -o "UserKnownHostsFile deploy/known_hosts"
gzip -9 $image
rsync -P -e "$ssh" $image_gz deploy@dev.ole.org:/data/deploy
