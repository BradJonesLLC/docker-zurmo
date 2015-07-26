FROM debian:jessie

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -yqq --no-install-recommends \
    apache2 \
    libapache2-mod-php5 \
    php5-mysql \
    php5-gd \
    php5-xdebug \
    php5-memcache \
    supervisor \
    ruby \
    ruby-dev \
    php5-curl \
    php-apc \
    php-soap \
    php5-imap \
    php5-gd \
    php-pear \
    php5-mcrypt \
    libsqlite3-dev \
    build-essential \
    cron \
    && a2enmod ssl \
    && a2enmod rewrite \
    && a2enmod expires \
    && php5dismod xdebug \
    && apt-get clean autoclean && apt-get autoremove -y

RUN gem install mailcatcher
RUN rm -rf /var/www/*
COPY ./ /var/www
COPY config/docker/web/default.apache /etc/apache2/sites-available/000-default.conf
COPY config/docker/web/xdebug.ini /xdebug.ini
RUN cat /xdebug.ini | tee -a /etc/php5/mods-available/xdebug.ini
COPY config/docker/web/crontab.txt /var/crontab.txt
RUN crontab /var/crontab.txt && chmod 600 /etc/crontab

COPY config/docker/web/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443
CMD ["/usr/bin/supervisord"]
