# https://github.com/wikimedia/mediawiki-docker
FROM mediawiki:1.42.3-fpm-alpine

RUN set -eux \
    && apk add --no-cache \
    # dev
    inotify-tools \
    nodejs \
    # prod
    lua5.1 \
    nginx \
    tini
