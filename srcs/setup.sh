#!/bin/bash

PATH="./srcs"

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
            	sudo $(PATH)/docker_install.sh 
            else
            	apt-get update && apt-get install -y $cmd
	    fi
            echo "$cmd installed."
        fi
    fi
done

#~~~~~~~~~~~~~~~~~CREATION .ENV~~~~~~~~~~~~~~~~~
#Var declaration
echo "~~~~~.env~~~~~"
if ! [ -f $(PATH)/.env ]; then
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
    cp $(PATH)/.env.example $(PATH)/.env
    echo "Copy .env.example to .env"

    sed -i "s/^MYSQL_DB_NAME=.*/MYSQL_DB_NAME=${MYSQL_DB_NAME}/" $(PATH)/.env
    sed -i "s/^MYSQL_USER_NAME=.*/MYSQL_USER_NAME=${MYSQL_USER_NAME}/" $(PATH)/.env
    sed -i "s/^MYSQL_USER_PASSWORD=.*/MYSQL_USER_PASSWORD=${MYSQL_USER_PASSWORD}/" $(PATH)/.env
    sed -i "s/^DOMAIN_NAME=.*/DOMAIN_NAME=${DOMAIN_NAME}/" $(PATH)/.env
    sed -i "s/^MARIADB_PORT=.*/MARIADB_PORT=${MARIADB_PORT}/" $(PATH)/.env
    sed -i "s/^SQL_SERVICE=.*/SQL_SERVICE=${SQL_SERVICE}/" $(PATH)/.env
    sed -i "s/^PHP_SERVICE=.*/PHP_SERVICE=${PHP_SERVICE}/" $(PATH)/.env
    sed -i "s/^SRV_SERVICE=.*/SRV_SERVICE=${SRV_SERVICE}/" $(PATH)/.env
    sed -i "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}/" $(PATH)/.env
    echo "Variable substitution made"
    echo ".env created"
else
    echo ".env already exists"
fi
#~~~~~~~~~~~~~~~~~CREATION SSL CERTIFICATES~~~~~~~~~~~~~~~~~
#create directory for certs
echo "~~~~~SSL certs~~~~~"
if ! [-d ./nginx/certs]; then
    mkdir -p ./nginx/certs
    echo "./nginx/certs directory created"
    #generate SSL certs
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ./nginx/certs/sylabbe.42.fr.key \
        -out ./nginx/certs/sylabbe.42.fr.crt \
        -subj "/C=FR/ST=Charente/L=Angouleme/O=42/OU=Student/CN=sylabbe.42.fr"
    echo "SSL certs created"
else
    echo "SSL certs already exists"
fi
