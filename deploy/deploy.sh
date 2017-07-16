#!/bin/bash
image=$(ls images/*.img | head -1) # XXX
image_gz=${image}.gz
gzip -9 $image
rsync -P -e 'ssh -i deploy/id_deploy' $image_gz deploy@dev.ole.org:/data/deploy
