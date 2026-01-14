# USER_DOC

## - 📌 Services
Differents services are provided in this project:
    - NGINX : service commited to exchange between clients and servers(back) used as reverse proxy. It grants secure communication through https.
    - WORDPRESS : service commited to store and transmit web content. Some of it will be containe in Mariadb.
    - MARIADB : service commited to stock wordpress content in this subject, anser SQL request from wordpress.

## - 📌 Run
To start this project, you can use different commands in git repository you downloaded:
    - ``make`` : To start the project from scratch
    - ``make build`` : To construct images only
    - ``make up`` : To construct container from images
    - ``make down`` : To stop and erase container
    - ``make clean`` : To clean images and containers
    - ``make fclean`` : To clean deeply
    You will basically use "make" to start project and "make fclean" to stop it and clean.

## 📌 Access
To access the site you can use two URL
    - https://localhost/
    - https://sylabbe.42.fr
If you start it with http, it will redirect you in https.
To access the administration panel, you will add wp-admin to those urls
    - https://sylabbe.42.fr/wp-admin/

## - 📌 Credentials
SSL certificates are generated in NGINX container via SSL_gen.sh.
All password are generated in setup.sh script via openssl. You can see them in .env file, it is generated using .env.example template and modify in setup.sh.

## - 📌 Check
To check that services are running correctly, you can use:
    - ``docker ps``
It will show you all containers are started and their status via healthcheck.


