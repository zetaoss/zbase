TAG ?= latest

build:
	# Don't push images from here. Please use the GitHub Actions workflows.
	docker build -t ghcr.io/zetaoss/zbase:$(TAG) -f Dockerfile .
	docker build --build-arg ZBASE_TAG=$(TAG) -t ghcr.io/zetaoss/zbase-dev:$(TAG) -f Dockerfile.dev .
