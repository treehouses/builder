#!/bin/bash

source .travis/utils.sh

build_type="branch"
if release_is_number; then
    build_type="latest"
fi
export experiment="$build_type"
export img_name="$image_gz"
