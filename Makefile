BIN=/usr/local/bin
SHARE=/usr/local/share

install:
		install -m 755 ./jenny ./lib/md2html.awk $(BIN)/

		mkdir -p $(SHARE)/jenny
		cp -R ./share/* $(SHARE)/jenny/
		find $(SHARE)/jenny -type f -exec chmod 644 {} \;
		find $(SHARE)/jenny -type d -exec chmod 755 {} \;

uninstall:
		rm -rf $(BIN)/jenny $(BIN)/md2html.awk $(SHARE)/jenny
