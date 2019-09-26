#!/bin/bash

source .travis/utils.sh

build_type="branch"
image_dir="experiment/"
if release_is_number; then
    build_type="latest"
    image_dir=""
fi
export experiment="$build_type"
export image_path="$image_dir$name.img.gz"
