#!/bin/bash

source lib.sh

# List of extra GPG keys to import from the LOCAL SYSTEM!
ADD_REPO_KEYS=(
    68576280 # nodesource
    0EBFCD88 # Docker Release (CE deb)
    A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 # Tor
    6A030B21BA07F4FB # Coral
)

GPG="gpg --no-permission-warning --no-default-keyring --quiet --keyring "
KEYRING=$PWD/apt_keys.gpg
rm -f "$KEYRING"
cat keys/*.key | $GPG "$KEYRING" --import

missing_keys=()
for key in "${ADD_REPO_KEYS[@]}" ; do
    if ! $GPG "$KEYRING" --list-keys "$key" >/dev/null 2>&1 ; then
        missing_keys+=( "$key" )
    fi
done

if [[ ${#missing_keys[@]} -gt 0 ]]; then
    die "missing GPG keys! try: $GPG $KEYRING --recv-keys ${missing_keys[*]}"
fi

$GPG "$KEYRING" --export "${ADD_REPO_KEYS[@]}" | \
    $GPG mnt/img_root/etc/apt/trusted.gpg --trustdb-name mnt/img_root/etc/apt/trustdb.gpg --import - || \
    die "Could not import GPG keys ${ADD_REPO_KEYS[*]} for apt"
rm -f "$KEYRING"

