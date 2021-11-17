#!/usr/bin/env bash

# Copy this file as .git/hooks/pre-push to let git check format before pushing to remote.

source "./scripts/common.bashrc"
FORMAT_CMD="./scripts/format.sh"

base_branch="origin/master"
if [ -z $(git branch -r -l "${base_branch}") ]; then
  base_branch=0000000000000000000000000000000000000000
fi

bad_format=()
while read -r one_change; do
  fmt_tmp="${one_change}.fmttmp"
  cp "${one_change}" "${fmt_tmp}"
  ${FORMAT_CMD} "${one_change}"
  fmt_diff="$(diff ${one_change} ${fmt_tmp})"

  if [ ! -z "${fmt_diff}" ]; then
    bad_format+=("${one_change}")
  fi
  mv -f "${fmt_tmp}" "${one_change}"
done < <(git diff --ignore-submodules --diff-filter=d --name-only ${base_branch}...HEAD)

if [ -n "${bad_format}" ]; then
  error "Please properly format the following files before pushing:"
  for src in "${bad_format}"; do
    error "  - ${src}"
  done
  exit 1
fi

exit 0
