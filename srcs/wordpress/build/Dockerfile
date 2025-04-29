FROM debian:11

LABEL author="CleSucre"

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y \
    php php-fpm php-mysql curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./www.conf /etc/php/7.4/fpm/pool.d/

RUN mkdir -p /run/php
WORKDIR	/var/www/wordpress/

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]