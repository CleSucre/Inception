# makefile for docker-compose files

# Variables
COMPOSE_FILE = docker-compose.yml

# Commands
up:
	docker-compose -f $(COMPOSE_FILE) up -d

build:
	docker-compose -f $(COMPOSE_FILE) --build

dev:
	docker-compose -f $(COMPOSE_FILE) up --build

down:
	docker-compose -f $(COMPOSE_FILE) down

clean:
	docker-compose -f $(COMPOSE_FILE) down --volumes --remove-orphans
