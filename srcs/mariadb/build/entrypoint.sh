#!/bin/sh

if [ -d "/run/mysqld" ]; then
    echo "mysqld already present, skipping creation"
else
    echo "mysqld not found, creating...."
    mkdir -p /run/mysqld
fi

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ -d /var/lib/mysql/mysql ]; then
    echo "DB data directory already present, skipping creation"
else
    echo "DB data directory not found, creating initial DBs"

    mariadb-install-db --user=mysql --ldata=/var/lib/mysql > /dev/null

    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF > "$tfile"
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci ;
GRANT ALL ON $MYSQL_DATABASE.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES ;
EOF

    mariadbd --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$tfile"
    rm -f "$tfile"

    echo 'DB init process done. Ready for start up.'
fi

exec mariadbd --user=mysql --console --skip-name-resolve --skip-networking=0 "$@"