# Variables
VENV_DIR = .venv
REQUIREMENTS = requirements.txt
REGISTRY = registry.github.com


PYTHON = $(VENV_DIR)/bin/python
PIP = $(VENV_DIR)/bin/pip
DOCKERFILE = Dockerfile
TAG=$(shell date +"%m%d%Y_%H%M")


# Default target
.PHONY: all
all: install

# Create virtual environment and install requirements
.PHONY: install
install: $(VENV_DIR)/bin/activate

$(VENV_DIR)/bin/activate: $(REQUIREMENTS)
	python3 -m venv $(VENV_DIR)
	$(PIP) install -r $(REQUIREMENTS)
	touch $(VENV_DIR)/bin/activate
	$(PIP) install pipreqs

# Run the script using the virtual environment
.PHONY: run
run: $(VENV_DIR)/bin/activate
	$(PYTHON) src/main.py

# Update requirements.txt using pipreqs
.PHONY: update
update:
	@echo "Updating requirements.txt using pipreqs..."; 
	@pipreqs --force --encoding=iso-8859-1 --ignore ".venv"

	

# Build the Docker container
.PHONY: build
build:
	@echo "Updating Container-Tag"
	@sed -i "s|image:.*|image: ${REGISTRY}:v${TAG}|" docker-compose.yaml

# docker build -t $(IMAGE_NAME) -f $(DOCKERFILE) .


.PHONY: test
test:
	pytest


# Clean the virtual environment
.PHONY: clean
clean:
	rm -rf $(VENV_DIR)

# Help message
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make install   - Create virtual environment and install requirements"
	@echo "  make run       - Run the script using the virtual environment"
	@echo "  make build     - Build the Docker container"
	@echo "  make clean     - Remove the virtual environment"
	@echo "  make help      - Display this help message"
