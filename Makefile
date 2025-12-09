# **************************************************************************** #
#                                   COLORS                                     #
# **************************************************************************** #

GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m

# **************************************************************************** #
#                                   COMMANDS                                   #
# **************************************************************************** #

SRC_PATH = ./srcs
VLM_PATH = /home/sylabbe/data

VLM_MRDB = mariadb
VLM_WRDP = wordpress

STP_FILE = setup.sh
DCK_CMP = docker-compose.yml

DOCKER_COMPOSE = docker compose -f $(SRC_PATH)/$(DCK_CMP)
VOLUMES = $(VLM_PATH)/$(VLM_WRDP) $(VLM_PATH)/$(VLM_MRDB)
SETUP_SCRIPT = $(SRC_PATH)/$(STP_FILE)

# **************************************************************************** #
#                                   RULES                                      #
# **************************************************************************** #

all: setup up

setup:
	echo "[+] Checking environment..."
	bash $(SETUP_SCRIPT)

up:
	echo "[+] Starting containers...$(NC)"
	$(DOCKER_COMPOSE) up -d --build

build:
	echo "[+] Building images...$(NC)"
	$(DOCKER_COMPOSE) build

down:
	echo "[+] Stopping and removing containers...$(NC)"
	$(DOCKER_COMPOSE) down

clean: down
	echo "[+] Removing orphan containers...$(NC)"
	docker system prune -f

fclean: clean
	echo "[+] Removing all volumes and images related to the project...$(NC)"
	$(DOCKER_COMPOSE) down --volumes --rmi all
	docker volume rm $(VOLUMES) 2>/dev/null || true

re: fclean all

.PHONY: all up build down clean fclean re
