# https://github.com/wikimedia/mediawiki-docker
FROM mediawiki:1.42.3-fpm-alpine

RUN set -eux \
    && apk add --no-cache \
    autoconf \
    build-base \
    composer \
    inotify-tools \
    libzip-dev \
    linux-headers \
    lua5.1 \
    nginx \
    nodejs \
    tini \
    && docker-php-ext-install zip \
    && pecl install redis xdebug \
    && docker-php-ext-enable redis xdebug
