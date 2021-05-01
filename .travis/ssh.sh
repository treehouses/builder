#!/bin/sh
# shellcheck disable=SC2029
ssh -o "GlobalKnownHostsFile .travis/known_hosts" "$@"
