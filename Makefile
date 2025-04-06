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
	docker-compose -f $(COMPOSE_FILE) --build

dev:
	docker-compose -f $(COMPOSE_FILE) up --build

down:
	docker-compose -f $(COMPOSE_FILE) down

clean:
	docker-compose -f $(COMPOSE_FILE) down --volumes --remove-orphans
	$(RM) .$(DIRSEP)srcs$(DIRSEP)nginx$(DIRSEP)logs$(DIRSEP)
	$(RM) .$(DIRSEP)srcs$(DIRSEP)nginx$(DIRSEP)certs$(DIRSEP)
	$(RM) .$(DIRSEP)srcs$(DIRSEP)wordpress$(DIRSEP)html$(DIRSEP)
	$(RM) .$(DIRSEP)srcs$(DIRSEP)mariadb$(DIRSEP)data$(DIRSEP)
	$(RM) .$(DIRSEP)srcs$(DIRSEP)ftp$(DIRSEP)data$(DIRSEP)

.PHONY: up build dev down clean