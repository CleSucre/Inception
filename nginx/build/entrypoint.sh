#!/bin/bash

set -e

CERT_DIR="/etc/nginx/certs"
DOMAIN_NAME=${DOMAIN_NAME:-localhost}
ADMIN_EMAIL="admin@${DOMAIN_NAME}"

CERT_FILE="$CERT_DIR/fullchain.pem"
KEY_FILE="$CERT_DIR/privkey.pem"

echo "Checking if certificate already exists..."
if [[ -f "$CERT_FILE" && -f "$KEY_FILE" ]]; then
    echo "Certificate already exists, skipping generation."
else
    echo "Attempting to generate SSL certificate for $DOMAIN_NAME and wordpress.$DOMAIN_NAME using certbot..."

    certbot certonly --standalone --non-interactive --agree-tos \
        --email "$ADMIN_EMAIL" \
        -d "$DOMAIN_NAME" -d "wordpress.$DOMAIN_NAME" || {

        echo "Let's Encrypt certificate generation failed. Generating a fallback self-signed certificate."

        openssl req -x509 -nodes -days 365 \
            -newkey rsa:2048 \
            -keyout "$KEY_FILE" \
            -out "$CERT_FILE" \
            -subj "/C=FR/ST=France/L=Local/O=Dev/OU=SelfSigned/CN=$DOMAIN_NAME"

        echo "Self-signed certificate created for $DOMAIN_NAME"
    }
fi

# Replace DOMAIN_NAME placeholders in the nginx config
if grep -q "DOMAIN_NAME" /etc/nginx/nginx.conf; then
    echo "Replacing DOMAIN_NAME placeholders in Nginx configuration..."
    sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" /etc/nginx/nginx.conf
elif ! grep -q "$DOMAIN_NAME" /etc/nginx/nginx.conf; then
    echo "Updating Nginx server_name with $DOMAIN_NAME..."
    sed -i "s/server_name _;/server_name $DOMAIN_NAME;/" /etc/nginx/nginx.conf
else
    echo "Nginx configuration already contains $DOMAIN_NAME"
fi

echo "Starting Nginx..."
exec nginx -g "daemon off;"
