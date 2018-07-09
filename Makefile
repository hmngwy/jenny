SHELL := /bin/bash
PREFIX?=/usr/local
BIN=${PREFIX}/bin
SHARE=${PREFIX}/share

sym-install:
		@echo "Symlinking jenny script"
		ln -s $(pwd)/bin/jenny $(BIN)/jenny

install:
		@echo "Installing jenny script"
		install -m 755 ./bin/jenny $(BIN)/

		@echo "Installing jenny assets"
		cp -r ./share/jenny $(SHARE)/
		find $(SHARE)/jenny -type f -exec chmod 644 {} \;
		find $(SHARE)/jenny -type d -exec chmod 755 {} \;
		chmod +x $(SHARE)/jenny/lib/md2html.awk
		chmod +x $(SHARE)/jenny/lib/*.sh
		chmod +x $(SHARE)/jenny/layout/*.sh

uninstall:
		@echo "Removing script and assets"
		rm -rf $(BIN)/jenny $(SHARE)/jenny

reinstall:
		@echo "Running reinstall"
		make uninstall && make install
