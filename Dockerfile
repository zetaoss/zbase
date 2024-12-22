# https://github.com/wikimedia/mediawiki-docker
FROM mediawiki:1.42.3-fpm-alpine

RUN set -eux \
    && apk add --no-cache \
    lua5.1 \
    nginx \
    tini \
    && docker-php-ext-install zip \
    && pecl install \
    redis \
    && docker-php-ext-enable \
    redis \
    && rm -rf /tmp/pear/

RUN set -eux \
    && cd /var/www/html/extenstions/ \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/AntiSpoof.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/CharInsert.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/intersection.git
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/OAuth.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/SendGrid.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/UserMerge.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Wikibase.git \
    && echo done
