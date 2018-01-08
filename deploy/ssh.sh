#!/bin/sh

# shellcheck disable=SC2029
ssh -i deploy/id_deploy -o "GlobalKnownHostsFile deploy/known_hosts" "$@"
