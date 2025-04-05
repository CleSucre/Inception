FROM debian:bullseye

LABEL author="CleSucre"

# Install PHP and required extensions
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y \
    php php-fpm php-mysql curl \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy configuration file
COPY ./www.conf /etc/php/7.4/fpm/pool.d/

RUN mkdir -p /run/php
WORKDIR	/var/www/wordpress/

# Setup entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 

# Expose the port for PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["/usr/sbin/php-fpm7.4", "-F"]