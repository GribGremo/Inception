#!/bin/bash

#~~~~~~~~~~~~~~~~~DEPENDANCIES INSTALLATION~~~~~~~~~~~~~~~~~
#Check dependancies installed
for cmd in openssl docker docker-compose; do
    if ! command -v $cmd >/dev/null 2>&1; then
        #Check sudo mode
        if [ "$EUID" -ne 0 ]; then
            echo "Error : $cmd not installed. Restart script as sudo"
            exit 1
        else
            echo "Installing $cmd..."
            apt-get update && apt-get install -y $cmd
            echo "$cmd installed."
        fi
    fi
done

#~~~~~~~~~~~~~~~~~CREATION .ENV~~~~~~~~~~~~~~~~~
#Var declaration
MYSQL_DB_NAME=inception_base;
MYSQL_USER_NAME=sylabbe;
MYSQL_USER_PASSWORD=sylabbe1669; #$(openssl rand -hex 16);
DOMAIN_NAME=sylabbe.42.fr;

#create .env
cp .env.example .env
sed -i "s/^MYSQL_DB_NAME=.*/MYSQL_DB_NAME=${MYSQL_DB_NAME}/" .env
sed -i "s/^MYSQL_USER_NAME=.*/MYSQL_USER_NAME=${MYSQL_USER_NAME}/" .env
sed -i "s/^MYSQL_USER_PASSWORD=.*/MYSQL_USER_PASSWORD=${MYSQL_USER_PASSWORD}/" .env
sed -i "s/^DOMAIN_NAME=.*/DOMAIN_NAME=${DOMAIN_NAME}/" .env


#~~~~~~~~~~~~~~~~~CREATION SSL CERTIFICATES~~~~~~~~~~~~~~~~~
#create directory for certs
mkdir -p ./nginx/certs

#generate SSL certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ./nginx/certs/sylabbe.42.fr.key \
    -out ./nginx/certs/sylabbe.42.fr.crt \
    -subj "/C=FR/ST=Charente/L=Angouleme/O=42/OU=Student/CN=sylabbe.42.fr"