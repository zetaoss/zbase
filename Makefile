TAG ?= latest

build:
	# Don't push images from here. Please use the GitHub Actions workflows.
	docker build  --progress=plain -t ghcr.io/zetaoss/zbase:$(TAG) -f Dockerfile .
