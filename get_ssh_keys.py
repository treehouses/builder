#!/usr/bin/python

# Obtain the public ssh keys of each of the public members of ole-vi organization

import json
import urllib2

# Retrieve a list of public members using gitHub API
api = 'https://api.github.com/orgs/open-learning-exchange/members'
json_data = json.load(urllib2.urlopen(api))
members = []
for member in json_data:
    members.append(member['login'].encode('utf-8'))

# Write the keys to ./authorized_keys    
f = open('./authorized_keys','w')
for member in members:
    for line in urllib2.urlopen('https://github.com/' + member + '.keys').readlines():
        f.write("%s %s\n" % (line.strip(), member))
f.close()
