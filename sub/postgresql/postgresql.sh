#!/bin/bash -e

# packages

apt-get update
apt-get -y install python-psycopg2 postgresql

# zfs

service postgresql stop

fs=data/postgresql
zfs create $fs
chown postgres:postgres /$fs
mv /var/lib/postgresql/* /$fs
rmdir /var/lib/postgresql
ln -s /$fs /var/lib/postgresql

# auth

cp -f pg_hba.conf /etc/postgresql/9.4/main

# done

service postgresql start