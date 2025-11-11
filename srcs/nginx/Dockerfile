#Definir la base de mon image
FROM debian:bookworm

#Setup ce que je veux en plus de cette base(a revoir)
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

#Copier fichier config server#voir nom de fichier
COPY ./conf/server.conf /etc/nginx/server.conf 
COPY ./conf/sylabbe.42.fr.conf /etc/nginx/conf.d/default.conf

#Creer dossier certs
RUN mkdir -p /etd/ssl/certs

#Copier certs
COPY ./certs/sylabbe.42.fr.crt /etc/sll/certs/
COPY ./certs/sylabbe.42.fr.key /etc/sll/certs/


#ouvre le port 443
EXPOSE 443

CMD
