FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    php8.2-fpm php8.2-mysql php8.2-curl php8.2-xml php8.2-mbstring php8.2-zip php8.2-gd unzip \
    && apt-get clear \
    && rm -rf /var/lib/apt/lists/*
#potential add     mariadb-client \

#www-data est un compte sur debian ubuntu qui sert exclusivement a executer nginx apache php-fpm
RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

WORKDIR /var/www/wordpress

COPY php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
#here i am supposedly in the workdir, so i can copu directly here
COPY wp-config.php.template wp-config.php.template
COPY wp_setup.sh /usr/local/bin/wp_setup.sh

RUN chmod +x /usr/local/bin/wp_setup.sh

#ouvre le port 9000
#EXPOSE 9000

#potentially add "/bin/bash" , before path, for TCP connection to test mariadb
ENTRYPOINT [ "/usr/local/bin/wp_setup.sh" ] 
CMD [ "php-fpm8.2", "--nodaemonize" ]
