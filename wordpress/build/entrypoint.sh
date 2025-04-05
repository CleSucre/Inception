#!/bin/bash

set -e

if [ ! -f "/var/www/html/wp-config.php" ]
then
	sleep 5
	wp core download --path="/var/www/html" --allow-root
	wp config create --path="/var/www/html" --allow-root --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --skip-check
	wp core install --path="/var/www/html" --allow-root --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email
	wp user create --path="/var/www/html" --allow-root $WP_USER $WP_EMAIL --user_pass=$WP_PASS --role='contributor'
else
	echo "WordPress already installed, skipping installation."
fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F