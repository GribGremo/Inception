# **************************************************************************** #
#                                   VARIABLES                                   #
# **************************************************************************** #

SRC_PATH = ./srcs

STP_FILE = scripts_VM/setup.sh
DCK_CMP = docker-compose.yml

DOCKER_COMPOSE = docker compose -f $(SRC_PATH)/$(DCK_CMP) -p inception
VOLUMES = srcs_wordpress_db srcs_wordpress_files
SETUP_SCRIPT = $(SRC_PATH)/$(STP_FILE)

# **************************************************************************** #
#                                   RULES                                      #
# **************************************************************************** #

all: setup up

setup:
	@echo "Checking environment..."
	@bash $(SETUP_SCRIPT)

up:
	@echo "[+] Starting containers..."
	@$(DOCKER_COMPOSE) up -d --build

build:
	@echo "[+] Building images..."
	@$(DOCKER_COMPOSE) build

down:
	@echo "[+] Stopping and removing containers..."
	@$(DOCKER_COMPOSE) down

clean: down
	@echo "[+] Removing orphan containers..."
	@docker system prune -f --volumes

fclean: clean
	@echo "[+] Removing all volumes and images related to the project..."
	$(DOCKER_COMPOSE) down --volumes --rmi all --remove-orphans
	@docker system prune -f --volumes
	docker volume rm $(VOLUMES) 2>/dev/null || true

re: fclean all

.PHONY: all setup up build down clean fclean re
