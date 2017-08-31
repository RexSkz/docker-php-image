FROM php:7.1.8-fpm

MAINTAINER Rex Zeng, rex@rexskz.info

ENV MYNUAA_ROOT_PATH /www

RUN echo 'deb http://mirrors.ustc.edu.cn/debian/ jessie main' > /etc/apt/sources.list
RUN echo 'deb http://mirrors.ustc.edu.cn/debian/ jessie-updates main' >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libicu-dev libmemcached
RUN docker-php-ext-install mysqli pdo_mysql iconv mbstring intl
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN apt-get clean \
	&& yes '' | pecl install igbinary memcached \
	&& pecl clear-cache \
	&& docker-php-ext-enable igbinary.so memcached.so

EXPOSE 9000
