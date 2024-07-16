ENV_NAME = $(shell basename $(shell pwd))
REQUIREMENTS = requirements.txt
REGISTRY = registry.github.com
PYTHON_VERSION = $(shell cat .python-version)
DOCKERFILE = Dockerfile
TAG = $(shell date +"%Y%m%d_%H%M")

# Conda environment activation command
ACTIVATE_ENV = . $(shell conda info --base)/etc/profile.d/conda.sh && conda activate $(ENV_NAME)

# Conda Channels
CONDA_CHANNELS = -c defaults -c conda-forge

# Default target
.PHONY: all
all: install

# Create conda environment and install requirements
install: $(REQUIREMENTS)
	. $(shell conda info --base)/etc/profile.d/conda.sh && conda create -y -n $(ENV_NAME) python=$(PYTHON_VERSION) $(CONDA_CHANNELS)
	$(ACTIVATE_ENV) && pip install -r $(REQUIREMENTS)
	$(ACTIVATE_ENV) && pip install pipreqs

# Run the script using the conda environment
.PHONY: run
run:
	$(ACTIVATE_ENV) && python src/main.py

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
	@echo "Removing conda environment '$(ENV_NAME)' and cleaning up..."
	. $(shell conda info --base)/etc/profile.d/conda.sh && conda env remove -n $(ENV_NAME)

# Help message
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make install   - Create virtual environment and install requirements"
	@echo "  make run       - Run the script using the virtual environment"
	@echo "  make build     - Build the Docker container"
	@echo "  make clean     - Remove the virtual environment"
	@echo "  make help      - Display this help message"
