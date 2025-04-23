#!/bin/sh

set -e

cp /docker-entrypoint-initdb.d/init.sql /tmp/init.sql

sed -i "s|MYSQL_DATABASE|${MYSQL_DATABASE}|g" /tmp/init.sql
sed -i "s|MYSQL_USER|${MYSQL_USER}|g" /tmp/init.sql
sed -i "s|MYSQL_PASSWORD|${MYSQL_PASSWORD}|g" /tmp/init.sql
sed -i "s|MYSQL_ROOT_PASSWORD|${MYSQL_ROOT_PASSWORD}|g" /tmp/init.sql

mv /tmp/init.sql /docker-entrypoint-initdb.d/init.sql

exec mysqld_safe
