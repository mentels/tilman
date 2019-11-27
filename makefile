.PHONY: build publish release

MIX_ENV=prod
build:
	@mix escript.build 

TILMAN_VERSION=`./tilman --version`
publish:
	@echo "tilman built, version=${TILMAN_VERSION}"
	@echo "Go to https://github.com/mentels/TIL/releases/new and create a new release"

release: build publish