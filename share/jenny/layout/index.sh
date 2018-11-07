#!/bin/bash

# Break apart the LIST payload
IFS='✂︎' read -r -a array <<< "$LIST"

function index_loop {
	for (( idx=${#array[@]}-1 ; idx>=0 ; idx-- )) ; do
    [ "${array[idx]}" ] && eval "${array[idx]} list_item"
  done
}

function list_item {
  if [ -z "$BREAK" ]; then
cat << _LOOP_
  <li class="post-link"><a href="$(echo $POST_URL)"><span class="stamp">$(echo $POST_DATE)</span> <span class="title">$(echo $POST_TITLE)</span></a></li>
_LOOP_
  else
cat << _LOOP_
  <li class="post-link"><a href="/page/$(echo $BREAK).html">In page $(echo $BREAK)</a></li>
_LOOP_
  fi
}

function nav {
	if [ "$PAGE_OLD" ] || [ "$PAGE_NEW" ]; then
cat << _NAV_
    <nav>
			$([ "$PAGE_NEW" ] && echo "<a href=\"$PAGE_NEW\">← NEWER</a>")
			$([ "$PAGE_OLD" ] && echo "<a href=\"$PAGE_OLD\">OLDER →</a>")
		</nav>
_NAV_
	fi
}

cat << _EOF_
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>${BLOG_TITLE}</title>
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,700,400italic,700italic' rel='stylesheet' type='text/css'>
    <link href="data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAANjY2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARERERAAAAAAAAAAAAAAAAEQEBEQAAAAAAAAAAAAAAABEREREAAAAAAAAAAAAAAAARAREBAAAAAAAAAAAAAAAAEREBEQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//wAA//8AAP//AADwDwAA//8AAPKPAAD//wAA8A8AAP//AADyLwAA//8AAPCPAAD//wAA//8AAP//AAD//wAA" rel="icon" type="image/x-icon">
    <style>
      html { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
      body {
        background-color: white;
        color: #444;
        font-size: 16px;
        padding: 1em;
        font-family: 'Roboto', monospace;
        line-height: 1.5em;
      }
      a { color: inherit; }
      .posts { list-style: none; padding: 0; margin: 1em 0; line-height: 1.6em; }
      .post-link { display: table; text-transform: uppercase; margin-bottom: .55em; }
      .post-link a { text-decoration: none; }
      .post-link .title:hover {  text-decoration: underline;  }
      .post-link .stamp { color: #999; display: table-cell; width: 2.25em; text-align:right; padding-right: 1.5em; }
      .post-link .title { color: #333; display: table-cell; vertical-align: top;font-weight: bold; }
      nav a { color: #555; text-decoration: none; } nav a:hover { color: #268bd2}
      nav a+a:before { content: ' • '; }
      header { text-transform: uppercase; }
      header a { text-decoration: none }
    </style>
  </head>
  <body>
    $(if [ "$TAGNAME" ]; then echo "<header><a href=\"/tag/$TAGNAME\">TAG: $TAGNAME</a></header>"; fi)
    <ul class="posts">
			$(index_loop)
    </ul>
		$(nav)
  </body>
</html>
_EOF_
