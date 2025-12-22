_This project has been created as part of the 42 curriculum by sylabbe_

# INCEPTION

## 📌 Description

This project purpose is to initiate us to **dockers**, we implement different containers to isolate services from eachothers as a security matter. \
To set up those containers and combine them we use docker compose, volume, network and services are all defined in a docker-compose.yml. \
To initialise those containers, we use a dockerfile, bash scripts, and configuration files. \
All of this has to be made in a secure, persistent, automated way. \

This infrastructure have to contain:
- Nginx server with SSL certs
- PHP-FPM
- Wordpress
- MariaDB database
- Volumes
- Docker Network

## ⚙️ Instructions

- ### VM Creation:
    - Install any virtual machine assistant(Virtual box in our case)
    - Create VM:
        - VM Name: Inception42-Debian-Trixie
        - Choose VM directory
        - User Name: sylabbe (in our case login42, our volumes are supposed to be place in /home/login/data)
        - Password: sylabbe16
        - Hostname: Inception42-Debian-Trixie(default)
        - Domain name: myguest.virtualbox.org(default)(maybe change this)
        - Base memory: 4096
        - CPUs: 4
        - Disk size: 20 Gb
- ### VM Setup:
    - First add your user to sudo group
        - ``su -``
        - ``usermod -aG sudo sylabbe``
        - ``exit``
    - Update
        - ``sudo apt-get update``
    - Install essentials
        - ``sudo apt-get install -y build-essential``
    - Get project on github
        - ``wget https://github.com/GribGremo/Inception/archive/refs/heads/main.zip``
        - ``unzip main.zip``

- ### Setup DNS VM:
    - ``sudo vim /etc/hosts``
    - add: ``127.0.0.1 sylabbe.42.fr``

- ### Setup directories for volume
    - ``mkdir -p /home/<login>/data/wordpress``
    - ``mkdir -p /home/<login>/data/mariadb``
- ### Install Docker and docker compose
    - On git directory: ``sudo /srcs/scipts_VM/docker_install.sh``
    (This script will erase any previous version of docker totally)
    - ``sudo systemctl status docker``
    (It will ensure docker is ready)
- ### Add user to docker group
    - ``usermod -aG docker sylabbe``
      (optional)

After this your VM is ready to work, all you have to do is build the project, go to your repo and make.
- ``make`` : will build all the images and up the containers.
- ``make up``: will up the containers.
- ``make build``: build the containers images.
- ``make down``: down containers.
- ``make clean``: clean volumes.
- ``make fclean``: down containers, remove images, clean volumes.
- ``make re``: clean and rebuild
    
## 📚 Resources

- ### Global

    - Dockerfile
        - https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/
        - https://blog.stephane-robert.info/docs/conteneurs/images-conteneurs/ecrire-dockerfile/
    > Dockerfile is a file that will be used to set up your container.
    - docker-compose.yml
        - https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/docker-compose/
        - https://datascientest.com/docker-compose-tout-savoir
        - https://datascientest.com/docker-guide-complet
    > This file is here to make multiple containers, volumes, networks. It can load a .env file.  
    - .env
        - https://www.warp.dev/terminus/docker-compose-env-file
        - https://blog.openreplay.com/fr/fichiers-env-art-non-commettre-secrets/
    > .env will be here used to feed docker-compose.yml with all the information necessary in you project(name, port, password,...) \
    > ⚠️ This file can't be commit at anytime, it might contain sensible information as passwords, keys and more.

- ### MariaDB

    - 50-server.cnf
        - https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/configuring-mariadb/configuring-mariadb-with-option-files
        - https://mariadb.com/docs/server/server-management/variables-and-modes/full-list-of-mariadb-options-system-and-status-variables
        > Configuration file of Mariadb, define behavior at start, will centralize data necessary for your environment, security and performance.
        > It has multiple sections(server, mysqld, mysql, mysqladmin, ...) that will define how clients and mysql applications will behave.
    - db_setup.sh
        - https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-install-db
        - https://mariadb.com/docs/server/server-management/starting-and-stopping-mariadb/mariadbd-safe
        - https://mariadb.com/docs/server/clients-and-utilities/administrative-tools/mariadb-admin
        - https://mariadb.com/docs/server/clients-and-utilities/mariadb-client/mariadb-command-line-client
        > This script is used as entrypoint for our mariadb Dockerfile, Installing mysql, creating database and launching it, so it run continuously.

- ### Nginx

    - sylabbe.42.fr.conf
        - https://nginx.org/en/docs/beginners_guide.html
        - https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html
        > Configuration file for our nginx server, his role is to direct our request accordingly to port and path, define ssl certs, transmit php data via fastcgi.
    - SSL_gen.sh
        - https://kodekloud.com/blog/bash-getopts
        - https://www.linuxtricks.fr/wiki/openssl-creation-d-une-autorite-de-certification-interne-et-de-certificats-clients
        > This script has for objective to generate SSL certs. \
        > Client sent a request, server send back public key, client will create his own based on the one receive and send it back to server, client and server have a unique that only both of them know.

- ### Wordpress

    - php-fpm.conf www.conf
        - https://www.php.net/manual/en/install.fpm.configuration.php
        - https://www.formatux.fr/formatux-services/module-121-phpfpm/index.html
    - wp-config.php
        - https://developer.wordpress.org/advanced-administration/wordpress/wp-config
        - https://blog.o2switch.fr/configurer-wp-config-php-wordpress
    - wp_setup.php
        - https://developer.wordpress.org/cli/commands/

Concerning AI, this 42 project is probably the one where the usage of AI is relevant, all new technologies, with deep functionalities, having AI will definitely lead you in this project, if you have no idea where to start, just ask global roadmap, explain your project as accurately as possible, every notion or logic you don't get, ask for an explanation, correlate it with some officals docs and tutorials to attest that AI is accurate.
