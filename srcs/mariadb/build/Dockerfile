FROM debian:11

ENV MYSQL_DATABASE="database_name"
ENV MYSQL_USER="user_name"
ENV MYSQL_PASSWORD="a_super_password"
ENV MYSQL_ROOT_PASSWORD="a_super_password"

RUN apt-get update; \
    apt-get install -y \
      mariadb-server \
      mariadb-client; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rvf /var/lib/apt/lists/*

VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]