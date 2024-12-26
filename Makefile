build:
	docker build -t ghcr.io/zetaoss/zbase:latest     -f Dockerfile     .
	docker build -t ghcr.io/zetaoss/zbase-dev:latest -f Dockerfile.dev .
