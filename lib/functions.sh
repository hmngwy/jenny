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
    print $(dirname "$(readlink $(which $BASH_SOURCE))")
  else
    print $(dirname -- "$(readlink -e -- $BASH_SOURCE)")
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