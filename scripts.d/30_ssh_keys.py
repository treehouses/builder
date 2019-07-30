#!/usr/bin/env python2

# Obtain the public ssh keys of each of the public members of open-learning-exchange organization

import requests
import os

headers = {"Authorization": "token %s" % os.environ.get("GITHUB_KEY")}

# Retrieve a list of public members using gitHub API
next_page = 1
members = []

while next_page:
#    api = 'https://api.github.com/orgs/treehouses/teams/sshkeys/members?&per_page=50&page=%d' % next_page
    api = 'https://api.github.com/orgs/treehouses/members?&per_page=50&page=%d' % next_page
    print "Getting keys.. page %d" % next_page

    request = requests.get(api, headers=headers)
    users = request.json()
    for user in users:
        members.append(user['login'])

    if 'rel="next"' in request.headers.get("Link"):
        next_page += 1
    else:
        next_page = 0


print "Found %d members. Getting keys for users" % len(members)

f = open("authorized_keys", "w")
for member in members:
    keys_content = requests.get('https://github.com/' + member + '.keys', headers=headers).content
    keys = keys_content.splitlines()
    if len(keys):
        print "info: user %s has keys" % member
    else:
        print "info: user %s has NO keys" % member

    for key in keys:
        f.write("%s %s\n" % (key.strip(), member))
f.close()
