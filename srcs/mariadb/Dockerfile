#Definir la base de mon image
FROM debian:bookworm

#Setup ce que je veux en plus de cette base(a revoir)
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY db_setup.sh /usr/local/bin/db_setup.sh
#EXPOSE 3306

#Just in case, we assure that the script is executable
RUN chmod +x /usr/local/bin/db_setup.sh
#probleme potentiel de signal il faudrait faire un script si j'ai compris ou utiliser tini mais pas le droit de l'installer

#Here it make an anonymous volume, but this is not really the purpose, we do that in case someone use this image indepently 
#from docker compose, in docker compose we have a direct volume and his emplacement, here we just warn that this emplacement
#has to be a persistent directory independent from container
VOLUME [ "/var/lib/mysql" ]

ENTRYPOINT [ "/usr/local/bin/db_setup.sh" ]
#Here CMD this will be used as default argument for the script used at ENTRYPPOINT
CMD [ "mysqld_safe" ]