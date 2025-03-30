#!/bin/bash

set -e

if grep -q "DOMAIN_NAME" /etc/vsftpd.conf; then
  sed -i "s/DOMAIN_NAME/ftp.$DOMAIN_NAME/g" /etc/vsftpd.conf
fi

if id "$FTP_USER" &>/dev/null; then
  echo "User $FTP_USER already exists."
else
  useradd -m "$FTP_USER" && echo "$FTP_USER:$FTP_PASS" | chpasswd
  echo "User $FTP_USER created."
fi
