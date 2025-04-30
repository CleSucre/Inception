# Makefile for docker-compose files

ifeq ($(OS), Windows_NT)
	DIRSEP	= \\
	RM = rmdir /s /q
else
	DIRSEP	= /
	RM = rm -rf
endif

# Variables
COMPOSE_FILE = docker-compose.yml

# Commands
up:
	docker-compose -f $(COMPOSE_FILE) up -d

build:
	docker-compose -f $(COMPOSE_FILE) build

logs:
	docker-compose -f $(COMPOSE_FILE) logs -f

dev:
	docker-compose -f $(COMPOSE_FILE) up --build

down:
	docker-compose -f $(COMPOSE_FILE) down

clean:
	docker-compose -f $(COMPOSE_FILE) down --volumes --remove-orphans
	$(RM) $(DIRSEP)home$(DIRSEP)julthoma
	$(RM) .$(DIRSEP)tmp

.PHONY: up build logs dev down clean
