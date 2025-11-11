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
COPY ./certs/sylabbe.42.fr.crt /etc/ssl/certs/
COPY ./certs/sylabbe.42.fr.key /etc/ssl/certs/

#ouvre le port 443
EXPOSE 443

#probleme potentiel de signal il faudrait faire un script si j'ai compris ou utiliser tini mais pas le droit de l'installer
CMD [ "nginx", "-g", "daemon off;" ]

#RUN sont des commandes utilises a la creation de l'image(cette creation se fait avec docker build, c'est un peu l'equivalent d'une compilation) du cuop RUN c'est pour setupt des choses que tu veux globalement fixe pour ton serveur , ou du moins un etat d'origine donne
#CMD lance un executable, ca pourrait meme etre un script personnalise, la difference c'est que les commandes dans ce script seraient repetes a chaue fois que tu relances ton container(un peu comme relancer un executable) ici