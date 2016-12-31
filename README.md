# Jenny

_Jenny_ is a static blog generator. Its aim is to work with basic Linux tools, but provide some modern conveniences.

- [x] Markdown support, care of [Markdown.awk](https://bitbucket.org/yiyus/md2html.awk)
- [x] Basic pagination with fixed page numbers
- [x] Heredocs-based template syntax
- [x] Draft/ignore support (by leaving out the date)
- [x] Forward-posting, i.e. ignores posts with dates in the future
- [x] Footnotes support
- [x] Tags support
- [ ] RSS/Atom feed
- [ ] Next/Previous post navigation
- [ ] Modifiable installation prefix
- [ ] Define run-time options in command arguments
- [ ] Optional Perl MultiMarkdown support during install-time


### Usage

Install Jenny to your local bin folder.

```
make install
```

Prepare the directory for your articles and build folder.

```
mkdir -p ~/blog/.dist
```

Create a file with a date so that Jenny recognizes it as a published post.

```
cat <<EOT >> first-post.md
# Hello World

Jenny is a static blog generator using bash, sed, and awk.
EOT
```

Create a .blogrc file to tell Jenny where the build folder is.

```
echo "DIST=~/blog/.dist" >> ~/blog/.blogrc
```

Finally, run `(cd ~/blog; jenny)`

### Customization

1. Copy the layout folder and modify the contents to your liking, make sure to retain existing template tags -- remember linebreaks matter

   ```
   cp -R ./layout ~/blog/.layout
   ```

2. Let Jenny know where to find your own layout files

   ```
   echo "LAYOUT_DIR=~/blog/.layout" >> ~/blog/.blogrc
   ```

### Other Settings

- To configure posts per page: `echo "LAYOUT_DIR=$PWD/.layout" >> ~/blog/.blogrc`
- To run a script after the build process, write a `post_hook` function in .blogrc
- To uninstall: `make uninstall` in the project folder
- To use tags add: 'tags: tagname' where tagname is filename friendly

### Handy Shortcuts

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
- Layout inspired by n-o-d-e.net 
- Some colors from Solarized by Ethan Schoonover
- Makefile inspired by [moebiuseye/skf](https://github.com/moebiuseye/skf)

### License

MIT License

Copyright (c) 2017 Conrado Patricio Ambrosio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
