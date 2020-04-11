HUGO_VERSION:="0.69.0"
OS:="Linux"
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BIN:="$(ROOT_DIR)/.bin"

.PHONY: build

build: clean install
	cd $(ROOT_DIR)/hugo && $(BIN)/hugo
	mv $(ROOT_DIR)/hugo/public/* $(ROOT_DIR)/

install: .bin/hugo

.bin/hugo:
	# install asciidoctor
	gem install asciidoctor

	# install hugo
	mkdir -p ".bin"
	[ -f hugo_extended_$(HUGO_VERSION)_$(OS)-64bit.tar.gz ] || wget https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_$(OS)-64bit.tar.gz
	tar -C .bin -xzvf hugo_extended_$(HUGO_VERSION)_$(OS)-64bit.tar.gz
	rm -rf hugo_extended_$(HUGO_VERSION)_$(OS)-64bit.tar.gz

clean:
	ls $(ROOT_DIR) | grep -v -E '^(CNAME|Makefile|hugo)$$' | xargs rm -rf || true
	rm -rf $(ROOT_DIR)/hugo/public/
