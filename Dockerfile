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
RUN apt-get install -y software-properties-common apt-transport-https cron vim ssmtp monit
COPY ./conf/ssmtp.conf.template /etc/ssmtp/ssmtp.conf.template

COPY ./monit/monitrc /etc/monit/monitrc
COPY ./monit/cron /etc/monit/conf-enabled/cron
COPY ./monit/php-fpm /etc/monit/conf-enabled/php-fpm

RUN add-apt-repository -y ppa:ondrej/php
RUN export DEBIAN_FRONTEND=noninteractive; apt-get install -yq php7.3 php7.3-cli php7.3-common php7.3-curl php7.3-fpm php7.3-json php7.3-mysql php7.3-opcache php7.3-readline php7.3-xml php7.3-xsl php7.3-gd php7.3-intl php7.3-bz2 php7.3-bcmath php7.3-imap php7.3-gd php7.3-mbstring php7.3-pgsql php7.3-sqlite3 php7.3-xmlrpc php7.3-zip  php7.3-odbc php7.3-snmp php7.3-interbase php7.3-ldap php7.3-tidy php-tcpdf 

COPY ./php/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY ./php/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
COPY ./php/php.ini /etc/php/7.3/fpm/php.ini
COPY ./conf/env.conf /etc/php/7.3/fpm/env.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
