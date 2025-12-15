#!/bin/bash

set -e

: "${MYSQL_DB_NAME:?Need MYSQL_DB_NAME}"
: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:-root}"   # optionnel, default si absent
: "${MARIADB_PORT:?Need MARIADB_PORT}"
: "${SQL_SERVICE:?Need SQL_SERVICE}"


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

# If wp-config.php doesn't exist(first start) create it
#if [ ! -f "$WP_PATH/wp-config.php" ]; then
  echo "Generating wp-config.php..."
#If none of those already exists(via .env)generate new random key for cookies and SALT
  echo "Generating keys..."
: ${AUTH_KEY:=$(openssl rand -base64 32)}
: ${SECURE_AUTH_KEY:=$(openssl rand -base64 32)}
: ${LOGGED_IN_KEY:=$(openssl rand -base64 32)}
: ${NONCE_KEY:=$(openssl rand -base64 32)}
: ${AUTH_SALT:=$(openssl rand -base64 32)}
: ${SECURE_AUTH_SALT:=$(openssl rand -base64 32)}
: ${LOGGED_IN_SALT:=$(openssl rand -base64 32)}
: ${NONCE_SALT:=$(openssl rand -base64 32)}
: ${table_prefix:="\$table_prefix"}
: ${_SERVER:="\$_SERVER"}

export MYSQL_DB_NAME MYSQL_USER_NAME MYSQL_USER_PASSWORD MARIADB_PORT
export AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT
export table_prefix _SERVER

  echo "Keys generated"

#substitute var in wp-config.php.template into a new f
  echo "Substituting wp-config.php.template to wp-config.php..."
  envsubst < "$WP_PATH/wp-config.php.template" > "$WP_PATH/wp-config.php"
  echo "Substitution done"
#give rights to www-data user over this directory (default internet user fo security)
  chown -R www-data:www-data "$WP_PATH"/wp-config.php
  chmod 640 "$WP_PATH"/wp-config.php
  echo "wp-config.php generated"
#fi

#alternative solution: this command will generate almost evrything by itself, but you have more control over you configuration file by doing it yourself, plus no packet wp-cli necessary
#wp config create \
#  --dbname=wordpress \
#  --dbuser=wp_user \
#  --dbpass=superpass \
#  --dbhost=mariadb \
#  --dbprefix=wp_ \
#  --skip-check

#~~~~~~~~~~~~~~~~~ INSTALL WP WITH WP-CLI ~~~~~~~
#echo "Installing WordPress..."
#su -s /bin/bash www-data -c "wp core install \
#  --url='$WP_SITEURL' \
#  --title='Mon Site' \
#  --admin_user='$WP_ADMIN_USER' \
#  --admin_password='$WP_ADMIN_PASSWORD' \
#  --admin_email='$WP_ADMIN_EMAIL' \
#  --path='$WP_PATH' \
#  --skip-email"

#echo "WordPress installed successfully."


exec php-fpm8.2 --nodaemonize
