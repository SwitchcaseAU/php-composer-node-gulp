#############################################################################
# Dockerfile to build an image with Node, Yarn, Gulp, Git, php-cli, PHPUnit and composer
# Ideal for Drupal builds  
#############################################################################

## Add base image from Ubuntu
FROM ubuntu:18.04
MAINTAINER Amit Chandra <amit@switchcase.com.au>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        openssh-client \
        libpng-dev \
        apt-utils \
	    apt-transport-https \
        libcurl4-openssl-dev \
        curl \
        libtidy* \
        libzip-dev \
        mysql-client \
        gnupg \
        git \
        rsync \
        unzip \
        make \
        curl \
    	ca-certificates \
	    wget \
	    python3 \
    	python3-pip \
    	python3-setuptools \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

## Add php repository
RUN add-apt-repository ppa:ondrej/php -y

## Add git repository
RUN add-apt-repository ppa:git-core/ppa -y

## Add yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

## PHP 7.3
RUN apt-get update && apt-get install -y --no-install-recommends \
	php7.3-readline \
	php7.3-cli \
	php7.3-mysql \
	php7.3-json \
	php7.3-dom \
	php7.3-gmp \
	php7.3-mbstring \
	php7.3-zip \
	php7.3-gd \
	php7.3-bcmath \
	php7.3-bz2 \
	php7.3-curl \
	php7.3-intl \
	php7.3-redis \
	php7.3-imap
	

## Add SSL support
RUN apt-get -y install libssl-dev openssl

## Add NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

## Install yarn
RUN apt-get -y install npm yarn


## Install Gulp global
RUN npm install -g gulp

## Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

## Add composer bin to PATH
ENV PATH "$PATH:$HOME/.composer/vendor/bin"

## Install composer plugins
RUN /usr/local/bin/composer global require "hirak/prestissimo:^0.3.9"

## Install codesniffer
RUN wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN chmod +x phpcs.phar
RUN mv phpcs.phar /usr/local/bin/phpcs

## Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit-7.phar
RUN chmod +x phpunit-7.phar
RUN mv phpunit-7.phar /usr/local/bin/phpunit

