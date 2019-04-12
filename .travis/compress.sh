#!/bin/bash

source .travis/utils.sh

compress() {
    if [[ ! -e "$image_gz" ]] || [[ "$image_gz" -ot "$image" ]]; then
        echo "Compressing image"
        gzip -c -9 < "$image" > "$image_gz"
    fi
}

echo "Deploying as $name"
bell &
compress
checksum

if release_is_number; then
    cp -r "$image_gz" "build/latest.img.gz"
    cp -r "$image_gz.sha1" "build/latest.img.gz.sha1"
else
    cp -r "$image_gz" "build/branch.img.gz"
    cp -r "$image_gz.sha1" "build/branch.img.gz.sha1"
fi