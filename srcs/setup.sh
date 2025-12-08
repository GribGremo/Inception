#!/bin/bash

#~~~~~~~~~~~~~~~~~DEPENDANCIES INSTALLATION~~~~~~~~~~~~~~~~~
#Check dependancies installed
for cmd in openssl docker "docker compose"; do
    if ! command -v $cmd >/dev/null 2>&1; then
        #Check sudo mode
        if [ "$EUID" -ne 0 ]; then
            echo "Error : $cmd not installed. Restart script as sudo"
            exit 1
        else
            echo "Installing $cmd..."
            if [[ "$cmd" == "docker" || "$cmd" == "docker-compose" ]]; then
            	sudo ../docker_install.sh 
            else
            	apt-get update && apt-get install -y $cmd
	    fi
            echo "$cmd installed."
        fi
    fi
done

#~~~~~~~~~~~~~~~~~CREATION .ENV~~~~~~~~~~~~~~~~~
#Var declaration
MYSQL_DB_NAME=inception_base;
MYSQL_USER_NAME=sylabbe;
MYSQL_USER_PASSWORD=sylabbe1669; #$(openssl rand -hex 16);
MYSQL_ROOT_PASSWORD=root;

DOMAIN_NAME=sylabbe.42.fr;
MARIADB_PORT=3306;

SQL_SERVICE=mariadb;
PHP_SERVICE=wordpress;
SRV_SERVICE=nginx;
#create .env
cp .env.example .env
sed -i "s/^MYSQL_DB_NAME=.*/MYSQL_DB_NAME=${MYSQL_DB_NAME}/" .env
sed -i "s/^MYSQL_USER_NAME=.*/MYSQL_USER_NAME=${MYSQL_USER_NAME}/" .env
sed -i "s/^MYSQL_USER_PASSWORD=.*/MYSQL_USER_PASSWORD=${MYSQL_USER_PASSWORD}/" .env
sed -i "s/^DOMAIN_NAME=.*/DOMAIN_NAME=${DOMAIN_NAME}/" .env
sed -i "s/^MARIADB_PORT=.*/MARIADB_PORT=${MARIADB_PORT}/" .env
sed -i "s/^SQL_SERVICE=.*/SQL_SERVICE=${SQL_SERVICE}/" .env
sed -i "s/^PHP_SERVICE=.*/PHP_SERVICE=${PHP_SERVICE}/" .env
sed -i "s/^SRV_SERVICE=.*/SRV_SERVICE=${SRV_SERVICE}/" .env
sed -i "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}/" .env
#~~~~~~~~~~~~~~~~~CREATION SSL CERTIFICATES~~~~~~~~~~~~~~~~~
#create directory for certs
mkdir -p ./nginx/certs

#generate SSL certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ./nginx/certs/sylabbe.42.fr.key \
    -out ./nginx/certs/sylabbe.42.fr.crt \
    -subj "/C=FR/ST=Charente/L=Angouleme/O=42/OU=Student/CN=sylabbe.42.fr"
