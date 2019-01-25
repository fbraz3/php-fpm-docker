FROM ubuntu:18.04

COPY ./scripts/autoclean.sh /root/
COPY ./scripts/docker-entrypoint.sh ./misc/cronfile.final ./misc/cronfile.system /

RUN chmod +x /root/autoclean.sh; \
chmod +x /docker-entrypoint.sh; \
mkdir /app; \
mkdir /run/php/; \
apt-get update; \
apt-get install -y software-properties-common apt-transport-https cron vim ssmtp monit; \
add-apt-repository -y ppa:ondrej/php; \
export DEBIAN_FRONTEND=noninteractive; \
apt-get install -yq php7.3 php7.3-cli php7.3-common php7.3-curl php7.3-fpm php7.3-json php7.3-mysql php7.3-opcache php7.3-readline php7.3-xml php7.3-xsl php7.3-gd php7.3-intl php7.3-bz2 php7.3-bcmath php7.3-imap php7.3-gd php7.3-mbstring php7.3-pgsql php7.3-sqlite3 php7.3-xmlrpc php7.3-zip  php7.3-odbc php7.3-snmp php7.3-interbase php7.3-ldap php7.3-tidy php-tcpdf


COPY ./conf/ssmtp.conf.template /etc/ssmtp/
COPY ./monit/monitrc ./monit/cron /etc/monit/
COPY ./php/www.conf /etc/php/7.3/fpm/pool.d/
COPY ./php/php-fpm.conf ./php/php.ini ./conf/env.conf /etc/php/7.3/fpm/

ENTRYPOINT ["/docker-entrypoint.sh"]
