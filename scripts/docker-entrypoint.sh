#!/bin/bash

#CLEAN
/root/autoclean.sh

#CRON
CRONFILE="/cronfile.final"
SYSTEMCRON="/cronfile.system"
USERCRON="/cronfile"

echo > $CRONFILE
if [ -f "$SYSTEMCRON" ]; then
	cat $SYSTEMCRON >> $CRONFILE
fi
if [ -f "$USERCRON" ]; then
	cat $USERCRON >> $CRONFILE
fi
/usr/bin/crontab $CRONFILE

#ENV
PHPVERSION=`php -v|grep --only-matching --perl-regexp "7\.\\d+" |head -n1`
echo > /etc/php/$PHPVERSION/fpm/env.conf
for i in `/usr/bin/env`; do
    PARAM=`echo $i |cut -d"=" -f1`
    VAL=`echo $i |cut -d"=" -f2`
    echo "env[$PARAM]=\"$VAL\"" >> /etc/php/$PHPVERSION/fpm/env.conf
done

cp -f /etc/ssmtp/ssmtp.conf.template /etc/ssmtp/ssmtp.conf
sed -i 's/MY_HOSTNAME/'`/bin/hostname`'/g' /etc/ssmtp/ssmtp.conf

#SERVICOS
/usr/sbin/service cron restart
/usr/sbin/service php7.3-fpm restart
sleep 1
/usr/sbin/service monit start

/usr/bin/tail -f /var/log/php7.3-fpm.log
