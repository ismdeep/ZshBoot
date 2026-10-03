.PHONY: help
help:
	@cat Makefile | grep '# `' | grep -v '@cat Makefile'

# `make build`
.PHONY: build
build:
	bash build.sh

# `make vendor`
.PHONY: vendor
vendor:
	bash vendor.sh all
