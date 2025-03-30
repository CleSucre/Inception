#!/bin/bash

set -e

echo "Checking if WordPress is already installed..."
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Copying WordPress core files..."
    cp -r /var/tmp/html/* /var/www/html/

    echo "Copying wp-config-sample.php to wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    echo "Setting up database configuration..."
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

    echo "Setting up database configuration..."
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

    echo "Forcing HTTPS in wp-config.php..."
    sed -i "/That's all, stop editing/i\\
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\n\
    \$_SERVER['HTTPS'] = 'on';\n\
}" /var/www/html/wp-config.php

    echo "Setting up salts..."
    SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

    # Remove old keys
    sed -i "/AUTH_KEY/d" /var/www/html/wp-config.php
    sed -i "/SECURE_AUTH_KEY/d" /var/www/html/wp-config.php
    sed -i "/LOGGED_IN_KEY/d" /var/www/html/wp-config.php
    sed -i "/NONCE_KEY/d" /var/www/html/wp-config.php
    sed -i "/AUTH_SALT/d" /var/www/html/wp-config.php
    sed -i "/SECURE_AUTH_SALT/d" /var/www/html/wp-config.php
    sed -i "/LOGGED_IN_SALT/d" /var/www/html/wp-config.php
    sed -i "/NONCE_SALT/d" /var/www/html/wp-config.php

    # Append new keys
    echo "$SALTS" >> /var/www/html/wp-config.php

    echo "Setting correct permissions..."
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
else
    echo "wp-config.php already exists, skipping setup."
fi

echo "Starting PHP-FPM..."
exec php-fpm
