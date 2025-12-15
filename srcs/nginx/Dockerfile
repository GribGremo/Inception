#Definir la base de mon image
FROM debian:bookworm

#Setup ce que je veux en plus de cette base(a revoir)
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

#Copier fichier config server#voir nom de fichier
#COPY ./conf/server.conf /etc/nginx/conf.d/server.conf
COPY ./conf/sylabbe.42.fr.conf /etc/nginx/sites-available/sylabbe.42.fr.conf

#Create certs
COPY SSL_gen.sh /usr/local/bin/SSL_gen.sh
RUN chmod +x /usr/local/bin/SSL_gen.sh && \
    /usr/local/bin/SSL_gen.sh

#Create logical link between sites-available and sites-enabled
RUN ln -s /etc/nginx/sites-available/sylabbe.42.fr.conf /etc/nginx/sites-enabled/sylabbe.42.fr.conf

#ouvre le port 443
EXPOSE 443

#probleme potentiel de signal il faudrait faire un script si j'ai compris ou utiliser tini mais pas le droit de l'installer
CMD [ "nginx", "-g", "daemon off;" ]

