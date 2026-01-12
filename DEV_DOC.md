# DEV_DOC

## 📌 Set-up

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
    On git directory:
    - Give right to script: ``chmod +x ./srcs/scipts_VM/docker_install.sh``
    - Execute script: ``sudo ./srcs/scipts_VM/docker_install.sh``
    (This script will erase any previous version of docker totally)
    - ``sudo systemctl status docker``
    (It will ensure docker is ready)
- ### Add user to docker group
    - ``usermod -aG docker sylabbe``
      (optional)

- ## Build and lauch
    You can use those different makefile command to manage the project:
    - ``make`` : To start the project from scratch
    - ``make build`` : To construct images only
    - ``make up`` : To construct container from images
    - ``make down`` : To stop and erase container
    - ``make clean`` : To clean images and containers
    - ``make fclean`` : To clean deeply

    You can also use some docker compose commands separately:
    - ``docker compose up`` : To start containers
    - ``docker compose up -d`` : To start containers in back
    - ``docker compose down`` : To stop anddelete containers
    - ``docker compose stop`` : To stop containers
    - ``docker compose start`` : To start containers (after stop)
    - ``docker compose restart`` : To restart containers
    - ``docker compose build`` : To build images
    - ``docker compose logs`` : To get logs
    - ``docker compose ps`` : To see containers handle by compose
    - ``docker compose exec "service_name" bash`` : To open a shell in "service_name"

- ## Docker commands
    You have multiple docker commands to manage containers:
    - ### Images
        - ``docker images`` : To list all images
        - ``docker build -t "image_name" .`` : To build container from "image_name"
        - ``docker rmi <image>`` : To delete an image
    
    - ### Containers
        - ``docker ps`` : To list containers
        - ``docker run -it "image_name"`` : To run a container from an image
        - ``docker stop "id"`` : To stop a container
        - ``docker start "id"`` : To start a container
        - ``docker restart "id"`` : To restart a container
        - ``docker rm "id"`` : To remove a container "id"
        - ``docker logs "id"`` : To print logs from a container
        - ``docker exec -it "id" bash`` : To open a shell on container "id"

    - ### Networks
        - ``docker network ls``  : To list all docker networks
        - ``docker network inspect monreseau`` : To inspect a network

    - ### Volumes
        - ``docker volume ls`` : To list all volumes
        - ``docker volume inspect "my_volume"`` : To inspect "my_volume"
        - ``docker volume rm "my_volume"`` : To delete "my_volume"
        - ``docker volume prune`` : To clean all unused volumes

- ## Volumes
    As required in the subject, data are stored at "/home/sylabbe/"
    Two volumes have been created:
        - wordpress_db link "/home/sylabbe/mariadb" at "/var/lib/mysql" in mariadb container
        - wordpress_files link "/home/sylabbe/wordpress" at "/var/www/wordpress" in wordpress container
    /home/sylabbe is built on my Virtual Machine and will remain even if containers are down