FROM ubuntu:18.04

ARG PHP_VERSION=7.3

COPY ./scripts/autoclean.sh /root/
COPY ./scripts/docker-entrypoint.sh ./misc/cronfile.final ./misc/cronfile.system /

RUN echo $PHP_VERSION > /PHP_VERSION; \
chmod +x /root/autoclean.sh; \
chmod +x /docker-entrypoint.sh; \
mkdir /app; \
mkdir /run/php/; \
apt-get update; \
apt-get install -y software-properties-common apt-transport-https cron vim ssmtp monit curl less; \
add-apt-repository -y ppa:ondrej/php; \
export DEBIAN_FRONTEND=noninteractive; \
apt-get install -yq php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-common php$PHP_VERSION-curl php$PHP_VERSION-fpm php$PHP_VERSION-json php$PHP_VERSION-mysql php$PHP_VERSION-opcache php$PHP_VERSION-readline php$PHP_VERSION-xml php$PHP_VERSION-xsl php$PHP_VERSION-gd php$PHP_VERSION-intl php$PHP_VERSION-bz2 php$PHP_VERSION-bcmath php$PHP_VERSION-imap php$PHP_VERSION-gd php$PHP_VERSION-mbstring php$PHP_VERSION-pgsql php$PHP_VERSION-sqlite3 php$PHP_VERSION-xmlrpc php$PHP_VERSION-zip  php$PHP_VERSION-odbc php$PHP_VERSION-snmp php$PHP_VERSION-interbase php$PHP_VERSION-ldap php$PHP_VERSION-tidy php-tcpdf php-redis php-imagick; \
/usr/bin/unattended-upgrades -v; \
curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp; \
chmod +x /usr/local/bin/wp;

COPY ./conf/ssmtp.conf.template /etc/ssmtp/
COPY ./monit/monitrc /etc/monit/
COPY ./monit/cron ./monit/php-fpm /etc/monit/conf-enabled/
COPY ./php/www.conf /etc/php/$PHP_VERSION/fpm/pool.d/
COPY ./php/php-fpm.conf ./php/php.ini ./conf/env.conf /etc/php/$PHP_VERSION/fpm/

ENTRYPOINT ["/docker-entrypoint.sh"]
