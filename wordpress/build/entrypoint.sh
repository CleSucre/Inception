#!/bin/bash

set -e

# Check if wp-config.php already exists
if [ ! -f /var/www/html/wp-config.php ]; then
  cp /var/tmp/html/* /var/www/html/
  echo "Copying wp-config-sample.php to wp-config.php..."
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  echo "Setting up database configuration..."
  sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
  sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
  sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
  sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

  echo "Setting up salts..."
  SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

  # Delete old keys
  sed -i "/AUTH_KEY/d" /var/www/html/wp-config.php
  sed -i "/SECURE_AUTH_KEY/d" /var/www/html/wp-config.php
  sed -i "/LOGGED_IN_KEY/d" /var/www/html/wp-config.php
  sed -i "/NONCE_KEY/d" /var/www/html/wp-config.php
  sed -i "/AUTH_SALT/d" /var/www/html/wp-config.php
  sed -i "/SECURE_AUTH_SALT/d" /var/www/html/wp-config.php
  sed -i "/LOGGED_IN_SALT/d" /var/www/html/wp-config.php
  sed -i "/NONCE_SALT/d" /var/www/html/wp-config.php

  # Replace with new keys
  echo "$SALTS" >> /var/www/html/wp-config.php

else
  echo "wp-config.php already exists."
fi

echo "Starting PHP-FPM..."
exec php-fpm

