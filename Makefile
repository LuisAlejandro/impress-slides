#!/usr/bin/env make -f
# -*- makefile -*-

SHELL = bash -e
all_ps_hashes = $(shell docker ps -q)
img_hash = $(shell docker images -q luisalejandro/impress:latest)
exec_on_docker = docker compose \
	-p impress -f docker-compose.yml exec \
	--user impress app

image:
	@docker compose -p impress -f docker-compose.yml build \
		--build-arg UID=$(shell id -u) \
		--build-arg GID=$(shell id -g)

start:
	@if [ -z "$(img_hash)" ]; then\
		make image;\
	fi
	@docker compose -p impress -f docker-compose.yml up \
		--remove-orphans --no-build --detach

console: start
	@$(exec_on_docker) bash

new: start
	@$(exec_on_docker) mkdir -p new/css
	@$(exec_on_docker) cp mundo-interno-programador/css/styles.css new/css
	@$(exec_on_docker) touch new/new.rst
	@$(exec_on_docker) hovercraft --css new/css/styles.css \
		--skip-help new/new.rst new

stop:
	@docker-compose -p impress -f docker-compose.yml stop app

down:
	@docker-compose -p impress -f docker-compose.yml down \
		--remove-orphans

destroy:
	@echo
	@echo "WARNING!!!"
	@echo "This will stop and delete all containers, images and volumes related to this project."
	@echo
	@read -p "Press ctrl+c to abort or enter to continue." -n 1 -r
	@docker compose -p impress -f docker-compose.yml down \
		--rmi all --remove-orphans --volumes

cataplum:
	@echo
	@echo "WARNING!!!"
	@echo "This will stop and delete all containers, images and volumes present in your system."
	@echo
	@read -p "Press ctrl+c to abort or enter to continue." -n 1 -r
	@if [ -n "$(all_ps_hashes)" ]; then\
		docker kill $(shell docker ps -q);\
	fi
	@docker compose -p impress -f docker-compose.yml down \
		--rmi all --remove-orphans --volumes
	@docker system prune -a -f --volumes
