SHELL := /bin/bash
PREFIX?=/usr/local
BIN=${PREFIX}/bin
SHARE=${PREFIX}/share

install:
		@echo "Installing jenny script"
		install -m 755 ./jenny $(BIN)/

		@echo "Copying assets"
		mkdir -p $(SHARE)/jenny
		cp -R ./share/* $(SHARE)/jenny/
		find $(SHARE)/jenny -type f -exec chmod 644 {} \;
		find $(SHARE)/jenny -type d -exec chmod 755 {} \;
		chmod +x $(SHARE)/jenny/lib/md2html.awk

mm_install:
		@echo "Installing MultiMarkdown.pl"
		git clone https://github.com/fletcher/MultiMarkdown.git $(SHARE)/jenny/lib/MultiMarkdown
		chmod +x $(SHARE)/jenny/lib/MultiMarkdown/bin/MultiMarkdown.pl

mm_uninstall:
		@echo "Uninstall MultiMarkown.pl"
		rm -rf $(SHARE)/jenny/lib/MultiMarkdown

uninstall:
		@echo "Removing script and assets"
		rm -rf $(BIN)/jenny $(SHARE)/jenny

reinstall:
		@echo "Running reinstall"
		make uninstall && make install
