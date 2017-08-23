#!/bin/bash

die() {
    echo "$1" >&2
    exit 1
}

get_release() {
    # Does this commit have an associated release tag?
    git describe --tags --exact-match --match 'release-*' 2>/dev/null |
        sed -e 's/^release-//'
}

release_is_number() {
    echo "$(get_release)" | grep -Eqx "[0-9]+"
}

make_name() {
    release=$(get_release)

    if [ -z "$release" ]; then
        die "No release tag found; quitting"
    fi

    name=$prefix-$release
} 

compress() {
    if [ \( ! -e $image_gz \) -o \( $image_gz -ot $image \) ]; then
        echo "Compressing image"
        gzip -c -9 < $image > $image_gz
    fi
}

checksum() {
    echo "computing SHA1"
    sha1sum $image_gz > $image_sha1
}

upload() {
    echo "Uploading image"
    rsync -P -e deploy/ssh.sh $image_gz $image_sha1 deploy@dev.ole.org:/data/images

    if release_is_number; then
        echo "Marking release as latest image"
        deploy/ssh.sh deploy@dev.ole.org ln -sf /data/images/$image_gz /data/images/latest.img.gz
    fi
}

prefix=treehouse
image=$(ls images/*.img | head -1) # XXX
test -n "$image" || die "image not found"
make_name
echo "Deploying as $name"
image_gz=$name.img.gz
image_sha1=$image_gz.sha1
set -e
chmod 600 deploy/id_deploy
compress
checksum
upload
