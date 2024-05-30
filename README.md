# Jenny

_Jenny_ is a static blog generator. Its aim is to work with minimal requirements and a small footprint while providing some modern conveniences.

- [x] Lightweight default theme
- [x] Markdown with Footnotes support, care of a modified [md2html.awk](https://bitbucket.org/yiyus/md2html.awk)
- [x] Basic pagination with fixed page numbers
- [x] Plug your own Markdown parser
- [x] Heredocs-based template syntax
- [x] Draft/ignore support (by leaving out the date)
- [x] Forward-posting, i.e. ignores posts with dates in the future
- [x] Tags support
- [x] Modifiable installation prefix
- [x] Define run-time settings in command arguments
- [x] Include static directories in build
- [x] Unique URL slug generation
- [x] Render only changed or new posts
- [x] RSS/Atom feed
- [ ] Tests


## Getting started, three ways 

#### 1. You can install `jenny` to your local bin folder

```
git clone https://github.com/hmngwy/jenny.git
make install
```

#### 2. Or, skip installation and use Docker, all references to the command `jenny` is interchangeable with the below

```
docker run -it -v $PWD:/blog hmngwy/jenny:latest
```

The Docker image contains Multimarkdown 6 so you can have `MARKDOWN_COMMAND="multimarkdown "` in your `.blogrc`.

#### 3. Or, as a Github Action to automatically build your blog

This repository is also the Github Action source, simply reference it in your Worflow steps, below is an example.

```
on: [push]

jobs:
  build_job:
    runs-on: ubuntu-latest
    name:  Build with Jenny
    steps:
    - uses: actions/checkout@v2
    - uses: hmngwy/jenny@master
```

You can fork the [hmngwy/jenny-template](https://github.com/hmngwy/jenny-template) repo to start using `jenny` without installing a thing.

## Setting up a Blog

Prepare the directory for your blog posts.

```
mkdir ./blog && cd blog
```

Use the subcommand below to initialize your blog folder with a `.blogrc` file and a sample first post.

```
jenny init
```

## Creating a Blog Post

A dated filename will be recognized as a published post, everything else is a draft and ignored, the format is:

```
YYYY-MM-DD a-published-post.md
```

Create a file with a date so that Jenny recognizes it as a published post.

```
cat <<EOT >> "$(date +%Y-%m-%d) hello-world.md"
# Hello World

Jenny is a static blog generator using bash, sed, and awk.
EOT
```

## Building the Blog

Run `jenny` on your blog directory.

## Command Line Arguments

To override `.blogrc` settings at run-time use command line arguments. Other options are also available, use `jenny -h` to display the message below:

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

```bash
# Publish file with current date
jenny publish filename.md

# Edit file without typing date/full filename
jenny edit partial-filename
```

## .blogrc settings

To configure posts per page:

```
POSTS_PER_PAGE=10
```

To use your own markdown parser, set `MARKDOWN_COMMAND`:

```
MARKDOWN_COMMAND=multimarkdown
```

To run a script after the build process, write a `post_hook` function in .blogrc:

```
function post_hook() {
  echo "Done!"
}
```

To set a different build folder, set `DIST`:

```
DIST=~/blog/.dist
```

To copy directories into the build folder:

```
STATIC_DIRS="images files"
```

## Post Formatting

Titles are Markdown H1s. Multimarkdown footnotes syntax supported in the vendored parser.

To use tags add the below into a post where `tagname` is both filename and URL friendly:

```
tags: tagname anothertag
```

## Theme Customization

From the project folder, copy the layout folder contents and modify to your liking, mind the template tags.

```cp -R ./share/jenny/layout ~/blog/.layout```

Let Jenny know where to find your customized layout files.

```
cat <<EOT >> .blogrc
LAYOUT_DIR=~/blog/.layout
EOT
```

## Plugs 🔌

Sites built with `jenny`.

Me - [@hmngwy](https://github.com/hmngwy): [manilafunctional.com](https://manilafunctional.com/)<sup>[src](https://github.com/hmngwy/blog)</sup>

Send a PR my way if you want to be on here. 


## Alternative Installation Modes

To soft install or symlink into your bin folder, good for contributing/development: 
```
sudo make sym-install [PREFIX=$PWD]
```

To install into a custom location do: ```make install [PREFIX=~/.local]```

To uninstall, in the project folder run: ```make uninstall```

## Credits

- Layout inspired by n-o-d-e.net
- Some colors from Solarized by Ethan Schoonover
- Makefile inspired by [moebiuseye/skf](https://github.com/moebiuseye/skf)

## License

MIT License

Copyright (c) 2024

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
