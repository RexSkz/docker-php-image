FROM php:8.3-rc-fpm-alpine3.20

LABEL maintainer='Rex Zeng, rex@rexskz.info'

RUN apk update && apk add \
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
    zlib-dev \
    autoconf \
    libc-dev \
    gcc \
    make && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install bz2 gd mysqli pdo_mysql zip && \
    yes '' | pecl install igbinary imagick memcached channel://pecl.php.net/runkit7-4.0.0a6 && \
    docker-php-ext-enable igbinary.so memcached.so imagick runkit7 && \
    pecl clear-cache && \
    apk del autoconf gcc libc-dev make && rm -rf /var/cache/apk/*

EXPOSE 9000
