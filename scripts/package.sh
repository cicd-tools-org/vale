#!/bin/bash

# Create a zip bundle of the current style contents with a specified version.

# CICD-Tools Development script.

set -eo pipefail

VALE_BUNDLE_WORKING_PATH="${VALE_BUNDLE_WORKING_PATH-"build"}"
VALE_BUNDLE_PATH="${VALE_BUNDLE_PATH-"bundles"}"

# shellcheck source=./.cicd-tools/boxes/bootstrap/libraries/logging.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/../.cicd-tools/boxes/bootstrap/libraries/logging.sh"

main() {
  local VALE_BUNDLE_VERSION

  _package_args "$@"
  _package_zip

}

_package_args() {
  while getopts "b:d" OPTION; do
    case "$OPTION" in
      b)
        VALE_BUNDLE_VERSION="${OPTARG}"
        ;;
      \?)
        _package_usage
        ;;
      :)
        _package_usage
        ;;
      *)
        _package_usage
        ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -z "${VALE_BUNDLE_VERSION}" ]]; then
    _package_usage
  fi
}

_package_zip() {
  log "DEBUG" "PACKAGE > Wiping '${VALE_BUNDLE_WORKING_PATH}' ..."
  rm -rf "${VALE_BUNDLE_WORKING_PATH}"
  log "DEBUG" "PACKAGE > Cleaned '${VALE_BUNDLE_WORKING_PATH}'."
  log "DEBUG" "PACKAGE > Packaging version ${VALE_BUNDLE_VERSION} ..."
  log "DEBUG" "PACKAGE > Checking content formatting ..."
  log "DEBUG" "PACKAGE > Packaging ..."
  mkdir -p "${VALE_BUNDLE_WORKING_PATH}"
  mkdir -p "${VALE_BUNDLE_PATH}/${VALE_BUNDLE_VERSION}"
  pushd "${VALE_BUNDLE_WORKING_PATH}" >> /dev/null
  cp -rp ../cicd-tools .
  zip -Xr "../${VALE_BUNDLE_PATH}/${VALE_BUNDLE_VERSION}/cicd-tools".zip cicd-tools
  log "DEBUG" "PACKAGE > Bundle has been generated."
  popd >> /dev/null
  log "DEBUG" "PACKAGE > Wiping '${VALE_BUNDLE_WORKING_PATH}' ..."
  rm -rf "${VALE_BUNDLE_WORKING_PATH}"
  log "DEBUG" "PACKAGE > Cleaned '${VALE_BUNDLE_WORKING_PATH}'."
}

_package_usage() {
  log "ERROR" "package.sh -- create a zip bundle containing the vale style."
  log "ERROR" "USAGE: package.sh -b [BUNDLE VERSION]"
  exit 127
}

main "$@"
