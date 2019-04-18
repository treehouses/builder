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


build_type="branch"
if release_is_number; then
    build_type="latest"
fi

if [[ -f "build/$build_type.img.gz" ]]; then
    rm -rf "build/$build_type.img.gz"
fi
rsync -Pav "$image_gz" "build/$build_type.img.gz"

if [[ -f "build/$build_type.img.gz.sha1" ]]; then
    rm -rf "build/$build_type.img.gz.sha1"
fi
rsync -Pav "$image_gz.sha1" "build/$build_type.img.gz.sha1"
