#!/usr/bin/env bash

set -e

PROJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${PROJ_ROOT_DIR}/scripts/common.bashrc"

CLANG_FORMAT_CMD="$(command -v clang-format)"
if [[ -z "${CLANG_FORMAT_CMD}" ]]; then
  error "Command 'clang-format' not found."
  error "Please make sure clang-format is installed and check your PATH settings."
  exit 1
fi

function clang_format_cmd() {
  ${CLANG_FORMAT_CMD} -i "$@"
}

function run_clang_format() {
  for target in "$@"; do
    if [[ -f "${target}" ]]; then
      if c_family_ext "${target}" || proto_ext "${target}"; then
        clang_format_cmd "${target}"
        info "Done formatting ${target}"
      else
        warning "Ignoring ${target} as it is not a regular c/cpp/proto file"
      fi
    elif [[ -d "${target}" ]]; then
      local srcs="$(find_proto_srcs ${target})"
      srcs+="$(find_c_cpp_srcs ${target})"
      if [[ -n "${srcs}" ]]; then
        clang_format_cmd ${srcs}
        info "Done formatting c/cpp/proto files under $target"
      else
        warning "Ignoring ${target} as it contains no regular c/cpp/proto file"
      fi
    fi
  done
}

if [[ "$#" -eq 0 ]]; then
  error "Usage: $0 <path/to/dirs/or/files>"
  exit 1
fi

run_clang_format "$@"
