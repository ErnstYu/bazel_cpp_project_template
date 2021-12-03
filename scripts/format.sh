#!/usr/bin/env bash

set -e

PROJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${PROJ_ROOT_DIR}/scripts/common.bashrc"

FORMAT_BAZEL=0
FORMAT_CPP=0
FORMAT_MARKDOWN=0
FORMAT_SHELL=0
FORMAT_ALL=0

HAS_OPTION=0

function print_usage() {
  echo -e "\n${RED}Usage${NO_COLOR}:
  .${BOLD}$0${NO_COLOR} [OPTION] <path/to/src/dir/or/files>"
  echo -e "\n${RED}Options${NO_COLOR}:
  ${BLUE}-b|--bazel           ${NO_COLOR}Format Bazel code
  ${BLUE}-c|--cpp             ${NO_COLOR}Format cpp code
  ${BLUE}-s|--shell           ${NO_COLOR}Format Shell code
  ${BLUE}-m|--markdown        ${NO_COLOR}Format Markdown file
  ${BLUE}-a|--all             ${NO_COLOR}Format all
  ${BLUE}-h|--help            ${NO_COLOR}Show this message and exit"
}

function run_clang_format() {
  bash "${PROJ_ROOT_DIR}/scripts/clang_format.sh" "$@"
}

function run_buildifier() {
  bash "${PROJ_ROOT_DIR}/scripts/buildifier.sh" "$@"
}

function run_shfmt() {
  bash "${PROJ_ROOT_DIR}/scripts/shfmt.sh" "$@"
}

function run_prettier() {
  bash "${PROJ_ROOT_DIR}/scripts/mdfmt.sh" "$@"
}

function run_format() {
  for arg in "$@"; do
    if [[ -f "${arg}" ]]; then
      if c_family_ext "${arg}" || proto_ext "${arg}"; then
        run_clang_format "${arg}"
      elif prettier_ext "${arg}"; then
        run_prettier "${arg}"
      elif bazel_ext "${arg}"; then
        run_buildifier "${arg}"
      elif shell_ext "${arg}"; then
        run_shfmt "${arg}"
      fi
    elif [[ -d "${arg}" ]]; then
      if [[ "${FORMAT_BAZEL}" -eq 1 ]]; then
        run_buildifier "${arg}"
      fi
      if [[ "${FORMAT_CPP}" -eq 1 ]]; then
        run_clang_format "${arg}"
      fi
      if [[ "${FORMAT_SHELL}" -eq 1 ]]; then
        run_shfmt "${arg}"
      fi
      if [[ "${FORMAT_MARKDOWN}" -eq 1 ]]; then
        run_prettier "${arg}"
      fi
    else
      warning "Ignored ${arg} as it is not a regular file/directory"
    fi
  done
}

function main() {
  if [[ "$#" -eq 0 ]]; then
    print_usage
    exit 1
  fi

  while [[ $# -gt 0 ]]; do
    local opt="$1"
    case "${opt}" in
      -c | --cpp)
        FORMAT_CPP=1
        HAS_OPTION=1
        shift
        ;;
      -b | --bazel)
        FORMAT_BAZEL=1
        HAS_OPTION=1
        shift
        ;;
      -s | --shell)
        FORMAT_SHELL=1
        HAS_OPTION=1
        shift
        ;;
      -m | --markdown)
        FORMAT_MARKDOWN=1
        HAS_OPTION=1
        shift
        ;;
      -a | --all)
        FORMAT_ALL=1
        shift
        ;;
      -h | --help)
        print_usage
        exit 1
        ;;
      *)
        if [[ "${opt}" = -* ]]; then
          print_usage
          exit 1
        else
          if [[ "$HAS_OPTION" -eq 0 ]]; then
            FORMAT_ALL=1
          fi
          break
        fi
        ;;
    esac
  done

  if [[ "${FORMAT_ALL}" -eq 1 ]]; then
    FORMAT_BAZEL=1
    FORMAT_CPP=1
    FORMAT_MARKDOWN=1
    FORMAT_SHELL=1
  fi

  run_format "$@"
}

main "$@"
