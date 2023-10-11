FROM php:8.2.10-fpm-bullseye

LABEL maintainer='Rex Zeng, rex@rexskz.info'

# add sourcelist
# RUN echo 'deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main' > /etc/apt/sources.list
# RUN echo 'deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main' >> /etc/apt/sources.list

# install some extensions
RUN apt-get update && \
    apt-get install -y \
        libicu-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev libmemcached-dev zlib1g-dev libsasl2-dev libbz2-dev zlib1g-dev libzip-dev && \
    docker-php-ext-install mysqli pdo_mysql bz2 zip

# for gd
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# for memcached
RUN yes '' | pecl install igbinary memcached
RUN docker-php-ext-enable igbinary.so memcached.so

# for imagick
RUN apt-get install -y libmagickwand-dev libmagickcore-dev && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# clear cache
RUN apt-get autoclean && apt-get clean && pecl clear-cache && rm -rf /var/lib/apt/lists/*

EXPOSE 9000
