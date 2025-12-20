#!/bin/bash

#CLI
#https://developer.wordpress.org/cli/commands/
#WP_CONFIG
#https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
#https://blog.o2switch.fr/configurer-wp-config-php-wordpress/
#_SERVER[]
#https://www.php.net/manual/en/reserved.variables.server.php
#https://www.conseil-webmaster.com/formation/php/09-variables-serveur-php.php

set -e

: "${SQL_SERVICE:?Need SQL_SERVICE}"
: "${MARIADB_PORT:?Need MARIADB_PORT}"
: "${DOMAIN_NAME:?Need DOMAIN_NAME}"
#MYSQL
: "${MYSQL_DB_NAME:?Need MYSQL_DB_NAME}"
: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:?Need MYSQL_ROOT_PASSWORD}"
#WP 
: "${WP_TITLE_SITE:?Need WP_TITLE_SITE}"
: "${WP_ADMIN_USER:?Need WP_ADMIN_USER}"
: "${WP_ADMIN_PASSWORD:?Need WP_ADMIN_PASSWORD}"
: "${WP_ADMIN_EMAIL:?Need WP_ADMIN_EMAIL}"
: "${WP_USER:?Need WP_USER}"
: "${WP_USER_EMAIL:?Need WP_USER_EMAIL}"
: "${WP_USER_PASSWORD:?Need WP_USER_PASSWORD}"

WP_PATH="/var/www/wordpress"
DOWNLOAD_URL="https://wordpress.org/latest.tar.gz"

#~~~~~~~~~~~~~~~~~~~~~FUNCTION WAIT DB~~~~~~~~~~~~~~~~~~~~~
#while the echo fail(return 1), sleep and retry, this solution is cheaper but you don't test to connect your user, you juste test connection
wait_db(){
  #here /dev/tcp/mariadb/3306 is not a directory, it's a bash functionnality, it allow to send via TCP an empty echo to mariadb(using my service name of Yamel) on the port 3306
  while ! (echo > /dev/tcp/$SQL_SERVICE/3306) 2>/dev/null; do
      echo "[$(date)] => Wordpress awaiting for mariadb..."
      sleep 1
  done
  echo "[$(date)] => Successfully reached mariadb."
}

#~~~~~~~~~~~~~~~~~~~~~INSTALL WORDPRESS~~~~~~~~~~~~~~~~~~~~~


# Install Wordpress if wp-load(wordpress core file) is not found, give right to www-data user
if [ ! -f "$WP_PATH/wp-load.php" ]; then
  echo "Downloading WordPress..."
  curl -fsSL "$DOWNLOAD_URL" -o /tmp/wordpress.tar.gz
  tar -xzf /tmp/wordpress.tar.gz -C /tmp
  mv /tmp/wordpress/* "$WP_PATH"/
  rm -rf /tmp/wordpress /tmp/wordpress.tar.gz
  chown -R www-data:www-data "$WP_PATH"
  chmod -R 755 "$WP_PATH"
fi

#~~~~~~~~~~~~~~~~~~~~~WAITING DB~~~~~~~~~~~~~~~~~~~~~

wait_db

#~~~~~~~~~~~~~~~~~~~~~WP_CONFIG.PHP SETUP~~~~~~~~~~~~~~~~~~~~~
#This is an alternative, i did at start thinking we can't use wp-cli, it is more generic and precise, but way more complicated and not go well over time
# If wp-config.php doesn't exist(first start) create it
#if [ ! -f "$WP_PATH/wp-config.php" ]; then
#  echo "Generating wp-config.php..."
#If none of those already exists(via .env)generate new random key for cookies and SALT
#  echo "Generating keys..."
#: ${AUTH_KEY:=$(openssl rand -base64 32)}
#: ${SECURE_AUTH_KEY:=$(openssl rand -base64 32)}
#: ${LOGGED_IN_KEY:=$(openssl rand -base64 32)}
#: ${NONCE_KEY:=$(openssl rand -base64 32)}
#: ${AUTH_SALT:=$(openssl rand -base64 32)}
#: ${SECURE_AUTH_SALT:=$(openssl rand -base64 32)}
#: ${LOGGED_IN_SALT:=$(openssl rand -base64 32)}
#: ${NONCE_SALT:=$(openssl rand -base64 32)}
#: ${table_prefix:="\$table_prefix"}
#: ${_SERVER:="\$_SERVER"}

#export MYSQL_DB_NAME MYSQL_USER_NAME MYSQL_USER_PASSWORD MARIADB_PORT
#export AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT
#export table_prefix _SERVER DOMAIN_NAME

#  echo "Keys generated"

#substitute var in wp-config.php.template into a new f
#  echo "Substituting wp-config.php.template to wp-config.php..."
#  envsubst < "$WP_PATH/wp-config.php.template" > "$WP_PATH/wp-config.php"
#  echo "Substitution done"
#give rights to www-data user over this directory (default internet user fo security)
#  chown -R www-data:www-data "$WP_PATH"/wp-config.php
#  chmod 640 "$WP_PATH"/wp-config.php
#  echo "wp-config.php generated"
#fi

if [ ! -f "$WP_PATH/wp-config.php" ]; then
  echo "Generating wp-config.php..."
   su -s /bin/bash www-data -c "wp config create \
  --dbname='${MYSQL_DB_NAME}' \
  --dbuser='${MYSQL_USER_NAME}' \
  --dbpass='${MYSQL_USER_PASSWORD}' \
  --dbhost='${SQL_SERVICE}:${MARIADB_PORT}' \
  --dbprefix=wp_ \
  --skip-check
  --path='$WP_PATH'"
   su -s /bin/bash www-data -c "wp config set WP_HOME 'https://${DOMAIN_NAME}' --type=constant --path='$WP_PATH'"
   su -s /bin/bash www-data -c "wp config set WP_SITEURL 'https://${DOMAIN_NAME}' --type=constant --path='$WP_PATH'"
   su -s /bin/bash www-data -c "wp config set DISALLOW_FILE_EDIT true --type=constant --path='$WP_PATH'"
   su -s /bin/bash www-data -c "wp config set DISALLOW_FILE_MODS true --type=constant --path='$WP_PATH'"
   su -s /bin/bash www-data -c "wp config set FS_METHOD 'direct' --type=constant --path='$WP_PATH'"
   echo "wp-config.php generated"
fi

#~~~~~~~~~~~~~~~~~WWW_DATA OWNAGE INSURANCE~~~~~~~
if [ -f "$WP_PATH/wp-config.php" ]; then
  chown www-data:www-data "$WP_PATH/wp-config.php"
  chmod 640 "$WP_PATH/wp-config.php"
  echo "wp-config.php user ownage set"
fi

#~~~~~~~~~~~~~~~~~ INSTALL WP WITH WP-CLI ~~~~~~~
echo "Installing WordPress..."
if ! su -s /bin/bash www-data -c "wp core is-installed --path='$WP_PATH'"; then
    su -s /bin/bash www-data -c "wp core install \
  --url='$DOMAIN_NAME' \
  --title='${WP_TITLE_SITE}' \
  --admin_user='$WP_ADMIN_USER' \
  --admin_password='$WP_ADMIN_PASSWORD' \
  --admin_email='$WP_ADMIN_EMAIL' \
  --path='$WP_PATH' \
  --skip-email"
fi

echo "WordPress installed successfully."

echo "Add subscriber user..."
if ! su -s /bin/bash www-data -c "wp user get '$WP_USER' --path='$WP_PATH'" >/dev/null 2>&1; then
    su -s /bin/bash www-data -c "wp user create \
  '$WP_USER' '$WP_USER_EMAIL' \
  --user_pass='$WP_USER_PASSWORD' \
  --role=subscriber \
  --path='$WP_PATH'"
fi

echo "User added successfully"

exec php-fpm8.2 --nodaemonize
