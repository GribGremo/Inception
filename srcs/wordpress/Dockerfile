#Definir la base de mon image
FROM debian:bookworm

#Setup ce que je veux en plus de cette base(a revoir)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    mariadb-client \
    php8.2-fpm php8.2-mysql php8.2-curl php8.2-xml php8.2-mbstring php8.2-zip php8.2-gd unzip \
    && apt-get clear \
    && rm -rf /var/lib/apt/lists/*

#www-data est un compte sur ddebian ubuntu qui sert exclusivement a executer nginx apache php-fpm
RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

#Copier fichier config server#voir nom de fichier
#COPY ./conf/server.conf /etc/nginx/conf.d/server.conf
COPY php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY wp_setup.sh /usr/local/bin/wp_setup.sh


RUN chmod +x /usr/local/bin/entrypoint.sh

#ouvre le port 9000
#EXPOSE 9000

#probleme potentiel de signal il faudrait faire un script si j'ai compris ou utiliser tini mais pas le droit de l'installer
ENTRYPOINT [ "/usr/local/bin/wp_setup.sh" ]
CMD [ "php-fpm8.2", "--nodaemonize" ]

#RUN sont des commandes utilises a la creation de l'image(cette creation se fait avec docker build, c'est un peu l'equivalent d'une compilation) du cuop RUN c'est pour setupt des choses que tu veux globalement fixe pour ton serveur , ou du moins un etat d'origine donne
#CMD lance un executable, ca pourrait meme etre un script personnalise, la difference c'est que les commandes dans ce script seraient repetes a chaue fois que tu relances ton container(un peu comme relancer un executable) ici

#Du coup il faudrait un fichier de config pour le site en soi, un fichier de config pour tous les sites, de ssnippets pour eviter de repeter des blocs communs sur plusieurs conf(certs par exemple), tout ca seront include dans le fichier d'ossature de configuration de nginx, nginx.conf.
#potentiel snippet pour certs par exemple