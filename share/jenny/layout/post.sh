#!/bin/bash

cat << _EOF_
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
      <title>$(echo $POST_TITLE) - Jenny</title>
      <link href='https://fonts.googleapis.com/css?family=Roboto:400,700,400italic,700italic' rel='stylesheet' type='text/css'>
      <link href='https://fonts.googleapis.com/css?family=Fira+Mono' rel='stylesheet' type='text/css'>
      <link href="data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAANjY2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARERERAAAAAAAAAAAAAAAAEQEBEQAAAAAAAAAAAAAAABEREREAAAAAAAAAAAAAAAARAREBAAAAAAAAAAAAAAAAEREBEQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//wAA//8AAP//AADwDwAA//8AAPKPAAD//wAA8A8AAP//AADyLwAA//8AAPCPAAD//wAA//8AAP//AAD//wAA" rel="icon" type="image/x-icon">
      <style>
        html { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
        body {
          background-color: white;
          color: #444;
          font-size: 14px;
          padding: 1em;
          font-family: 'Roboto', sans-serif;
          line-height: 1.5em;
        }
        @media (min-width: 736px) { body { font-size: 16px } }
        article { padding: 0; margin: 1em 0; max-width: 70ch; }
        article a { color: #b58900; }
        article img { max-width: 100% }
        article blockquote { border-left: 2px solid #CCC; }
        article blockquote,
        article pre { background-color: #f4f4f4; margin: 0; padding: 1em; border-radius: 3px; border-bottom: 1px solid #DDD; }
        article pre,
        article code { font-family: 'Fira Mono'; font-size: 14px; display: inline-block; color: #333; }
        article pre { word-break: break-all; white-space: pre-wrap; }
        article code::first-line { line-height: 0 }
        article blockquote :first-of-type { margin-top: 0; }
        article blockquote :last-of-type { margin-bottom: 0; }
        article hr { border: 0; border-bottom: 3px solid #CCC; }
        .heading { text-transform: uppercase; line-height: 1.6em; }
        .heading a { text-decoration: none; }
        .heading .title { color: #222; display: inline-block; margin: 0 0 1em; font-weight:bold  }
        .heading .title:hover { text-decoration: underline; }
        .heading .stamp { color: #999; }
        .heading .stamp,
        .home { display: inline-block; width: 2.66em; text-align:right; margin-right: 1.5em; }
        .home { text-decoration: none; margin-bottom: 1.5em; text-align: left;  color: #cb4b16; } .home:hover { color: #dc322f; }
        .contents { display: inline-block; max-width: 60ch; vertical-align: top; width: 100%; }
        .contents :first-child { margin-top: 0; }
        h1, h2, h3, h4, h5, h6 { font-size: 1em; font-weight: normal; text-transform: uppercase; margin: 2em 0 1em; }
        ol, ul { padding-left: 1em; }
        ul.fn-list { list-style: none; padding: 2em 0 0; margin-top: 2.5em; font-size: .9em; }
        .fn-handle, .fn-text { display: table-cell; }
        .fn-handle { padding-right: 1ch; }
        .fnref { line-height: 0 }
        .tags { margin-top: 2.5em; padding-top: 1.5em; font-size: .9em; border-top: 2px solid #EEE; }
      </style>
    </head>
    <body>
      <article>
      <div class="heading"><a href="$(echo $POST_URL)"><span class="stamp">$(echo $POST_DATE)</span><h1 class="title">$(echo $POST_TITLE)</h1></a></div>
        <a href="/" class="home">←</a><div class="contents">
        $(echo "$POST_CONTENTS")
        <div class="tags">$(for i in $TAGS; do echo "<a href=\"/tag/$i\">$i</a>"; done;)</div>
        </div>
      </article>
    </body>
  </html>
_EOF_
