#!/usr/bin/env bash

set -e

PROJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${PROJ_ROOT_DIR}/scripts/common.bashrc"

BUILDIFIER_CMD="$(command -v buildifier)"
if [[ -z "${BUILDIFIER_CMD}" ]]; then
  error "Command 'buildifier' not found."
  error "Please make sure buildifier is installed and check your PATH settings."
  exit 1
fi

function buildifier_cmd() {
  ${BUILDIFIER_CMD} -lint=fix "$@"
}

function run_buildifier() {
  for target in "$@"; do
    if [[ -f "${target}" ]]; then
      if bazel_ext "${target}"; then
        buildifier_cmd "${target}"
        info "Done formatting ${target}"
      else
        warning "Ignoring ${target} as it is not a regular bazel file"
      fi
    elif [[ -d "${target}" ]]; then
      local srcs="$(find_bazel_srcs ${target})"
      if [[ -n "${srcs}" ]]; then
        buildifier_cmd ${srcs}
        info "Done formatting bazel files under ${target}"
      else
        warning "Ignoring ${target} as it contains no regular bazel file"
      fi
    fi
  done
}

if [[ "$#" -eq 0 ]]; then
  error "Usage: $0 <path/to/dirs/or/files>"
  exit 1
fi

run_buildifier "$@"
