#!/bin/bash

source .travis/utils.sh

echo "Uploading image to dev"
rsync -P -e .travis/ssh.sh "$image_gz" "$image_sha1" deploy@download.ole.org:/data/images

if release_is_number; then
    echo "Marking release as latest image"
    # For some reason the cd has no effect if it's the first command? WTF.
    .travis/ssh.sh deploy@download.ole.org sh -c ":; cd /data/images; ln -sf $name.img.gz latest.img.gz; ln -sf $name.img.gz.sha1 latest.img.gz.sha1"
fi
