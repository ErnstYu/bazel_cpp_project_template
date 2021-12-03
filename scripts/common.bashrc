#!/usr/bin/env bash

PROJ_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

export TAB="    " # 4 spaces

: ${VERBOSE:=yes}

NO_COLOR='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

function info() {
  (echo >&2 -e "[${BLUE}${BOLD}INFO${NO_COLOR}] $*")
}

function ok() {
  (echo >&2 -e "[${GREEN}${BOLD} OK ${NO_COLOR}] $*")
}

function error() {
  (echo >&2 -e "[${RED}${BOLD}ERROR${NO_COLOR}] $*")
}

function warning() {
  (echo >&2 -e "[${YELLOW}${BOLD}WARNING${NO_COLOR}] $*")
}

# Get composite extensions from behind, take the last one on default.
function file_ext() {
  local filename="$(basename $1)"
  local actual_ext="${filename##*.}"
  local all_exts
  IFS="." read -r -a all_exts <<< "$filename"
  local requested_exts="${all_exts[*]: -${2-1}}"
  echo "${requested_exts// /\.}"
}

function c_family_ext() {
  local actual_ext="$(file_ext $1)"
  for ext in "h" "hh" "hxx" "hpp" "cxx" "cc" "cpp" "cu"; do
    if [[ "${ext}" == "${actual_ext}" ]]; then
      return 0
    fi
  done
  return 1
}

function find_c_cpp_srcs() {
  find "$@" -type f \
    -name "*.h" \
    -or -name "*.c" \
    -or -name "*.hpp" \
    -or -name "*.cpp" \
    -or -name "*.hh" \
    -or -name "*.cc" \
    -or -name "*.hxx" \
    -or -name "*.cxx" \
    -or -name "*.cu"
}

function proto_ext() {
  if [[ "$(file_ext $1)" == "proto" || "$(file_ext $1 2)" == "pb.txt" ]]; then
    return 0
  else
    return 1
  fi
}

function find_proto_srcs() {
  find "$@" -type f -name "*.proto" \
    -or -name "*.pb.txt"
}

function shell_ext() {
  local actual_ext="$(file_ext $1)"
  for ext in "sh" "bash" "bashrc"; do
    if [[ "${ext}" == "${actual_ext}" ]]; then
      return 0
    fi
  done
  return 1
}

function find_shell_srcs() {
  find "$@" -type f -name "*.sh" \
    -or -name "*.bash" \
    -or -name "*.bashrc"
}

function bazel_ext() {
  local actual_ext="$(file_ext $1)"
  if [[ -z "${actual_ext}" ]]; then
    local filename="$(basename $1)"
    if [[ "$filename" == "BUILD" || "$filename" == "WORKSPACE" ]]; then
      return 0
    else
      return 1
    fi
  else
    for ext in "BUILD" "bazel" "bzl"; do
      if [[ "${ext}" == "${actual_ext}" ]]; then
        return 0
      fi
    done
    return 1
  fi
}

function find_bazel_srcs() {
  find "$@" -type f \
    -name "BUILD" \
    -or -name "WORKSPACE" \
    -or -name "*.BUILD" \
    -or -name "*.bzl" \
    -or -name "*.bazel"
}

function prettier_ext() {
  local actual_ext="$(file_ext $1)"
  for ext in "md" "json" "yml"; do
    if [[ "${ext}" == "${actual_ext}" ]]; then
      return 0
    fi
  done
  return 1
}

function find_prettier_srcs() {
  find "$@" -type f \
    -name "*.md" \
    -or -name "*.json" \
    -or -name "*.yml"
}

# Exits the script if the command fails.
function run() {
  if [[ "${VERBOSE}" = yes ]]; then
    echo "${@}"
    "${@}" || exit $?
  else
    local errfile="${ROOT_DIR}/.errors.log"
    echo "${@}" > "${errfile}"
    if ! "${@}" >> "${errfile}" 2>&1; then
      local exitcode=$?
      cat "${errfile}" 1>&2
      exit $exitcode
    fi
  fi
}

function git_sha1() {
  if [[ -x "$(which git 2> /dev/null)" ]] \
    && [ -d "${PROJ_ROOT_DIR}/.git" ]]; then
    git rev-parse --short HEAD 2> /dev/null || true
  fi
}

function git_date() {
  if [[ -x "$(which git 2> /dev/null)" ]] \
    && [ -d "${PROJ_ROOT_DIR}/.git" ]]; then
    git log -1 --pretty=%ai | cut -d " " -f 1 || true
  fi
}

function git_branch() {
  if [[ -x "$(which git 2> /dev/null)" ]] \
    && [ -d "${PROJ_ROOT_DIR}/.git" ]]; then
    git rev-parse --abbrev-ref HEAD
  else
    echo "@non-git"
  fi
}
