#!/bin/sh
# shellcheck disable=SC2029
ssh -i .travis/id_deploy -o "GlobalKnownHostsFile .travis/known_hosts" "$@"
