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

Prepare the directory for your articles and build folder, create a file with a date so that Jenny recognizes it as a published post.

```
mkdir -p blog/.dist
echo "# Hello World" >> blog/2016-06-06\ first-post.md
```

In the same folder, create a .blogconfig file to tell Jenny where the build folder is. Careful, this file is sourced by Jenny.

```
echo "DIST=$PWD/.dist" >> blog/.blogconfig
```

Finally, run `(cd ~/blog; jenny)`

### Customization

1. Copy the layout folder and modify the contents to your liking, make sure to retain existing template tags -- remember linebreaks matter

   ```
   cp -R ./layout ~/blog/.layout
   ```
   
2. Let Jenny know where to find your own layout files

   ```
   echo "LAYOUT_DIR=$PWD/.layout" >> ~/blog/.blogconfig
   ```

### Other Settings

- To modify how many posts per page: `echo "LAYOUT_DIR=$PWD/.layout" >> ~/blog/.blogconfig`
- To run a script after the build process, write a `post_hook` function in .blogconfig

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
