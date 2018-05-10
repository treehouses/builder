#!/bin/bash

echo "Getting open-learning-exchange ssh keys"
members=()
page_number=1
while [[ $page_number -gt 0 ]]; do
    api_url="https://api.github.com/orgs/open-learning-exchange/members?per_page=20&page=$page_number"
    echo "Gettings key from: $api_url"

    # shellcheck disable=SC2207
    members+=($(curl -s "$api_url"| jq '.[].url' | sed -rn "s/(.*)\\/users\\/(.*)\"/https:\\/\\/github.com\\/\\2.keys/p"))
    if curl -sI "$api_url" | grep -q "next"
    then 
        page_number=$((page_number+1))
    else
        page_number=0
    fi
done

for page in "${members[@]}"
do
    for member in $page
    do
        user_keys=$(curl -s "$member")
        user_name=$(echo "$member" | sed -rn "s/https:\\/\\/github\\.com\\/(.*?)\\.keys/\\1/p")
        if [ -n "$user_keys" ]
        then
            while read -r key
            do
                key="$key $user_name"
                if [[ -n "$keys" ]]
                then
                    keys="$keys\\n$key"
                else
                    keys="$key"
                fi
            done <<< "$user_keys"
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
