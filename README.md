# Inception

This project involves setting up a small infrastructure composed of different services under specific rules.

## Services

### Nginx

Nginx is a web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.

- **Port:** 443

### MariaDB

MariaDB is a community-developed, commercially supported fork of the MySQL relational database management system.

- **Port:** 3306

### Wordpress

WordPress is a free and open-source content management system written in PHP and paired with a MySQL or MariaDB database. (MariaDB in this case)

- **Port:** 80

### Redis

Redis is an open-source, in-memory data structure store, used as a database, cache, and message broker.

- **Port:** 6379

### Adminer

Adminer is a database management tool that allows managing databases, tables, columns, relations, indexes, users, permissions, etc.

- **Port:** 8080

### FTP

FTP is a standard network protocol used for the transfer of computer files between a client and server on a computer network.

- **Port:** 21

### Certbot

Certbot is a free, open-source software tool for automatically using Let's Encrypt certificates on manually-administrated websites to enable HTTPS.

- **Port:** N/A

## How to run

execute the following command:

```bash
make
```