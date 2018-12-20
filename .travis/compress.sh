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