#!/bin/bash

set -e

echo "Checking MariaDB data directory..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Creating MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo "Patching bind-address to 0.0.0.0..."
# Ensure the file exists and force bind-address
if grep -q "bind-address" /etc/mysql/my.cnf; then
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
else
    echo "[mysqld]" >> /etc/mysql/my.cnf
    echo "bind-address = 0.0.0.0" >> /etc/mysql/my.cnf
fi

echo "Starting MariaDB in safe mode..."
mysqld_safe --skip-networking &

echo "Waiting for MariaDB to fully start..."
until mysqladmin ping --silent; do
    sleep 2
    echo "MariaDB is not ready yet..."
done

sed -i 's|MYSQL_DATABASE|'${MYSQL_DATABASE}'|g' /tmp/init.sql
sed -i 's|MYSQL_USER|'${MYSQL_USER}'|g' /tmp/init.sql
sed -i 's|MYSQL_PASSWORD|'${MYSQL_PASSWORD}'|g' /tmp/init.sql
sed -i 's|MYSQL_ROOT_PASSWORD|'${MYSQL_ROOT_PASSWORD}'|g' /tmp/init.sql

echo "Executing the database initialization script..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" < /tmp/init.sql

echo "Initialization complete, shutting down MariaDB..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown || true

echo "Restarting MariaDB server..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
