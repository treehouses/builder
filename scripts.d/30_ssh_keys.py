#!/usr/bin/env python3

# Obtain the public ssh keys of each of the public members of open-learning-exchange organization

import requests
import os

headers = {
    "Authorization": "token %s" % os.environ.get("GITHUB_KEY"),
    "Connection": "close"
}

# Retrieve a list of public members using gitHub API
members = []

api = 'https://api.github.com/teams/3087744/members'

request = requests.get(api)
users = request.json()
for user in users:
    members.append(user['login'])

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
        f.write("%s %s\n" % (key.strip(), member))
f.close()
