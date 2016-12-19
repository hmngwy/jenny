# Jenny

_Jenny_ is a static blog generator. Its aim is to work with basic Linux tools, but provide some modern conveniences.

- Markdown support, care of [Markdown.awk](https://bitbucket.org/yiyus/md2html.awk)
- Basic Older and Newer pagination
- An ugly template syntax
- Draft/ignore support (by leaving out the date)
- Forward-posting, i.e. ignores posts with dates in the future

### Usage

Link the build script in your `$HOME/bin` folder.

```
ln -s ~/jenny/build.sh $HOME/bin/jenny
```

Create a directory for your markdown files, create a file, add a date so that Jenny recognizes it as published.

```
mkdir blog && cd blog
echo "# Hello World" >> 2016-06-06\ first-post.md
```

In the same folder, create a blog config file to tell Jenny where to create the blog. Careful, this file is sourced by Jenny.

```
echo "DIST=/var/www/html" >> .blogconfig
```

Finally, run `jenny`

### Customization

1. Copy the layout folder, modify, make sure to retain existing template tags, remember linebreaks matter
2. Add a line to your .blogconfig `LAYOUT_DIR=/home/user/blog/.layout`, change the path

### Some Shortcuts

Add these to your aliases:

```bash
# Publish file with current date
publish () {
  mv $1 "$(date +%Y-%m-%d) $1"
}
# Edit file without typing date/full filename
edit () {
  editor $(ls | grep $1)
}
```

### Credits
Layout inspired by n-o-d-e.net 
Color theme is Solarized by Ethan Schoonover
