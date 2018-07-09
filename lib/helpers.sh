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
  local list=("$@")
	local non_draft=($(printf "%s\n" "${list[@]}" | grep -E '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}(.*)'))
	local count=0
  for f1 in "${non_draft[@]}"; do
		if ! is_scheduled "$f1"; then
			let count++
		fi
	done
	echo $count
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
  local slug=$(echo $(get_filename "$1") | rev | cut -d ' ' -f 1 | rev)
  if [ -f $_DIST/post/$slug.html ]; then
    local i=2
    while [[ -e $_DIST/post/$slug-$i.html ]] ; do
      let i++
    done
    echo "$slug-$i"
  else
    echo $slug
  fi
}

function get_id() {
  echo $(get_full_filename "$1") | rev | cut -d ' ' -f 2 | rev
}

function get_timestamp() {
  echo $(get_filename "$1") | cut -d ' ' -f -1
}

function get_post_date() {
  echo $(get_timestamp "$1") | $SED -e 's#\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)#\2/\3#'
}

function get_post_date_full() {
  echo $(get_timestamp "$1") | $SED -e 's#\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)#\1\ \2\-\3#'
}

function get_post_date_int() {
  echo $(get_timestamp "$1") | $SED -e 's#\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)#\1\2\3#'
}

function get_post_date_rfc822() {
  $DATE --rfc-822 --date="$(echo $(get_timestamp "$1") | $SED -e 's#\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)#\1/\2/\3#')"
}

function get_tags() {
  local tag_line=$(cat "$1" | grep -m 1 "^[Tt]ags: ")
  echo $tag_line | $SED -e 's/[Tt]ags\: \(.*\)/\1/'
}

function is_draft() {
	# if filename doesn't match publish pattern
	local publish_pattern="^[0-9]{4}-[0-9]{2}-[0-9]{2}(.*)"
	if ! [[ $(get_filename "$1") =~ $PUBLISH_PATTERN ]]; then
		return 0 # is draft
	else
		return 1
	fi
}

function is_scheduled() {
	# if the date is in the future, then it's scheduled
	if (( $(get_post_date_int "$1") > $(date +"%Y%m%d") )); then
		return 0 # is scheduled
	else
		return 1
	fi
}

function get_last_modified_timestamp() {
	date -r "$1" +%s
}

function is_new() {
	grep $1 $BLOG_LOCK > /dev/null
	if [ ! $? -eq 0 ]; then
		return 0 # is new
	else
		return 1
	fi
}

function is_changed() {
	grep "$1" $BLOG_LOCK > /dev/null
	if [ $? -eq 0 ]; then
		return 1
	else
		return 0
	fi
}

function get_title() {
  echo $(grep -E "^\#\ (.*?)" "$1" | \
    $SED 's/^\#\ \(.*\)/\1/' | \
    $SED -r 's/\\(.)/\1/g' )
}
