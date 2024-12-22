# https://github.com/wikimedia/mediawiki-docker
FROM mediawiki:1.42.3-fpm-alpine

COPY --from=composer:lts /usr/bin/composer /usr/bin/composer

RUN set -eux \
    && apk add --no-cache \
    inotify-tools \
    lua5.1 \
    nginx \
    nodejs \
    tini
    && docker-php-ext-install zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && rm -r /tmp/pear
