#!/bin/bash

set -e

SRC_PATH="./srcs"

#~~~~~~~~~~~~~~~~~DEPENDANCIES INSTALLATION~~~~~~~~~~~~~~~~~
#Check dependancies installed

if ! command -v openssl >/dev/null 2>&1; then
    echo "Error : openssl not installed."
    exit 1
fi
if ! command -v docker >/dev/null 2>&1; then
    echo "Error : docker not installed."
    exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
    echo "Error: docker compose is not available."
    exit 1
fi
echo "Docker ready to use"

#~~~~~~~~~~~~~~~~~CREATION .ENV~~~~~~~~~~~~~~~~~
#Var declaration
echo "~~~~~.env~~~~~"
if  [ ! -f ${SRC_PATH}/.env ]; then
    #MYSQL VARIABLES
    MYSQL_DB_NAME=inception_base
    MYSQL_USER_NAME=sylabbe
    MYSQL_USER_PASSWORD=$(openssl rand -hex 16);
    MYSQL_ROOT_PASSWORD=$(openssl rand -hex 16);
    
    #WORDPRESS VARIABLES
    WP_TITLE_SITE=Inception
    WP_ADMIN_USER=sylabbe
    WP_ADMIN_PASSWORD=$(openssl rand -hex 16);
    WP_ADMIN_EMAIL=labbesylvainpro@gmail.com
    WP_USER=toto
    WP_USER_PASSWORD=$(openssl rand -hex 16);
    WP_USER_EMAIL=toto@gmail.com
    
    #SERVER
    DOMAIN_NAME=sylabbe.42.fr
    MARIADB_PORT=3306
    
    #SERVICES
    SQL_SERVICE=mariadb
    PHP_SERVICE=wordpress
    SRV_SERVICE=nginx

    #create .env
    cp ${SRC_PATH}/.env.example ${SRC_PATH}/.env
    echo "Copy .env.example to .env"

    sed -i "s/^MYSQL_DB_NAME=.*/MYSQL_DB_NAME=${MYSQL_DB_NAME}/" ${SRC_PATH}/.env
    sed -i "s/^MYSQL_USER_NAME=.*/MYSQL_USER_NAME=${MYSQL_USER_NAME}/" ${SRC_PATH}/.env
    sed -i "s/^MYSQL_USER_PASSWORD=.*/MYSQL_USER_PASSWORD=${MYSQL_USER_PASSWORD}/" ${SRC_PATH}/.env
    sed -i "s/^DOMAIN_NAME=.*/DOMAIN_NAME=${DOMAIN_NAME}/" ${SRC_PATH}/.env
    sed -i "s/^MARIADB_PORT=.*/MARIADB_PORT=${MARIADB_PORT}/" ${SRC_PATH}/.env
    sed -i "s/^SQL_SERVICE=.*/SQL_SERVICE=${SQL_SERVICE}/" ${SRC_PATH}/.env
    sed -i "s/^PHP_SERVICE=.*/PHP_SERVICE=${PHP_SERVICE}/" ${SRC_PATH}/.env
    sed -i "s/^SRV_SERVICE=.*/SRV_SERVICE=${SRV_SERVICE}/" ${SRC_PATH}/.env
    sed -i "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}/" ${SRC_PATH}/.env

    sed -i "s/^WP_TITLE_SITE=.*/WP_TITLE_SITE=${WP_TITLE_SITE}/" ${SRC_PATH}/.env
    sed -i "s/^WP_ADMIN_USER=.*/WP_ADMIN_USER=${WP_ADMIN_USER}/" ${SRC_PATH}/.env
    sed -i "s/^WP_ADMIN_PASSWORD=.*/WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD}/" ${SRC_PATH}/.env
    sed -i "s/^WP_ADMIN_EMAIL=.*/WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL}/" ${SRC_PATH}/.env
    sed -i "s/^WP_USER=.*/WP_USER=${WP_USER}/" ${SRC_PATH}/.env  
    sed -i "s/^WP_USER_PASSWORD=.*/WP_USER_PASSWORD=${WP_USER_PASSWORD}/" ${SRC_PATH}/.env
    sed -i "s/^WP_USER_EMAIL=.*/WP_USER_EMAIL=${WP_USER_EMAIL}/" ${SRC_PATH}/.env
    echo "Variable substitution made"
    echo ".env created"
else
    echo ".env already exists"
fi
