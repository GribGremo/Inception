#!/bin/bash

#Mechanism to prevent script to continue in case something return an error during script
set -e

# Variables attendues via env_file (.env), return an error if missing or not init

: "${MYSQL_DB_NAME:?Need MYSQL_DB_NAME}"
: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:-root}"   # optionnel, default si absent

#env
# only run if DB not yet initialized
if [ ! -d "/var/lib/mysql/${MYSQL_DB_NAME}" ]; then
    wget https://wordpress.org/latest.tar.gz
	tar -xzvf latest.tar.gz
fi

exec 
