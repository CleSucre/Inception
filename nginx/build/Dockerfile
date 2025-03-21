FROM debian:12

LABEL author="CleSucre"

RUN apt-get update && \
    apt-get install -y nginx openssl certbot && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY nginx.conf.default /etc/nginx/nginx.conf

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
