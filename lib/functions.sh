#!/usr/bin/env bash

# Load configuration on current dir
function source_blogrc() {
  BLOGRC="$(pwd)/.blogrc"
  if [ -f "$BLOGRC" ]; then
    source $(pwd)/.blogrc
    return 0
  else
    return 1;
  fi
}

# Check if darwin
function is_utils_installed() {
  if [ -z "$SUPPRESS_UTILS_WARN" ] && \
    [[ "$(uname -a)" == *"Darwin"*  && ( -z "$(which gsed)" || -z "$(which gawk)" ) ]]; then
    return 0
  else
    return 1
  fi
}

ceiling_divide() {
  ceiling_result=$((($1+$2-1)/$2))
}

clean() {
  rm -f $_DIST/index.html
  rm -rf $_DIST/page/
  rm -rf $_DIST/tag/
  rm -rf /tmp/jenny*
}

function join_by { local IFS="$1"; shift; echo "$*"; }

function script_dir() {
  if [[ "$(uname -a)" == *"Darwin"* ]]; then
    echo $(dirname "$(readlink $(which $BASH_SOURCE))")
  else
    echo $(dirname -- "$(readlink -e -- $BASH_SOURCE)")
  fi
}

function is_installed() {
  # Use project dir when symlinked
  if [[ script_dir = "." ]]; then
    return 0 # Installed
  else
    return 1 # Not installed
  fi
}

function get_total_post_count() {
  list=("$@")
  echo $(printf "%s\n"  "${list[@]}" | \
    grep -E '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}(.*)' | \
    wc -l)
}

function get_total_page_count() {
  # usage fn(total post count, posts per page)
  echo $((($1+$2-1)/$2))
}

function get_full_filename() {
  echo $(basename "$1")
}

function get_extension() {
  echo $(get_full_filename "$1") | rev | cut -d. -f1 | rev
}

function get_filename() {
  echo $(get_full_filename "$1") | cut -d. -f1
}

function get_slug() {
  echo $(get_filename "$1") | rev | cut -d ' ' -f 1 | rev
}

function get_id() {
  echo $(get_full_filename "$1") | rev | cut -d ' ' -f 2 | rev
}
