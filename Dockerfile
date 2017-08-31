FROM php:7.1.8-fpm

MAINTAINER Rex Zeng, rex@rexskz.info

ENV MYNUAA_ROOT_PATH /www

# add sourcelist
RUN echo 'deb http://mirrors.ustc.edu.cn/debian/ jessie main' > /etc/apt/sources.list
RUN echo 'deb http://mirrors.ustc.edu.cn/debian/ jessie-updates main' >> /etc/apt/sources.list

# install some extensions
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libicu-dev libmemcached-dev
RUN docker-php-ext-install mysqli pdo_mysql iconv mbstring intl

# for gd
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# for memcached
RUN yes '' | pecl install igbinary memcached \
RUN docker-php-ext-enable igbinary.so memcached.so

# clear cache
RUN apt-get clean && pecl clear-cache

EXPOSE 9000
