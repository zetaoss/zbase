TAG ?= latest

build:
	# Don't push images from here. Please use the GitHub Actions workflows.
	docker build -t ghcr.io/zetaoss/zbase:$(TAG) -f Dockerfile .
