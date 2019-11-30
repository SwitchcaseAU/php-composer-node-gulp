#############################################################################
# Dockerfile to build an image with Node, Yarn, Gulp, Git, php-cli, PHPUnit and composer
# Ideal for Drupal builds  
#############################################################################

## Add php image
FROM php:7.3-cli
MAINTAINER Amit Chandra <amit@switchcase.com.au>

# locale
RUN apt-get update \
	&& apt-get install -y locales

ENV DEBIAN_FRONTEND noninteractive

RUN ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
	&& locale-gen
	
## Update locales
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8	

RUN apt-get update \
	&& apt-get install -y \
		openssl \
		git \
		gnupg2


	


## Add NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs


## Add yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list


## Install yarn
RUN apt-get -y install yarn


## Install Gulp global
RUN npm install -g gulp


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

