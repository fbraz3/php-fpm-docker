#!/bin/bash

echo
echo "-----------------------------------------------------------"
echo "If you enjoy using this image, please consider donating."
echo "https://github.com/sponsors/fbraz3"
echo "-----------------------------------------------------------"
echo

$(which chmod) 700 /etc/monit/monitrc

# ADD CRON
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

# DECLARE/SET VARIABLES
PHPVERSION=`cat /PHP_VERSION 2>/dev/null`
if [ -z "$PHPVERSION" ]; then
    PHPVERSION=`php -v|grep --only-matching --perl-regexp "7\.\\d+" |head -n1`
fi

if [ -z "$PHPVERSION" ]; then
    PHPVERSION='7.3'
fi

# SET CUSTOM ID FOR www-data USER
if  [[ ! -z "$DATA_UID" ]] && [[ $DATA_UID =~ ^[0-9]+$ ]] ; then
	$(which usermod) -u $DATA_UID www-data;
fi

# SET CUSTOM ID FOR www-data GROUP
if  [[ ! -z "$DATA_GUID" ]] && [[ $DATA_GUID =~ ^[0-9]+$ ]] ; then
	$(which groupmod) -g $DATA_GUID www-data;
fi

# SORRY FOR THAT =(
if [ -f "/etc/php/fpm/php-fpm.conf" ]; then
    $(which cp) -f /etc/php/fpm/php-fpm.conf /etc/php/$PHPVERSION/fpm/php-fpm.conf
fi
if [ -f "/etc/php/fpm/php.ini" ]; then
    $(which cp) -f /etc/php/fpm/php.ini /etc/php/$PHPVERSION/fpm/php.ini
fi
if [ -f "/etc/php/fpm/pool.d/www.conf" ]; then
    $(which cp) -f /etc/php/fpm/pool.d/www.conf /etc/php/$PHPVERSION/fpm/pool.d/www.conf
fi

# PUPULATE TEMPLATES
$(which sed) -i 's/%PHP_VERSION%/'$PHPVERSION'/g' /etc/monit/conf-enabled/*
$(which sed) -i 's/%PHP_VERSION%/'$PHPVERSION'/g' /etc/php/$PHPVERSION/fpm/pool.d/*.conf
$(which sed) -i 's/%PHP_VERSION%/'$PHPVERSION'/g' /etc/php/$PHPVERSION/fpm/*.conf

# POPULATE VARIABLES
echo > /etc/php/$PHPVERSION/fpm/env.conf
echo > /etc/php/$PHPVERSION/fpm/overrides.conf
echo > /etc/php/$PHPVERSION/fpm/pool-overrides.conf
echo > /etc/php/$PHPVERSION/fpm/phpconf.conf
for i in `/usr/bin/env`; do
    PARAM=`echo $i |cut -d"=" -f1`
    VAL=`echo $i |cut -d"=" -f2`

    if [[ "$PARAM" == "_" ]]; then
        continue
    fi

    if [[ $PARAM =~ ^PHPADMIN_.+ ]]; then
        PHPPARAM=`echo $PARAM |sed 's/PHPADMIN_//g' | sed 's/__/./g' | awk '{print tolower($0)}'`
        echo "PHPADMIN   :: $PHPPARAM => $VAL"
        echo "php_admin_value[$PHPPARAM] =\"$VAL\"" >> /etc/php/$PHPVERSION/fpm/phpconf.conf

    elif [[ $PARAM =~ ^PHPFLAG_.+ ]]; then
        PHPPARAM=`echo $PARAM |sed 's/PHPFLAG_//g' | sed 's/__/./g' | awk '{print tolower($0)}'`
        echo "PHPFLAG    :: $PHPPARAM => $VAL"
        echo "php_flag[$PHPPARAM]=\"$VAL\"" >> /etc/php/$PHPVERSION/fpm/phpconf.conf

    elif [[ $PARAM =~ ^FPMCONFIG_.+ ]]; then
        FPMPARAM=`echo $PARAM |sed 's/FPMCONFIG_//g' | sed 's/__/./g' | awk '{print tolower($0)}'`
        echo "FPMCONFIG  :: $FPMPARAM => $VAL"
        echo "$FPMPARAM = $VAL" >> /etc/php/$PHPVERSION/fpm/overrides.conf

    elif [[ $PARAM =~ ^POOLCONFIG_.+ ]]; then
        FPMPARAM=`echo $PARAM |sed 's/POOLCONFIG_//g' | sed 's/__/./g' | awk '{print tolower($0)}'`
        echo "POOLCONFIG :: $FPMPARAM => $VAL"
        echo "$FPMPARAM = $VAL" >> /etc/php/$PHPVERSION/fpm/pool-overrides.conf

    elif [[ $PARAM =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "ENV :: $PARAM => $VAL"
        echo "env[$PARAM]=\"$VAL\"" >> /etc/php/$PHPVERSION/fpm/env.conf
    fi
done

# START SERVICES
/usr/sbin/service cron start
/usr/sbin/service php$PHPVERSION-fpm start
RESTART_MONIT="true"
