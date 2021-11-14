#!/usr/bin/env bash

set -e

PROJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${PROJ_ROOT_DIR}/scripts/common.bashrc"

NPM_DOCS="https://docs.npmjs.com/downloading-and-installing-node-js-and-npm"

if [[ ! -x "$(command -v npm)" ]]; then
  error "Please install npm first. Refer to ${NPM_DOCS} for help."
  exit 1
fi
if ! npm list -g | grep -q prettier; then
  error "Package 'prettier' not found. Please install it manually by running:"
  error "    sudo npm install -g --save-dev --save-exact prettier"
  exit 1
fi

function prettier_cmd() {
  npx prettier --loglevel=silent --write "$@"
}

function run_prettier() {
  for target in "$@"; do
    if [[ -f "${target}" ]]; then
      if prettier_ext "${target}"; then
        prettier_cmd "${target}"
        info "Done formatting ${target}"
      else
        warning "Ignoring ${target} as it is not a regular markdown/json/yaml file"
      fi
    elif [[ -d "${target}" ]]; then
      local srcs="$(find_prettier_srcs ${target})"
      if [[ -n "${srcs}" ]]; then
        prettier_cmd ${srcs}
        info "Done formatting markdown/json/yaml files under ${target}."
      else
        warning "Ignoring ${target} as it contains no regular markdown/json/yaml file"
      fi
    fi
  done
}

if [[ "$#" -eq 0 ]]; then
  error "Usage: $0 <path/to/markdown/dir/or/file>"
  exit 1
fi

run_prettier "$@"
