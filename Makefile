help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  run            to perform GrumPHP tests"
	@echo "  compile        to compile a shim"

compile:
	$(if $(TAG),,$(error TAG is not defined. Pass via "make compile TAG=4.2.1"))
	@echo Compiling $(TAG)
	BUILD_DIR := $(mktemp -d -t grumphp-shim-build)
	@echo Cloning GrumPHP $(TAG) in directory $(BUILD_DIR)
	cd $(BUILD_DIR) && git clone git@github.com:phpro/grumphp.git && git checkout tags/$(TAG)
	./vendor/bin/box compile --config="box.json" --working-dir=$(BUILD_DIR)
	# rmdir -r $(BUILD_DIR)
