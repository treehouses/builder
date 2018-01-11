#!/bin/bash

echo "Getting open-learning-exchange ssh keys"
members=()
next_page="https://api.github.com/orgs/open-learning-exchange/members?per_page=20&page=1"
while [[ -n $next_page ]]; do
    if [[ -n $next_page ]];
    then
        echo "Gettings key from: $next_page"
    fi
    api_url=$next_page
    # shellcheck disable=SC2207
    members+=($(curl -s "$api_url"| jq '.[].url' | sed -rn "s/(.*)\\/users\\/(.*)\"/https:\\/\\/github.com\\/\\2.keys/p"))
    next_page=$(curl -sI "$api_url" | sed -rn "s/Link: <(.*?)>; rel=\"next\",.*/\\1/p")
done

for page in "${members[@]}"
do
    for member in $page
    do
        user_keys=$(curl -s "$member")
        user_name=$(echo "$member" | sed -rn "s/https:\\/\\/github\\.com\\/(.*?)\\.keys/\\1/p")
        if [ -n "$user_keys" ]
        then
            keys="$keys\\n$user_keys"
            echo "info: user $user_name has keys"
        else
            echo "info: user $user_name has NO keys"
        fi
    done
done

echo -e "$keys" > authorized_keys

ROOT=mnt/img_root

_install() {
    owner="$1"
    home="$2"
    install -o "$owner" -g "$owner" -m 700 -d "$home/.ssh"
    install -o "$owner" -g "$owner" -m 600 authorized_keys "$home/.ssh"
}

echo "installing SSH keys for root"
_install root $ROOT/root
echo "installing SSH keys for pi"
_install 1000 $ROOT/home/pi