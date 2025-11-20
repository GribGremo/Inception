#!/bin/bash

service mariadb start

mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB_NAME}.* TO '${MYSQL_USER_NAME}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

service mariadb stop

exec mysqld_safe