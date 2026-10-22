# syntax=docker/dockerfile:1
FROM php:8.6-rc-fpm-alpine3.24

LABEL maintainer='Rex Zeng, rex@rexskz.info'

RUN apk add --no-cache \
    bzip2-dev \
    cyrus-sasl-dev \
    freetype-dev \
    icu-dev \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libzip-dev \
    zlib-dev && \
    apk add --no-cache --virtual .build-deps \
    autoconf \
    automake \
    build-base \
    libtool \
    m4 \
    pkgconf \
    unzip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install bz2 gd mysqli pdo_mysql zip

# PHP 8.6 images no longer include PECL. Use the official PHP extension installer.
# runkit7 only supports PHP through 8.1, and current uopz sources use APIs removed in PHP 8.6.
# Neither runtime-rewriting extension can currently be built for this PHP version.
RUN --mount=type=bind,from=ghcr.io/php/pie:bin,source=/pie,target=/usr/local/bin/pie \
    pie_install_extension() { \
        if pie install --no-cache "$@"; then return 0; fi; \
        for build_log in /tmp/pie_make_output_*; do \
            if [ -f "$build_log" ]; then tail -n 100 "$build_log"; fi; \
        done; \
        return 1; \
    }; \
    pie_install_extension igbinary/igbinary:dev-master && \
    pie_install_extension imagick/imagick:dev-master && \
    pie_install_extension --enable-memcached-igbinary php-memcached/php-memcached:dev-issue-8.6.0beta1 && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

EXPOSE 9000
