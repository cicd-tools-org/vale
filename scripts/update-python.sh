#!/bin/bash

# Create a list of the top 200 most downloaded PyPi packages and add to the PythonProject spelling ignore entries.

# CICD-Tools Development script.

set -eo pipefail

URL="https://hugovk.github.io/top-pypi-packages/top-pypi-packages-30-days.min.json"

main() {
  curl -sl --retry 3 "${URL}" |
    jq -r '.rows[0:200] | .[].project' |
    sort \
      > cicd-tools/ignore/pypi.txt
}

main "$@"
