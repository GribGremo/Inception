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

DOCKER_COMPOSE = docker compose -f ./srcs/docker-compose.yml
VOLUMES = /home/sylabbe/data/wordpress /home/sylabbe/data/mariadb
SETUP_SCRIPT = ./srcs/setup.sh

# **************************************************************************** #
#                                   RULES                                      #
# **************************************************************************** #

all: setup up

setup:
	@echo "[+] Checking environment..."
	@bash $(SETUP_SCRIPT)

up:
	@echo "$(GREEN)[+] Starting containers...$(NC)"
	@$(DOCKER_COMPOSE) up -d --build

build:
	@echo "$(GREEN)[+] Building images...$(NC)"
	@$(DOCKER_COMPOSE) build

down:
	@echo "$(YELLOW)[+] Stopping and removing containers...$(NC)"
	@$(DOCKER_COMPOSE) down

clean: down
	@echo "$(YELLOW)[+] Removing orphan containers...$(NC)"
	@docker system prune -f

fclean: clean
	@echo "$(RED)[+] Removing all volumes and images related to the project...$(NC)"
	@$(DOCKER_COMPOSE) down --volumes --rmi all
	@docker volume rm $(VOLUMES) 2>/dev/null || true

re: fclean all

.PHONY: all up build down clean fclean re
