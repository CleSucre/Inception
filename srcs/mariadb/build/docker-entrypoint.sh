#!/bin/bash

set -e

# start mysqld

echo "Starting mysqld"

mysqld_safe &

echo "mysqld is operational"


# wait 60 seconds for mysqld to become operational

for I in {0..59}; do
    if mysql -v --user=root --password="" -e "SELECT 1"; then
        break
    fi
    sleep 1s
done

# exit with error code 1 if mysqld didn't became operational after 60 seconds

if [ "${I}" == "59" ]; then
    exit 1
fi

# configure database, user and access from environment variables

mysql -v -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}"
mysql -v -e "CREATE USER IF NOT EXISTS ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"
mysql -v -e "CREATE USER IF NOT EXISTS ${MYSQL_USER}@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}'"
mysql -v -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'%'"
mysql -v -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'localhost'"
mysql -v -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -v -e "FLUSH PRIVILEGES"

# wait for any subprocess to fail and get it's exit code

set +e
wait -n
set -e

ERROR_CODE=$?

# gracefully shutdown mysql if it is working

if mysql -v -e "SELECT 1"; then
    mysqladmin shutdown || true
fi

# exit bash with fail subprocess exit code

exit ${ERROR_CODE}