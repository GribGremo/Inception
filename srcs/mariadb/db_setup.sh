#!/bin/bash

#Mechanism to prevent script to continue in case something return an error during script
set -e

# Variables attendues via env_file (.env), return an error if missing or not init
: "${MYSQL_DB_NAME:?Need MYSQL_DB_NAME}"
: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:-root}"   # optionnel, default si absent

# only run if DB not yet initialized
if [ ! -d "/var/lib/mysql/${MYSQL_DB_NAME}" ]; then
    mysqld_safe --skip-networking &
    sleep 5  # attendre que le serveur démarre
    mysql -e "CREATE DATABASE ${MYSQL_DB_NAME};"
    mysql -e "CREATE USER '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB_NAME}.* TO '${MYSQL_USER_NAME}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"
    killall mysqld
fi

exec mysqld_safe