#!/bin/bash

die() {
    echo "$1" >&2
    exit 1
}

get_branch() {
    git branch | grep '^[*]' | cut -c 3-
}

get_release() {
    # Does this commit have an associated release tag?
    git describe --tags --exact-match --match 'release-*' 2>/dev/null |
        sed -e 's/^release-//'
}

get_revs() {
    # How many commits on this branch?
    git rev-list --count HEAD ^master
}

make_name() {
    release=$(get_release)

    if [ -n "$release" ]; then
        echo $prefix$release
    else
        echo $prefix-$(get_branch)-$(get_revs)
    fi
} 

prefix=treehouse
image=$(ls images/*.img | head -1) # XXX
test -n "$image" || die "image not found"
name=$(make_name)
echo "Deploying as $name"
image_gz=$name.img.gz
ssh='ssh -i deploy/id_deploy -o "GlobalKnownHostsFile deploy/known_hosts"'
set -e
chmod 600 deploy/id_deploy
if [ \( ! -e $image_gz \) -o \( $image_gz -ot $image \) ]; then
    echo "Compressing image"
    gzip -c -9 < $image > $image_gz
fi
echo "Uploading image"
rsync -P -e "$ssh" $image_gz deploy@dev.ole.org:/data/deploy
