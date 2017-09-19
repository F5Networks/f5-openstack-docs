# Makefile for building and testing project documentation

.PHONY: help
help:
	@echo "  docker-preview    to build preview of docs using sphinx-autobuild in a docker container"
	@echo "  docker-test       to build and test docs in a docker container"
	@echo "  docker-html       to build docs in a docker container"

# Build live preview of docs in a docker container
.PHONY: docker-preview
docker-preview:
	rm -rf docs/_build
	DOCKER_RUN_ARGS="-p 127.0.0.1:8000:8000" ./scripts/docker-docs.sh make -C docs preview

# run docs quality tests in a docker container
.PHONY: docker-test
docker-test:
	rm -rf docs/_build
	./scripts/docker-docs.sh ./scripts/test-docs.sh

# run HTML build in a docker container
.PHONY: docker-html
docker-html:
	rm -rf docs/_build
	./scripts/docker-docs.sh make -C docs/ html
