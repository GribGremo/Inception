#!/bin/bash

#Mechanism to prevent script to continue in case something return an error during script
set -e

# Awaited variables, return error if empty

: "${MYSQL_DB_NAME:?Need MYSQL_DB_NAME}"
: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:?Need MYSQL_ROOT_PASSWORD}"

echo "SCRIPT DB_SETUP"

#~~~~~~~~~~~~~~~~Installing Mariadb~~~~~~~~~~~~~~~~
#This might be obsolete depending on OS and MariaDB version, but in case i prefer let it there, the initialisation is made at the first start of MariaDb apparently, no need to force install.
if [ ! -d "/var/lib/mysql" ]; then
     echo "Installing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

#~~~~~~~~~~~~~~~~Starting Mariadb Test~~~~~~~~~~~~~~~~
echo "Starting MariaDB Test..."
mysqld_safe --datadir=/var/lib/mysql &
until mysqladmin ping --silent; do
    echo "Waiting for MariaDB Test..."
    sleep 1
done

#~~~~~~~~~~~~~~~~Creating Database~~~~~~~~~~~~~~~~
#Check if DB exists
DB_EXISTS=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -N -e \
"SELECT 1 FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='$MYSQL_DB_NAME';")

if [ -z "$DB_EXISTS" ]; then
    echo "Creating Database and user..."
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};"
    mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB_NAME}.* TO '${MYSQL_USER_NAME}'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    echo "Database and user created successfully"
fi

#~~~~~~~~~~~~~~~~Stopping Mariadb Test~~~~~~~~~~~~~~~~
echo "Stopping MariaDB Test..."
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
while [ -e /run/mysqld/mysqld.sock ]; do
    sleep 1
done

#~~~~~~~~~~~~~~~~Starting Mariadb Server~~~~~~~~~~~~~~~~
echo "Starting MariaDB Server"
exec mysqld
