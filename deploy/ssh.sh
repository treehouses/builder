#!/bin/sh
ssh -i deploy/id_deploy -o "GlobalKnownHostsFile deploy/known_hosts" "\$@"
