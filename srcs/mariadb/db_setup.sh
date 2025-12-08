#!/bin/bash

#Mechanism to prevent script to continue in case something return an error during script
set -e

# Variables attendues via env_file (.env), return an error if missing or not init

#: "${MYSQL_DB_NAME:?Need MYSQL_DB_NAME}"
#: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
#: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"
#: "${MYSQL_ROOT_PASSWORD:-root}"   # optionnel, default si absent

#env
# only run if DB not yet initialized
echo "SCRIPT DB_SETUP"
if [ ! -d "/var/lib/mysql/${MYSQL_DB_NAME}" ]; then
    echo "DATABASE CREATION..."
    mysqld_safe --skip-networking &
    sleep 5  # attendre que le serveur démarre
    mysql -u root -e "CREATE DATABASE ${MYSQL_DB_NAME};"
    mysql -u root -e "CREATE USER '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB_NAME}.* TO '${MYSQL_USER_NAME}'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
fi

while [ -e /run/mysqld/mysqld.sock ]; do
    sleep 1
done


exec mysqld
