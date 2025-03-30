FROM debian:12

LABEL author="CleSucre"

RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty

COPY vsftpd.conf /etc/vsftpd.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["./entrypoint.sh"]

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
