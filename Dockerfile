FROM php:7.4-apache AS php-base

# Set Apache document root
ENV APACHE_DOCUMENT_ROOT /var/www/src
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Dependencies
RUN apt-get update -y && apt-get install -y ssh libpng-dev libmagickwand-dev libjpeg-dev libmemcached-dev zlib1g-dev libzip-dev git unzip subversion ca-certificates libicu-dev libxml2-dev libmcrypt-dev && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/

# PHP Extensions - PECL
RUN pecl install imagick-3.4.4 memcached mcrypt-1.0.4 && docker-php-ext-enable imagick memcached mcrypt

# PHP Extensions - docker-php-ext-install
RUN docker-php-ext-install zip gd mysqli exif pdo pdo_mysql opcache intl soap

# PHP Extensions - docker-php-ext-configure
RUN docker-php-ext-configure intl

# PHP Tools
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Config
RUN a2enmod rewrite

# http://blog.oddbit.com/post/2019-02-24-docker-build-learns-about-secr/
# This is necessary to prevent the "git clone" operation from failing
# with an "unknown host key" error.
RUN mkdir -m 700 /root/.ssh; \
  touch -m 600 /root/.ssh/known_hosts; \
  ssh-keyscan github.com > /root/.ssh/known_hosts

# Override default config with custom PHP settings
COPY docker-config/* $PHP_INI_DIR/conf.d/

FROM php-base AS php

# Copy files
COPY / /var/www/

# Install Composer dependencies
RUN cd /var/www && composer install --no-dev && composer clear-cache

EXPOSE 80
