FROM debian:11

LABEL author="CleSucre"

RUN apt-get update && apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld /var/lib/mysql /docker-entrypoint-initdb.d && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql /docker-entrypoint-initdb.d && \
    chmod 777 /var/run/mysqld

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY init.sql /tmp/init.sql

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
