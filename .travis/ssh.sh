#!/bin/sh
# shellcheck disable=SC2029
ssh -o "GlobalKnownHostsFile .travis/known_hosts" "$@"
# ssh -i .travis/id_deploy -o "GlobalKnownHostsFile .travis/known_hosts" "$@"
