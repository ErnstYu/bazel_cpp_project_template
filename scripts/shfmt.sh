#!/usr/bin/env bash

set -e

PROJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${PROJ_ROOT_DIR}/scripts/common.bashrc"

SHELL_FORMAT_CMD="$(command -v shfmt)"
if [[ -z "${SHELL_FORMAT_CMD}" ]]; then
  error "Command 'shfmt' not found."
  error "Please make sure shfmt is installed and check your PATH settings."
  exit 1
fi

function shfmt_cmd() {
  # Use settings in .editorconfig
  ${SHELL_FORMAT_CMD} -w "$@"
}

function run_shfmt() {
  for target in "$@"; do
    if [[ -f "${target}" ]]; then
      if shell_ext "${target}"; then
        shfmt_cmd "${target}"
        info "Done formatting ${target}"
      else
        warning "Ignoring ${target} as it is not a regular shell script file"
      fi
    elif [[ -d "${target}" ]]; then
      local srcs="$(find_shell_srcs ${target})"
      if [[ -n "${srcs}" ]]; then
        shfmt_cmd ${srcs}
        info "Done formatting shell scripts under ${target}"
      else
        warning "Ignoring ${target} as it contains no regular shell script file"
      fi
    fi
  done
}

if [[ "$#" -eq 0 ]]; then
  error "Usage: $0 <path/to/dirs/or/files>"
  exit 1
fi

run_shfmt "$@"
