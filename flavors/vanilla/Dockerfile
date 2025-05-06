ARG PHP_VERSION=8.2
ARG BUILD_ARCH="amd64"
ARG BUILD_FLAVOR=""
FROM fbraz3/php-cli:$PHP_VERSION$BUILD_FLAVOR
USER root

ARG PHP_VERSION
ARG BUILD_ARCH
ENV DEBIAN_FRONTEND=noninteractive
ENV ENTRYPOINT_COMMAND="/usr/bin/tail -f /var/log/php$PHP_VERSION-fpm.log"

COPY ../../assets/misc/cronfile.final /
COPY ../../assets/misc/cronfile.system /
COPY ../../assets/scripts/docker-entrypoint.sh /entrypoints/php-fpm-entrypoint.sh

RUN chmod +x /entrypoints/php-fpm-entrypoint.sh; \
    mkdir /app; \
    mkdir /run/php/; \
    mkdir -p /app/public;

#ensure php repo is up-to-date
RUN for i in {1..10}; do \
      add-apt-repository -y ppa:ondrej/php && break || sleep 10; \
    done

RUN /usr/bin/unattended-upgrades -v;

# Install packages
RUN apt-get -fy install php$PHP_VERSION-fpm monit cron;

COPY ../../assets/monit/monitrc /etc/monit/
COPY ../../assets/monit/cron  /etc/monit/conf-enabled/
COPY ../../assets/monit/php-fpm /etc/monit/conf-enabled/
COPY ../../assets/php/www.conf /etc/php/$PHP_VERSION/fpm/pool.d/
COPY ../../assets/php/php-fpm.conf /etc/php/$PHP_VERSION/fpm/
COPY ../../assets/php/php.ini /etc/php/$PHP_VERSION/fpm/
COPY ../../assets/conf/env.conf /etc/php/$PHP_VERSION/fpm/

RUN update-alternatives  --set php /usr/bin/php$PHP_VERSION

# Fix Permissions
RUN chown -R www-data. /app; \
    chown www-data. /var/log/php$PHP_VERSION-fpm.log; \
    chown www-data. /cronfile; \
    chown www-data. /cronfile.system; \
    chown www-data. /cronfile.final; \
    chown -R www-data. /var/run/php/; \
    chown -R www-data. /etc/monit/; \
    chown -R www-data. /etc/php/$PHP_VERSION/fpm/pool.d/; \
    chown -R www-data. /etc/php/$PHP_VERSION/fpm/; \
    chown -R www-data. /etc/php/$PHP_VERSION/conf.d/; \
    chown -R www-data. /etc/php/$PHP_VERSION/mods-available/; \
    touch /var/run/crond.pid; \
    touch /var/run/monit.pid; \
    touch /var/run/php$PHP_VERSION-fpm.pid; \
    touch /var/log/php$PHP_VERSION-fpm.log; \
    chown www-data. /var/run/crond.pid; \
    chown www-data. /var/run/monit.pid; \
    chown www-data. /var/run/php$PHP_VERSION-fpm.pid; \
    chown www-data. /var/log/php$PHP_VERSION-fpm.log; \
    chown www-data. /var/log/monit.log; \
    chown -R www-data. /var/lib/monit; \
    chown -R www-data. /var/www/

# Fix cron daemon execution with non-root user
# https://stackoverflow.com/a/56473416/8202079
RUN chmod gu+rw /var/run; \
    chmod gu+s /usr/sbin/cron;

WORKDIR /app

USER www-data
ENTRYPOINT ["/docker-entrypoint.sh"]
