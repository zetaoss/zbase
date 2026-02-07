# https://hub.docker.com/_/mediawiki
FROM mediawiki:1.43.6-fpm
ENV MEDIAWIKI_BRANCH=REL1_43

# Extensions
# https://github.com/edwardspec/mediawiki-aws-s3/tags
ARG AWS_S3_VERSION=v0.13.1
# https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo/tags
ARG EMBED_VIDEO_VERSION=v4.0.0
# https://github.com/jmnote/NewArticleTemplates/tags
ARG NEW_ARTICLE_TEMPLATES_VERSION=v1.4.2
# https://github.com/jmnote/Resend/tags
ARG RESEND_VERSION=v0.1.1
# https://github.com/jmnote/SimpleMathJax/tags
ARG SIMPLE_MATH_JAX_VERSION=v0.8.10

# https://hub.docker.com/_/composer/tags
COPY --from=composer:2.9.5 /usr/bin/composer /usr/bin/composer

SHELL ["/bin/bash", "-lc"]

RUN set -eux \
    ## system packages
    && apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev \
    nginx \
    && rm -rf /var/lib/apt/lists/* \
    ## php extensions
    && curl -fsSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions \
    pdo_mysql \
    pcntl \
    redis \
    wikidiff2 \
    zip \
    && echo done

RUN set -eux \
    ## mediawiki extensions
    && cd /var/www/html/extensions/ \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/AntiSpoof.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/CharInsert.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/intersection.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/MsUpload.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/MultiBoilerplate.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Score.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/UserMerge.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Wikibase.git \
    && echo done

RUN set -eux \
    ## mediawiki extensions extra
    && cd /var/www/html/extensions/ \
    && git clone --depth=1 -b $AWS_S3_VERSION                https://github.com/edwardspec/mediawiki-aws-s3.git                     AWS \
    && git clone --depth=1 -b $EMBED_VIDEO_VERSION           https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo.git EmbedVideo \
    && git clone --depth=1 -b $NEW_ARTICLE_TEMPLATES_VERSION https://github.com/jmnote/NewArticleTemplates.git                      NewArticleTemplates \
    && git clone --depth=1 -b $RESEND_VERSION                https://github.com/jmnote/Resend.git                                   Resend \
    && git clone --depth=1 -b $SIMPLE_MATH_JAX_VERSION       https://github.com/jmnote/SimpleMathJax.git                            SimpleMathJax \
    && echo done

RUN set -eux \
    && cd /var/www/html/ \
    && cp composer.local.json-sample composer.local.json \
    && composer update --no-dev -o --no-scripts --no-security-blocking \
    && COMPOSER=composer.local.json composer require --no-update mediawiki/maps:~12.0 \
    && composer update mediawiki/maps --no-dev -o \
    && echo done
