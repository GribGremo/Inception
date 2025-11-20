#Definir la base de mon image
FROM debian:bookworm

#Setup ce que je veux en plus de cette base(a revoir)
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*
    
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306

#probleme potentiel de signal il faudrait faire un script si j'ai compris ou utiliser tini mais pas le droit de l'installer
CMD [ "db_setup.sh" ]