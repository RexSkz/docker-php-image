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
# runkit7 only supports PHP through 8.1; uopz provides overlapping runtime hooks on PHP 8+.
RUN --mount=type=bind,from=ghcr.io/php/pie:bin,source=/pie,target=/usr/local/bin/pie \
    pie install --no-cache igbinary/igbinary:dev-master && \
    pie install --no-cache imagick/imagick:3.8.1 && \
    pie install --no-cache --enable-memcached-igbinary php-memcached/php-memcached:3.4.0 && \
    pie install --no-cache krakjoe/uopz:@dev && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

EXPOSE 9000
