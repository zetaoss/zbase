# https://hub.docker.com/_/mediawiki
FROM mediawiki:1.43.6-fpm

# https://nodejs.org/en/download LTS for linux using nvm
ARG NVM_VERSION=v0.40.3
ARG NODE_MAJOR_VERSION=24

# Extensions
# https://github.com/edwardspec/mediawiki-aws-s3/tags
ARG AWS_S3_VERSION=v0.13.1
# https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo/releases
ARG EMBED_VIDEO_VERSION=v4.0.0
# https://github.com/jmnote/SimpleMathJax
ARG SIMPLE_MATH_JAX_VERSION=v0.8.10

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
    ## nvm / node / pnpm
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash \
    && source "$HOME/.nvm/nvm.sh" \
    && nvm install ${NODE_MAJOR_VERSION} \
    && node -v \
    && corepack enable pnpm \
    && pnpm -v \
    ## mediawiki extensions
    && cd /var/www/html/extensions/ \
    && MEDIAWIKI_BRANCH="REL$(printf '%s' "$MEDIAWIKI_MAJOR_VERSION" | tr '.' '_')" \
    && export MEDIAWIKI_BRANCH \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/AntiSpoof.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/CharInsert.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/intersection.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/MsUpload.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Score.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/SendGrid.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/UserMerge.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets.git \
    && git clone --depth=1 -b $MEDIAWIKI_BRANCH https://gerrit.wikimedia.org/r/mediawiki/extensions/Wikibase.git \
    ##
    && git clone --depth=1 -b $AWS_S3_VERSION          https://github.com/edwardspec/mediawiki-aws-s3.git                     AWS \
    && git clone --depth=1 -b $EMBED_VIDEO_VERSION     https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo.git EmbedVideo \
    && git clone --depth=1 -b $SIMPLE_MATH_JAX_VERSION https://github.com/jmnote/SimpleMathJax.git                            SimpleMathJax \
    && echo done
