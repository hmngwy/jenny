# Jenny

_Jenny_ is a static blog generator. Its aim is to work with basic Linux tools, but provide some modern conveniences.

- [x] Lightweight default theme
- [x] Markdown with Footnotes support, care of a modified [md2html.awk](https://bitbucket.org/yiyus/md2html.awk)
- [x] Basic pagination with fixed page numbers
- [x] Plug your own Markdown parser
- [x] Heredocs-based template syntax
- [x] Draft/ignore support (by leaving out the date)
- [x] Forward-posting, i.e. ignores posts with dates in the future
- [x] Tags support
- [x] Modifiable installation prefix
- [x] Define run-time options in command arguments
- [x] RSS/Atom feed
- [ ] Tests


### Usage

Install Jenny to your local bin folder.

```
make install
```

Prepare the directory for your blog posts.

```
mkdir -p ~/blog && cd ~/blog
```

Use the subcommand below to semi-automatically initialize your blog folder with a `.blogrc` file and a sample first post.

```
jenny init
```

Or you can proceed below to manually initialize your blog folder.

#### Manual Initialization

_You can skip this step if you ran `jenny init`._

Create a configuration file.

```
cat <<EOT >> .blogrc
BLOG_HOST="example.com"
BLOG_TITLE="My Blog"
EOT
```

Create a file with a date so that Jenny recognizes it as a published post.

```
cat <<EOT >> "$(date +%Y-%m-%d) hello-world.md"
# Hello World

Jenny is a static blog generator using bash, sed, and awk.
EOT
```

#### Generate

Run `jenny` on your blog directory.

### Customization

From the project folder, copy the layout folder contents and modify to your liking, mind the template tags.

```cp -R ./share/jenny/layout ~/blog/.layout```

Let Jenny know where to find your customized layout files.

```
cat <<EOT >> .blogrc
LAYOUT_DIR=~/blog/.layout
EOT
```

### Other Settings

To install into a custom location do:

```make install PREFIX=~/.local```

To soft install or symlink into your bin folder:

```make sym-install [PREFIX=~/your/path]```

To uninstall, in the project folder run:

```make uninstall```

To configure posts per page:

```
cat <<EOT >> .blogrc
POSTS_PER_PAGE=10
EOT
```

To use your own markdown parser, set `MARKDOWN_COMMAND`:

```
cat <<EOT >> .blogrc
MARKDOWN_COMMAND=multimarkdown
EOT
```

To run a script after the build process, write a `post_hook` function in .blogrc:

```
cat << EOF >> .blogrc
function post_hook() {
  echo "Done!"
}
EOF
```

To set a different build folder, set `DIST`:

```
cat << EOF >> .blogrc
DIST=~/blog/.dist
EOF
```

To use tags add the below into a post where `tagname` is both filename and URL friendly:

```tags: tagname anothertag```

To override `.blogrc` settings use command line arguments. Other options are also available, use `jenny -h` to display the message below:

```
jenny usage:
   -d ./dir   Override the build directory setting
   -p 10      Override posts per page setting
   -l ./dir   Override layout directory setting
   -m mmd     Override the markdown parser command setting
   -v         Display more information during building
   -n         Ignore the .bloglock file when building
   -c         Empty out the build folder prior to building
   -h         Show this help message
```

### Handy Shortcuts

Add these to your aliases:

```bash
# Publish file with current date
jenny publish filename.md

# Edit file without typing date/full filename
jenny edit partial-filename
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
