#!/bin/bash

# Load configuration on current dir
source $PWD/.blogconfig

if [ -z "$SUPPRESS_UTILS_WARN" ] && [[ "$(uname -a)" == *"Darwin"*  && ( -z "$(which gsed)" || -z "$(which gawk)" ) ]]; then
  echo -e "macOS users need 'gsed' and 'gawk', install them via: brew install gawk gnu-sed\n"
  echo -e "If you installed them with --with-default-names, i.e. as sed and awk, then add the below to your .blogconfig file\n\n  SUPPRESS_UTILS_WARN=1\n"
  echo "Exiting."
  exit 0
fi

if [[ "$(uname -a)" == *"Darwin"* ]]; then
  SCRIPT_DIR=$(dirname "$(readlink $(which $BASH_SOURCE))")
else
  SCRIPT_DIR=$(dirname -- "$(readlink -e -- $BASH_SOURCE)")
fi

# Set LAYOUT_DIR if empty
if [ -z "$LAYOUT_DIR" ]; then
  LAYOUT_DIR=$SCRIPT_DIR/layout
fi

# Set posts_per_page if empty
if [ -z "$POSTS_PER_PAGE" ]; then
  POSTS_PER_PAGE=2
fi

sed=$(which sed)
sed=$(which awk)
# Use gsed if present
if [ "$(which gsed)" ]; then
  sed=$(which gsed)
fi
if [ "$(which gawk)" ]; then
  awk=$(which gawk)
fi

if [ "$1" ]; then
  TARGET_EXISTS=false
  echo "Only building $1"
else
  echo "Rebuilding all"
  # Clean dist folder if rebuild all
  rm -rf $DIST/post
  rm -f $DIST/index.html
fi

# Create directories for pseudo subdirs
mkdir -p $DIST/post
mkdir -p $DIST/page

# Declaring Global Variables
fullfilename=""
extension=""
filename=""
slug=""
timestamp=""
postdate=""
postdateint=""
publish_pattern="^[0-9]{4}-[0-9]{2}-[0-9]{2}(.*)"
ceiling_divide() {
  ceiling_result=$((($1+$2-1)/$2))
}

totalpostcount=$(ls | grep -E '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}(.*)' | wc -l)
#this weird sub gets roof value after division
totalpagecount=$((($totalpostcount+$POSTS_PER_PAGE-1)/$POSTS_PER_PAGE))
postcount=0
pagecount=0

indextpl=""


parse_details () {
  # Grab file details
  fullfilename=$(basename "$1")
  extension="${fullfilename##*.}"
  filename="${fullfilename%.*}"
  slug=$(echo "$filename" | rev | cut -d ' ' -f 1 | rev)
  id=$(echo "$fullfilename" | rev | cut -d ' ' -f 2 | rev)
  timestamp=$(cut -d ' ' -f -1 <<< "$filename")
  postdate=$(echo $timestamp | $sed -e 's#\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)#\2\\/\3#')
  postdatefull=$(echo $timestamp | $sed -e 's#\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)#\1\ \2\-\3#')
  postdateint=$(echo $timestamp | $sed -e 's#\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)#\1\2\3#')
}

find_permalink () {
  if [[ -e $dest ]] ; then
    echo "  Permalink taken, finding unique increment number"
    i=2
    while [[ -e $DIST/post/$slug-$i.html ]] ; do
      let i++
    done
    slug=$slug-$i
  fi
  dest="$DIST/post/$slug.html"
}

render () {
  # Run markdown interpreter
  $awk -f $SCRIPT_DIR/lib/md2html.awk "$f" > /tmp/.blogtmp

  # Grab the title, and delete the tag
  title=$(grep -E "<h1.*>(.*?)</h1>" /tmp/.blogtmp | $sed 's/<h1.*>\(.*\)<\/h1>.*/\1/')
  $sed -i 's/<h1.*>.*<\/h1>//' /tmp/.blogtmp

  # Embed the processed markup into the post template
  $sed '/__contents__/r /tmp/.blogtmp' $LAYOUT_DIR/post.html | $sed '/__contents__/d' > "$dest"

  # Embed the title, date, and permalink
  $sed -i -e "s/__title__/$title/" -e "s/__postdate__/$postdate/" -e "s/__path__/\/post\/$slug\.html/" "$dest"
}

create_index () {
  # File copy
  cp $LAYOUT_DIR/index.html $DIST/index.html

  # Copy looped markup, replaced with marker for insertion
  indextpl=$($awk '/__loop__/,/__end loop__/' $LAYOUT_DIR/index.html | $sed 's/__loop__\(.*\)__end\ loop__/\1/')
  $sed -i 's/__loop__\(.*\)__end\ loop__/__insertloop__/' $DIST/index.html
}

index_insert () {

  # Generate the index link
  echo $indextpl | $sed "s/__postdate__/$postdate/" | $sed "s/__title__/$title/" | $sed "s/__path__/\/post\/$slug\.html/" > /tmp/.blogtmp2

  # Insert the index link
  $sed -i "/__insertloop__/r /tmp/.blogtmp2" $DIST/index.html

  let postcount++

  if (( $postcount == $totalpostcount )); then
    featured_image=$($awk '/img src="/,/" alt="/' "$DIST/post/$slug.html" | $sed 's/\(.*\)img src="\(.*\)" alt="\(.*\)>/\2/')
    $sed -i "s#__featuredimage__#$featured_image#" $DIST/index.html
  fi
  page=$((($postcount+$POSTS_PER_PAGE-1)/$POSTS_PER_PAGE))
  new_page=$(( $postcount % $POSTS_PER_PAGE ))
  if (( $new_page == 0 )); then
    echo "CREATED PAGE $page"
    echo ""

    # Remove the insertion marker before we move it
    $sed -i "s/__insertloop__//" $DIST/index.html

    # Remove the "older" link on page 1
    if (( $page ==  1 )); then
      $sed -i "s/__older__.*__end\ older__//" $DIST/index.html;
    fi

    if (( $page >=  1 )); then
      $sed -i "s/__newer__//" $DIST/index.html;
      $sed -i "s/__end\ newer__//" $DIST/index.html;
      $sed -i "s/__older__//" $DIST/index.html;
      $sed -i "s/__end\ older__//" $DIST/index.html;
    fi

    $sed -i "s/__nav__//" $DIST/index.html;
    $sed -i "s/__end\ nav__//" $DIST/index.html;

    # Add the older page nav
    $sed -i "s/__olderurl__/\/page\/$(( page - 1 ))\.html/" $DIST/index.html

    # Add the newer page nav
    if(( $page+1 == $totalpagecount )); then
      $sed -i "s/__newerurl__/\//" $DIST/index.html
    else
      $sed -i "s/__newerurl__/\/page\/$(( page + 1 ))\.html/" $DIST/index.html
    fi
    # Remove the featured image
    $sed -i "s/__fimg__.*__end\ fimg__//" $DIST/index.html
    $sed -i "s/__land__.*__end\ land__//" $DIST/index.html
    # Add the page indicator
    $sed -i "s/__pageindicator__//" $DIST/index.html;
    $sed -i "s/__end\ pageindicator__//" $DIST/index.html;
    $sed -i "s/__pagenum__/$(( page ))/" $DIST/index.html;

    # Finally move the file
    mv $DIST/index.html "$DIST/page/${page}.html"

    let pagecount++

    create_index

  elif (( $page == $totalpagecount )); then
    #note this scope executed once for every index link on the latest page
    $sed -i "s/__nav__//" $DIST/index.html;
    $sed -i "s/__end\ nav__//" $DIST/index.html;
    $sed -i "s/__older__//" $DIST/index.html;
    $sed -i "s/__olderurl__/\/page\/$(( page - 1))\.html/" $DIST/index.html;
    $sed -i "s/__end\ older__//" $DIST/index.html;
    # Remove the "newer" link on the latest page
    $sed -i "s/__newer__.*__end\ newer__//" $DIST/index.html
    $sed -i "s/__fimg__//" $DIST/index.html
    $sed -i "s/__end\ fimg__//" $DIST/index.html
    # leave landing class, remove tpl tags
    $sed -i "s/__land__//" $DIST/index.html
    $sed -i "s/__end\ land__//" $DIST/index.html
    # remove page indicator on latest page
    $sed -i "s/__pageindicator__.*__end\ pageindicator__//" $DIST/index.html
  fi

}

# Copy initial index.html for in place manipulation
create_index

# Loop through articles in folder
for f in $PWD/*.md; do

  CURRENT_ISNEW=true

  # Grab file details
  parse_details "$f"

  echo "→ $fullfilename file..";

  if ! [[ $filename =~ $publish_pattern ]]; then
    echo "  Draft, skipping"
    continue
  fi

  if (( $postdateint > $(date +"%Y%m%d") ));then
    echo "  Scheduled, skipping for now"
    continue
  fi

  if [ "$1" ] && [ "$fullfilename" == "$1" ]; then
    echo "  File exists"
    TARGET_EXISTS=true
    CURRENT_ISNEW=false
    testdest="$DIST/post/$slug.html"
    if [[ -e $testdest ]] ; then
      collisions=$(find . -regextype posix-extended -regex "^.*$slug\.md" -type f -printf "%f\n")
      collisioncount=$(echo "$collisions" | wc -l)
      i=0
      while read -r line; do
        if [ "$fullfilename" == "$line" ]; then
          break
        else
          let i++
        fi
      done <<< "$collisions"
      if (( i > 0 )); then
    echo "  Permalink will collide, setting number increment"
    let i++
        slug=$slug-$i
      fi
    fi

  fi

  if [ -z "$1" ] || [ $CURRENT_ISNEW == false ]; then

    # Find available permalink
    dest="$DIST/post/$slug.html"

    # No need to look if not new ( $CURRENT_ISNEW == false )
    # $slug will already be set correctly
    if [ $CURRENT_ISNEW == true ]; then
      find_permalink
    fi

    echo "  𝍌 post/$slug.html"

    render

  else
    title=$(grep -E "^\#\ (.*?)" "$f" | $sed 's/^\#\ \(.*\)/\1/')
  fi

  index_insert

done

# Copy back last page to index, because that's cheaper to do here
if (( $totalpostcount % $POSTS_PER_PAGE == 0 )) && (( $pagecount >= 2 )); then
  mv "$DIST/page/${page}.html" $DIST/index.html
fi

# Change 2nd to latest page "newer" link to /
if [ -f "$DIST/page/$(( $pagecount - 1 )).html" ]; then
  $sed -i "s/\/page\/${page}.html/\//" "$DIST/page/$(( $pagecount - 1 )).html"
fi

# Remove nav if pagecount is 0
if (( $pagecount == 0)); then
  $sed -i "s/__nav__.*__end\ nav__//" $DIST/index.html
fi

# Remove the insertion marker
$sed -i "s/__insertloop__//" $DIST/index.html

# Process single file in argument
if [ "$1" ] && [ $TARGET_EXISTS == false ]; then

  parse_details "$f"

  echo $slug
  echo "→ $fullfilename file..";

  if ! [[ $filename =~ $publish_pattern ]]; then
    echo "  Draft, skipping."
    continue
  fi

  if (( $postdateint > $(date +"%Y%m%d") ));then
    echo "  Scheduled, skipping for now"
    continue
  fi

  # Find available permalink
  dest="$DIST/post/$slug.html"
  find_permalink

  echo "  𝍌 post/$slug.html"

  render

fi

if [ "$(type -t post_hook)" = function ]; then
  post_hook
fi
