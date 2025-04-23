FROM debian:11

LABEL author="CleSucre"

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY my.cnf /etc/mysql/my.cnf

COPY init.sql /docker-entrypoint-initdb.d/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

VOLUME /var/lib/mysql

ENTRYPOINT ["/entrypoint.sh"]
