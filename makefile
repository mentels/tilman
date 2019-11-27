.PHONY: build publish release

release: build publish

MIX_ENV=prod
build:
	@mix escript.build 

TILMAN_VERSION=`./tilman --version`
publish:
	@echo "tilman built, version=${TILMAN_VERSION}"
	@echo "Go to https://github.com/mentels/tilman/releases/new and create a new release"
