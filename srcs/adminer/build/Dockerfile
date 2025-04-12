FROM debian:11

LABEL author="CleSucre"

RUN apt-get update && \
    apt-get install -y \
    php php-mysqli php-pgsql php-sqlite3 curl unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

RUN curl -sL https://www.adminer.org/latest.php -o /var/www/html/index.php

WORKDIR /var/www/html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
