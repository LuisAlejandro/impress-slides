# Makefile

SHELL = sh -e

IMAGES = $(shell ls -1 images/ | grep "\.svg" | sed 's/\.svg//g')
CONVERT = $(shell which convert)
LIBSVG = $(shell find /usr/lib/ -maxdepth 1 -type d -iname "imagemagick-*")/modules-Q16/coders/svg.so
LIBRSVGBIN = $(shell which rsvg)

all: build

build: gen-img

gen-img: check-buildep clean-img

	@printf "Generando imágenes desde las fuentes [SVG > PNG] ["
	@for IMAGE in $(IMAGES); do \
		$(CONVERT) -background None images/$${IMAGE}.svg \
		    images/$${IMAGE}.png; \
		printf "."; \
	done;
	@printf "]\n"

clean-img:

	@printf "Cleaning generated images [PNG] ["
	@for IMAGE in $(IMAGES); do \
		rm -rf images/$${IMAGE}.png; \
		printf "."; \
	done;
	@printf "]\n"

check-buildep:

	@printf "Checking if we have convert ... "
	@if [ -z $(CONVERT) ]; then \
		echo "[ABSENT]"; \
		echo "If you are using Debian, Ubuntu or Canaima, please install the \"imagemagick\" package."; \
		exit 1; \
	fi
	@echo

	@printf "Checking if we have imagemagick svg support ... "
	@if [ -z $(LIBSVG) ]; then \
		echo "[ABSENT]"; \
		echo "If you are using Debian, Ubuntu or Canaima, please install the \"libmagickcore-extra\" package."; \
		exit 1; \
	fi
	@echo

	@printf "Checking if we have imagemagick rsvg support ... "
	@if [ -z $(LIBRSVGBIN) ]; then \
		echo "[ABSENT]"; \
		echo "If you are using Debian, Ubuntu or Canaima, please install the \"librsvg2-bin\" package."; \
		exit 1; \
	fi
	@echo
