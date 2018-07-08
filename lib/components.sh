#!/usr/bin/env bash

# Creates individual post pages
render () {
  local file=$1
  local destination=$2
  local title=$3
  local slug=$4
  local tags=$5
  # Copy source file to a temp file
  cp "$file" $SOURCE_TEMP_FILE

  # Delete the tagline from the temp file
  $SED -i '/^tags\: .*/d' $SOURCE_TEMP_FILE

  # Run markdown interpreter
  eval "$MARKDOWN_COMMAND $SOURCE_TEMP_FILE > $RENDER_TEMP_FILE"

  # Delete the tag
  $SED -i 's/<h1.*>.*<\/h1>//' $RENDER_TEMP_FILE

  # Push variables to template file
  POST_TITLE=$title \
    POST_URL="/post/$slug.html" \
    POST_DATE=$(get_post_date "$file") \
    POST_CONTENTS=$(cat $RENDER_TEMP_FILE) \
    TAGS=$tags \
    $LAYOUT_DIR/post.sh > $destination
}


# Inserts each article into an index or pagination page
index_insert () {
  local file=$1
  local slug=$2
  local title=$3
  local post_date=$(get_post_date "$file")
  local post_date_rfc822=$(get_post_date_rfc822 "$file")

  # If working on a tag index page, adjust pagination links
  if [ $_TAGNAME ]; then
    root="/tag/$_TAGNAME"
  else
    root=""
  fi

  # Create the export line for the index.sh template
  IndexList+=("POST_URL=\"/post/$slug.html\" POST_TITLE=\"$(echo $title | sed 's#\"#\\\"#')\" POST_DATE=\"$post_date\" POST_DATE_RFC822=\"$post_date_rfc822\" TAGNAME=\"$_TAGNAME\"")

  # Count the posts so we can limit them per page
  let PostCount++

  page=$((($PostCount+$POSTS_PER_PAGE-1)/$POSTS_PER_PAGE))
  isNewPage=$(( $PostCount % $POSTS_PER_PAGE ))

  # Create page when we have enough for a page
  # Or when we don't have any more
  if (( $isNewPage == 0 )) || (( $PostCount == $TotalPostCount )); then
    echo "$T CREATED PAGE $page"
    echo ""

    # Add the older page nav
    [[ $(( page - 1 )) > 0 ]] && PAGE_OLD="$root/page/$(( page - 1 )).html" || PAGE_OLD=""

    # Add the newer page nav
    if (( $page+1 == $TotalPageCount )); then
      PAGE_NEW="$root/"
    else
      PAGE_NEW="$root/page/$(( page + 1 )).html"
    fi

    let PageCount++

    # This is where we should generate the heredocs template for index
    if (( $page == $TotalPageCount )); then
      # This is the generation for the main index, i.e. /
      IndexList=$(join_by '✂︎' "${IndexList[@]}")
      if (( ${#IndexList[@]} < $POSTS_PER_PAGE )) && (( $TotalPageCount > 1 )); then
        # If main index page is not full, fill from next page
        IFS='✂︎' read -r -a append <<< "$LastList"
        IndexList="BREAK=$(($TotalPageCount - 1))✂︎$IndexList"
        for (( idx=$POSTS_PER_PAGE ; idx>${#IndexList[@]} ; idx-- )) ; do
          IndexList="${append[idx]}✂︎$IndexList"
        done
      fi
      LIST="$IndexList" \
        PAGE_OLD=$PAGE_OLD \
        TAGNAME=$_TAGNAME \
        $LAYOUT_DIR/index.sh > "$_DIST/index.html"

      echo "$T Generating feed.xml"

      LIST="$IndexList" \
        PAGE_OLD=$PAGE_OLD \
        TAGNAME=$_TAGNAME \
        BLOG_HOST=$BLOG_HOST \
        BLOG_TITLE=$BLOG_TITLE \
        $LAYOUT_DIR/rss2.sh > "$_DIST/feed.xml"
    else
      # This is the generation for paged indexes, i.e. page/*
      IndexList=$(join_by '✂︎' "${IndexList[@]}")
      LastList=$IndexList
      mkdir -p $_DIST/page
      LIST="$IndexList" \
        PAGE_NUM=$page \
        PAGE_OLD=$PAGE_OLD \
        PAGE_NEW=$PAGE_NEW \
        TAGNAME=$_TAGNAME \
        $LAYOUT_DIR/index.sh > "$_DIST/page/${page}.html"
    fi

    # Reset array for a new page
    unset IndexList

  fi

}
