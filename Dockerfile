FROM ubuntu:16.04

MAINTAINER Bartek Mis <bartek.mis@gmail.com>

# Install apache, PHP 7, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    apache2 \
    php7.0 \
    php7.0-cli \
    libapache2-mod-php7.0 \
    php7.0-gd \
    php7.0-curl \
    php7.0-json \
    php7.0-mbstring \
    php7.0-mysql \
    php7.0-xml \
    php7.0-xsl \
    php7.0-zip

# Enable apache mods.
RUN a2enmod php7.0
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini
RUN sed -ie 's/memory_limit\ =\ 128M/memory_limit\ =\ 2G/g' /etc/php/7.0/apache2/php.ini
RUN sed -ie 's/\;date\.timezone\ =/date\.timezone\ =\ Europe\/Berlin/g' /etc/php/7.0/apache2/php.ini
RUN sed -ie 's/upload_max_filesize\ =\ 2M/upload_max_filesize\ =\ 200M/g' /etc/php/7.0/apache2/php.ini
RUN sed -ie 's/post_max_size\ =\ 8M/post_max_size\ =\ 200M/g' /etc/php/7.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid


# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND