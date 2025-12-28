FROM mediawiki:1.43.6-fpm

ARG NVM_VERSION=v0.40.3                  # https://nodejs.org/en/download
ARG NODE_MAJOR_VERSION=24                # https://nodejs.org/en/download
ARG MEDIAWIKI_AWS_S3_VERSION=v0.13.1     # https://github.com/edwardspec/mediawiki-aws-s3/tags
ARG MEDIAWIKI_EMBED_VIDEO_VERSION=v4.0.0 # https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo/releases

RUN set -eux \
    && apt-get update && apt-get install -y \
    libzip-dev \
    nginx \
    && rm -rf /var/lib/apt/lists/* \
    ##
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash \
	&& . "$HOME/.nvm/nvm.sh" \
	&& nvm install ${NODE_MAJOR_VERSION} \
	&& node -v \
	&& corepack enable pnpm \
	&& pnpm -v \
    && docker-php-ext-install \
    pdo_mysql \
    zip \
    && pecl install \
    redis \
    && docker-php-ext-enable \
    redis \
    && rm -rf /tmp/pear/ \
    && docker-php-ext-install pcntl \
    && cd /var/www/html/extensions/ \
    ##
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
	&& git clone --depth=1 -b $MEDIAWIKI_AWS_S3_VERSION      https://github.com/edwardspec/mediawiki-aws-s3.git                     AWS \
    && git clone --depth=1 -b $MEDIAWIKI_EMBED_VIDEO_VERSION https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo.git EmbedVideo \
    && echo done
