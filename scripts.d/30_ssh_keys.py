#!/usr/bin/env python3

# Obtain the public ssh keys of each of the public members of open-learning-exchange organization

import requests
import os

r = requests.get('https://api.github.com/orgs/treehouses/teams/support/members', auth=(os.getenv("USERNAME"), os.getenv("APIKEY")))
print(r)
users = r.json()
members = []
for user in users:
    members.append(user['login'])

print ("Found %d members. Getting keys for users" % len(members))

with open('authorized_keys', 'w') as keylog:
  for member in members:
    keys_content = requests.get('https://github.com/' + member +'.keys', auth=(os.getenv("USERNAME"), os.getenv("APIKEY")))
    keys = (keys_content.text.splitlines())
    print(keys)
    if len(keys):
      print("info: user %s has keys" % member)
    else:
      print("info: user %s has NO keys" % member)
    for key in keys:
      keylog.write("%s %s\n" % (key.strip(), member))