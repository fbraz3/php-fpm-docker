# PHP-FPM Docker

A multi-version php-fpm images listening on TCP port to easy integrate on webservers like nginx or httpd.

## Features
 - *Multi Version:* All supported PHP versions available
 - *Fast!* Don't comes with a builtin webserver, so less overhead and better response times! =D
 - *Up-to-Date:* Images auto-updated every week
 - *Secure:* Cron job auto installed into containers to auto update security packages every night;
 - *Green light to send emails:* PHP mail() function working like a charm

## Ready-to-go images
Chek out on [Docker Hub](https://hub.docker.com/r/fbraz3/php-fpm/)

## Getting started

First of all, create a network called `dockernet` using range `192.168.0.0/24` to get emails working over ssmtp email proxy.
```
# docker network create --subnet=192.168.0.0/24 dockernet
```
edit `/etc/postfix/main.cf` and add 192.168.0.0/24 on `mynetworks` params.
```
mynetworks = 127.0.0.0/8 192.168.0.0/24 [::ffff:127.0.0.0]/104 [::1]/128
```
Restart postfix
```
systemctl restart postfix
```

## Using this image
Best using docker-compose to start this image.
```
version: '2'
services:
 php-fpm:
  image: fbraz3/php-fpm:7.3
  volumes:
   - /my/app/root/:/app
  ports:
    - "127.0.0.1:1780:1780"
  extra_hosts:  
      - "mail:192.168.0.1"
  restart: always
networks:
 dockernet:
   external: true
```

**Note**: Dont forget to replace `/my/app/root/` to your real app root!

## Configuring nginx
We need to set fastcgi server to `tcp port 1780` like below
```
location ~ \.php$ {
        include              fastcgi_params;
        fastcgi_pass         127.0.0.1:1780;
        fastcgi_index        index.php;
        fastcgi_param        DOCUMENT_ROOT    /app/public;
        fastcgi_param        SCRIPT_FILENAME  /app/public$fastcgi_script_name;
    }
```