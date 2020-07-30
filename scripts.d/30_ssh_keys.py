#!/usr/bin/env python3
exit 0 
# Obtain the public ssh keys of each of the public members of open-learning-exchange organization

import requests
import os

headers = {
    "Authorization": "token %s" % os.environ.get("GITHUB_KEY"),
    "Connection": "close"
}

# Retrieve a list of public members using gitHub API

def get_members(members,page):
    api = 'https://api.github.com/teams/3087744/members?per_page=100&page=' + str(page)

    request = requests.get(api, headers=headers)
    users = request.json()
    for user in users:
        members.append(user['login'])
    count = len(users)

    if(count > 0):
        return get_members(members,page + 1)
    else:
        return members

members = get_members([],1)
print ("Found %d members. Getting keys for users" % len(members))

f = open("authorized_keys", "w")
for member in members:
    keys_content = requests.get('https://github.com/' + member + '.keys', headers=headers).content
    keys = keys_content.splitlines()
    if len(keys):
        print ("info: user %s has keys" % member)
    else:
        print ("info: user %s has NO keys" % member)

    for key in keys:
        f.write("%s %s\n" % (key.strip().decode("utf-8"), member))
f.close()
