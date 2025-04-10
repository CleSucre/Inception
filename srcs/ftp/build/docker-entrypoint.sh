#!/bin/sh

FTP_DATA=/home/$FTP_USER
FTP_GROUP=$( getent group "$GID" | awk -F ':' '{print $1}' )

if test -z "$FTP_GROUP"; then
	FTP_GROUP=$FTP_USER
	addgroup -g "$GID" -S "$FTP_GROUP"
fi

adduser -D -G "$FTP_GROUP" -h "$FTP_DATA" -s "/bin/false" -u "$UID" "$FTP_USER"

mkdir -p $FTP_DATA
chown -R "$FTP_USER:$FTP_GROUP" "$FTP_DATA"
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

sed -i -r "s/0.0.0.0/$PUBLIC_IP/g" /etc/vsftpd.conf

exec "$@"