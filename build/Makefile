SHELL := /bin/bash

# `make help`          帮助信息
.PHONY: help
help:
	@cat Makefile | grep '# `' | grep -v '@cat Makefile'

define download_and_pack
	rm -rf     $(1)/
	rm -rf     $(1).tar.xz
	git clone  $(2)
	tar -cf    $(1).tar $(1)/
	rm -rf     $(1)/
	xz -v -T 0 $(1).tar
endef

.PHONY: download-ohmyzsh
download-ohmyzsh:
	$(call download_and_pack,ohmyzsh,https://github.com/ohmyzsh/ohmyzsh.git)

.PHONY: download-zsh-autosuggestions
download-zsh-autosuggestions:
	$(call download_and_pack,zsh-autosuggestions,https://github.com/zsh-users/zsh-autosuggestions.git)

# `make download`      下载资源
.PHONY: download
download: download-ohmyzsh download-zsh-autosuggestions
