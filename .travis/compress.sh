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
    ln "$image_gz" "build/latest.img.gz"
    ln "$image_gz.sha1" "build/latest.img.gz.sha1"
else
    ln "$image_gz" "build/branch.img.gz"
    ln "$image_gz.sha1" "build/branch.img.gz.sha1"
fi
