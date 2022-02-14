ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  compile        to compile a grumphp.phar shim"
	@echo "  testlocal      to compile your local php version"

compile:
	$(if $(TAG),,$(error TAG is not defined. Pass via "make compile TAG=4.2.1"))
	$(if $(PHP),,$(error PHP is not defined. Pass via "make compile PHP=7.4.19"))
	@echo Compiling $(TAG)
	$(eval BUILD_DIR := $(shell mktemp -d -t grumphp-shim-build))
	@echo Cloning GrumPHP $(TAG) in directory $(BUILD_DIR)
	git clone git@github.com:phpro/grumphp.git $(BUILD_DIR)
	git --work-tree=$(BUILD_DIR) --git-dir='$(BUILD_DIR)/.git' checkout 'tags/v$(TAG)'
	make prepare BUILD_DIR=$(BUILD_DIR) PHP=$(PHP)
	make sanity BUILD_DIR=$(BUILD_DIR)
	make cleanup BUILD_DIR=$(BUILD_DIR)
	# Release tag
	@echo "Run 'make release TAG=$(TAG)' to tag a new release"

release:
	$(if $(TAG),,$(error TAG is not defined. Pass via "make release TAG=4.2.1"))
	git add -A
	git commit -m '$(TAG) release'
	git tag -s 'v$(TAG)' -m'Version $(TAG)'

testlocal:
	$(if $(GRUMPHP_DIR),,$(error GRUMPHP_DIR is not defined. Pass via "make testlocal GRUMPHP_DIR=/path/to/grumphp"))
	$(if $(PHP),,$(error PHP is not defined. Pass via "make testlocal PHP=7.4"))
	$(eval BUILD_DIR := $(shell mktemp -d -t grumphp-shim-build))
	@echo Copying GrumPHP to directory $(BUILD_DIR)
	cp -r $(GRUMPHP_DIR)/. $(BUILD_DIR)
	make prepare BUILD_DIR=$(BUILD_DIR) PHP=$(PHP)
	make cleanup BUILD_DIR=$(BUILD_DIR)

prepare:
	$(if $(PHP),,$(error PHP is not defined. Pass via "make prepare PHP=7.4.19"))
	$(if $(BUILD_DIR),,$(error BUILD_DIR is not defined. Pass via "make prepare BUILD_DIR=/tmp/prepared-grumphp-src"))
	cp build/* '$(BUILD_DIR)'
	cp src/Composer/FixBrokenStaticAutoloader.php '$(BUILD_DIR)/src/Composer'
	php $(BUILD_DIR)/fix-some-stuff-in-composer.php
	composer --working-dir='$(BUILD_DIR)' config platform.php '$(PHP)'
	composer install --working-dir='$(BUILD_DIR)' --no-scripts --no-plugins --no-dev --no-interaction --optimize-autoloader
	php -d error_reporting='(E_ALL & ~E_DEPRECATED)' ./vendor/bin/box compile --working-dir='$(BUILD_DIR)' -vvv
	# Copy composer plugin
	cp '$(BUILD_DIR)/src/Composer/GrumPHPPlugin.php' '$(ROOT_DIR)/src/Composer/GrumPHPPlugin.php'
	# All good : lets finish up
	cp '$(BUILD_DIR)/grumphp.phar' '$(ROOT_DIR)'
	gpg --local-user toonverwerft@gmail.com --armor --detach-sign grumphp.phar
	gpg --verify grumphp.phar.asc grumphp.phar

sanity:
	$(if $(BUILD_DIR),,$(error BUILD_DIR is not defined. Pass via "make sanity BUILD_DIR=/tmp/prepared-grumphp-src"))
	mv '$(BUILD_DIR)/composer.json.backup' '$(BUILD_DIR)/composer.json'
	rm -rf '$(BUILD_DIR)/vendor'
	composer update --dev --working-dir='$(BUILD_DIR)' --no-interaction
	cd $(BUILD_DIR) && ./grumphp.phar run --testsuite=git_pre_commit && cd $(ROOT_DIR)

cleanup:
	$(if $(BUILD_DIR),,$(error BUILD_DIR is not defined. Pass via "make cleanup BUILD_DIR=/tmp/prepared-grumphp-src"))
	rm -rf $(BUILD_DIR)

