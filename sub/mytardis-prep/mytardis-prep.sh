#!/bin/sh -e

fs=data/mytardis
top=/$fs

zfs create $fs
chown ubuntu:ubuntu $top

for script in install.sh install-wrapper.sh mytardis-create-superuser ; do
  install -o ubuntu -g ubuntu $script $top
done

cp -f nginx-default.conf /etc/nginx/sites-available/default
htpasswd -bc /etc/nginx/.htpasswd modc08 $NGINX_PASSWORD

echo $MYTARDIS_CHECKOUT > $top/checkout.txt

wget -q -O - $MYTARDIS_SETTINGS_URL | openssl $MYTARDIS_SETTINGS_CIPHER -d -pass pass:$MYTARDIS_SETTINGS_PASS > $top/settings.py

echo "su -l ubuntu -c $top/install-wrapper.sh < /dev/null 2>&1 | tee $top/install.log &" >> /etc/rc.local
