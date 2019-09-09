ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  compile        to compile a grumphp.phar shim"

compile:
	$(if $(TAG),,$(error TAG is not defined. Pass via "make compile TAG=4.2.1"))
	@echo Compiling $(TAG)
	$(eval BUILD_DIR := $(shell mktemp -d -t grumphp-shim-build))
	@echo Cloning GrumPHP $(TAG) in directory $(BUILD_DIR)
	git clone git@github.com:phpro/grumphp.git $(BUILD_DIR)
	git --work-tree=$(BUILD_DIR) --git-dir='$(BUILD_DIR)/.git' checkout 'tags/v$(TAG)'
	cp build/* '$(BUILD_DIR)'
	composer install --working-dir='$(BUILD_DIR)' --no-scripts --no-plugins --no-dev --no-interaction --optimize-autoloader
	./vendor/bin/box compile --working-dir='$(BUILD_DIR)'
	# Run sanity Check:
	rm -rf '$(BUILD_DIR)/vendor'
	composer update --dev --working-dir='$(BUILD_DIR)' --no-interaction
	cd $(BUILD_DIR) && ./grumphp.phar run --testsuite=git_pre_commit && cd $(ROOT_DIR)
	# All good : lets finish up
	cp '$(BUILD_DIR)/grumphp.phar' '$(ROOT_DIR)'
	gpg --local-user toonverwerft@gmail.com --armor --detach-sign grumphp.phar
	rm -rf $(BUILD_DIR)
	# TODO : Tag release
