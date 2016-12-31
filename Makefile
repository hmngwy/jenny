PREFIX?=/usr/local
BIN=${PREFIX}/bin
SHARE=${PREFIX}/share

install:
		@echo "\nInstalling jenny script"
		install -m 755 ./jenny $(BIN)/

		@echo "\nCopying assets"
		mkdir -p $(SHARE)/jenny
		cp -R ./share/* $(SHARE)/jenny/
		find $(SHARE)/jenny -type f -exec chmod 644 {} \;
		find $(SHARE)/jenny -type d -exec chmod 755 {} \;

uninstall:
		@echo "\nRemoving script and assets"
		rm -rf $(BIN)/jenny $(SHARE)/jenny

reinstall:
		@echo "\nRunning reinstall"
		make uninstall && make install
