#!/usr/bin/env bash

function sub_init() {
  if [ -f .blogrc ]; then
    echo "$T Found a .blogrc file, halting"
    exit 1
  fi
  echo "$T Initializing directory as blog."
  echo
  read -p "  URL: " -i "http://localhost:8000" -e init_hostname
  read -p "  Blog title: " -i "My Blog" -e init_title
  read -p "  Posts per page: " -i 8 -e init_posts_per_page
  read -p "  Build directory: " -i ".dist" -e init_build_dir
  read -p "  File directories: " -i "images files" -e init_static_dirs
cat << EOF > .blogrc
#!/usr/bin/env bash

BLOG_HOST="${init_hostname}"
BLOG_TITLE="${init_title}"
POSTS_PER_PAGE=$init_posts_per_page

# This is your build directory
DIST=$init_build_dir

# These directories are copied into your build directory
STATIC_DIRS="${init_static_dirs}"

# Use custom template files, see instructions at https://github.com/hmngwy/jenny#customization
#LAYOUT_DIR=

# Use a custom Markdown command
#MARKDOWN_COMMAND=

# Commands to run after succesful build
#function post_hook() {
#  echo "Done."
#}
EOF
  echo
  echo "$T .blogrc created."
  mkdir $init_static_dirs 2> /dev/null
  echo "$T File directories created."
cat <<EOT >> "$(date +%Y-%m-%d) hello-world.md"
# Hello World

Jenny is a static blog generator using bash, sed, and awk.
EOT
  echo "$T Sample post created, you can run jenny now."
  exit 0
}

function sub_publish() {
  echo "$T Published $(date +%Y-%m-%d) $2"
  mv $2 "$(date +%Y-%m-%d) $2"
  exit 0
}

function sub_edit () {
  editor $(ls | grep $2)
  exit 0
}
