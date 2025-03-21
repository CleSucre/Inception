FROM php:7.4-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo pdo_mysql mysqli \
    && rm -rf /var/lib/apt/lists/*

# Set temporary work directory
WORKDIR /var/tmp/html

# Download and extract WordPress
RUN curl -o wordpress.tar.gz -fSL https://wordpress.org/latest.tar.gz \
    && tar -xvzf wordpress.tar.gz --strip-components=1 \
    && rm wordpress.tar.gz

# Set correct file ownership
RUN chown -R www-data:www-data /var/www/html

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 9000
EXPOSE 9000

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Start PHP-FPM
CMD ["php-fpm"]
