FROM ubuntu:18.04

COPY ./scripts/autoclean.sh /root/autoclean.sh
COPY ./scripts/docker-entrypoint.sh /docker-entrypoint.sh
COPY ./misc/cronfile.final /cronfile.final
COPY ./misc/cronfile.system /cronfile.system

RUN chmod +x /root/autoclean.sh
RUN chmod +x /docker-entrypoint.sh 

RUN mkdir /app
RUN mkdir /run/php/

RUN apt-get update
RUN apt-get install -y software-properties-common apt-transport-https cron vim ssmtp
COPY ./conf/ssmtp.conf.template /etc/ssmtp/ssmtp.conf.template

RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get install -y php7.3 php7.3-cgi php7.3-cli php7.3-common php7.3-curl php7.3-fpm php7.3-json php7.3-mysql php7.3-opcache php7.3-readline php7.3-xml php7.3-xsl

COPY ./php/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY ./php/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
COPY ./php/php.ini /etc/php/7.3/fpm/php.ini
COPY ./conf/env.conf /etc/php/7.3/fpm/env.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
