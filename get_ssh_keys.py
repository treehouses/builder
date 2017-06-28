#!/usr/bin/python

# Obtain the public ssh keys of each of the public members of ole-vi organization

import json
import urllib2

# Retrieve a list of public members using gitHub API
api = 'https://api.github.com/orgs/ole-vi/members'
json_data = json.load(urllib2.urlopen(api))
members = []
for member in json_data:
    members.append(member['login'].encode('utf-8'))

# Write the keys to ./authorized_keys    
f = open('./authorized_keys','w')
for member in members:
    f.write(urllib2.urlopen('https://github.com/' + member + '.keys').read())
f.close()
