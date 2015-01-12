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

if [ "$MYTARDIS_CHECKOUT" ]; then
    checkout="$MYTARDIS_CHECKOUT"
else
    checkout="develop"
fi

echo $checkout > $top/checkout.txt

echo "su -l ubuntu -c $top/install-wrapper.sh < /dev/null 2>&1 | tee $top/install.log &" >> /etc/rc.local
