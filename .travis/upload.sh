#!/bin/bash

source .travis/utils.sh

echo "Uploading image to dev"
echo "echoing out $image_gz"
echo "echoing out $image_sha1"
echo "blar" > test-file

chmod 666 /dev/tty
# rsync -vP .travis/id_deploy "$image_gz" "$image_sha1" deploy@download.ole.org:/data/images/.rj/
rsync -v -P -e .travis/ssh.sh test-file deploy@download.ole.org:/data/images/.rj

if release_is_number; then
    echo "Marking release as latest image"
    # For some reason the cd has no effect if it's the first command? WTF.
    .travis/ssh.sh deploy@download.ole.org sh -c ":; cd /data/images; ln -sf $name.img.gz latest.img.gz; ln -sf $name.img.gz.sha1 latest.img.gz.sha1"
fi
