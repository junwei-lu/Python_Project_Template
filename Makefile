# Github variables
REPO_NAME = Python-Project-Template
GITHUB_USER = junwei-lu
BRANCH = main

# Specify the desired Python version
PYTHON_VERSION = 3.10.15

# Virtual environment settings
VENV_METHOD = venv  # Change this to 'poetry', 'conda', or 'uv' as needed
VENV_NAME = venv
PYTHON = python
VENV_BIN := $(VENV_NAME)/bin
VENV_PIP := $(VENV_NAME)/bin/pip
CONFIG_DIR := config



# Combine all PHONY targets
.PHONY: venv install update freeze activate deactivate list-packages clean dev-install format lint test help init_config init_project_structure

SHELL := /bin/zsh
CONDA_BASE := /opt/anaconda3
CONDA_ACTIVATE := source $(CONDA_BASE)/etc/profile.d/conda.sh

# Initialize a local Git repository and push to GitHub
init:
	git init
	git add .
	git commit -m "Initial commit"
	make init_repo

init_repo:
	gh repo create $(GITHUB_USER)/$(REPO_NAME) --private --source=. --remote=origin
	git push -u origin $(BRANCH)

# Sync with Github
sync:
	pyenv local $(PYTHON_VERSION)
	@echo "Syncing with GitHub and updating packages..."
	git pull origin $(BRANCH)
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		$(VENV_PIP) install --upgrade -r requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry install; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(VENV_PIP) install --upgrade -r requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		source $(VENV_NAME)/bin/activate; \
		uv pip sync requirements.txt; \
		deactivate; \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi
	@echo "Packages updated using $(VENV_METHOD)!"

# Push to GitHub
push:
	@echo "Freezing current packages to requirements.txt..."
	$(VENV_PIP) freeze > requirements.txt
	git add .
	git commit -m "Update analysis and data"
	git pull origin $(BRANCH)
	git push origin $(BRANCH)

# Create and initialize virtual environment
venv:
	@echo "Creating virtual environment using $(VENV_METHOD) with $(PYTHON_VERSION)..."
	pyenv local $(PYTHON_VERSION)
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		$(PYTHON) -m venv $(VENV_NAME); \
		$(VENV_NAME)/bin/pip install --upgrade pip; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry env use $(PYTHON_VERSION); \
		poetry config virtualenvs.in-project true; \
		poetry init --no-interaction --name "project" --description "" --author "Junwei Lu" --license "MIT" --dependency "requests" --dev-dependency "pytest"; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(CONDA_ACTIVATE) && \
		conda create --prefix $(VENV_NAME) $(PYTHON_VERSION) -y; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		uv init --no-cache --author-from Junwei Lu; \
		uv install; \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi
	@echo "Virtual environment created using $(VENV_METHOD) with $(PYTHON_VERSION)!"

# Install data science packages
install:
	pyenv local $(PYTHON_VERSION)
	@echo "Installing packages for data science..."
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		source $(VENV_NAME)/bin/activate; \
		$(VENV_PIP) install numpy pandas scikit-learn matplotlib seaborn jupyter; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry add numpy pandas scikit-learn matplotlib seaborn jupyter; \
		poetry add python-box pyyaml; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(CONDA_ACTIVATE) && \
		conda install --prefix $(VENV_NAME) numpy pandas scikit-learn matplotlib seaborn jupyter -y; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		source $(VENV_NAME)/bin/activate; \
		uv $(VENV_PIP) install numpy pandas scikit-learn matplotlib seaborn jupyter; \
	fi
	@echo "Packages installed using $(VENV_METHOD)!"

# Update existing packages
update_packages:
	@echo "Updating packages..."
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		$(VENV_PIP) install --upgrade -r requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry update; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(VENV_PIP) install --upgrade -r requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		uv pip sync requirements.txt; \
	fi
	@echo "Packages updated using $(VENV_METHOD)!"

# Save current package versions
lock:
	@echo "Freezing current packages to lockfile..."
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		$(VENV_PIP) freeze > requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry lock; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(VENV_PIP) freeze > requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		uv lock; \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi
	@echo "Lockfile created using $(VENV_METHOD)!"

# Show activation command
activate:
	@echo "To activate the virtual environment, run:"
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		echo "source $(VENV_NAME)/bin/activate"; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry shell; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(CONDA_ACTIVATE) && conda activate $(VENV_NAME); \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		echo "source $(VENV_NAME)/bin/activate"; \
	fi

# Show deactivation command
deactivate:
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		deactivate; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		exit; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		conda deactivate; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		deactivate; \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi

# Display installed packages
list:
	@echo "Listing installed packages for $(VENV_METHOD)..."
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		$(VENV_PIP) list; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry show; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(CONDA_ACTIVATE) && conda list --prefix $(VENV_NAME); \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		uv $(VENV_PIP) list; \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi

# Remove virtual environment and cache
clean:
	@echo "VENV_METHOD: '$(VENV_METHOD)'"
	@if [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		echo "Activating conda..."; \
		$(CONDA_ACTIVATE) && echo "Removing conda environment..."; \
		conda remove --prefix $(VENV_NAME) --all -y; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		echo "Removing poetry environment..."; \
		poetry env remove $(shell poetry env info --path); \
		rm -rf *.toml; \
		rm -rf poetry.lock; \
	elif [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		echo "Removing venv environment..."; \
		rm -rf $(VENV_NAME); \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		echo "Removing uv environment..."; \
		uv remove $(VENV_NAME); \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi
	rm -rf __pycache__
	rm -rf *.pyc
	rm -rf .pytest_cache
	rm -rf .coverage
	rm -rf htmlcov
	@echo "Clean complete"

# Initialize configuration structure
init_config:
	@echo "Creating configuration structure..."
	mkdir -p $(CONFIG_DIR)
	@echo "Creating base config.yaml..."
	@echo "base:" > $(CONFIG_DIR)/config.yaml
	@echo "  path:" >> $(CONFIG_DIR)/config.yaml
	@echo "    data: data/" >> $(CONFIG_DIR)/config.yaml
	@echo "    models: models/" >> $(CONFIG_DIR)/config.yaml
	@echo "    output: output/" >> $(CONFIG_DIR)/config.yaml
	@echo "  params:" >> $(CONFIG_DIR)/config.yaml
	@echo "    random_seed: 42" >> $(CONFIG_DIR)/config.yaml
	@echo "Creating development config..."
	@echo "development:" > $(CONFIG_DIR)/development.yaml
	@echo "  debug: true" >> $(CONFIG_DIR)/development.yaml
	@echo "  log_level: DEBUG" >> $(CONFIG_DIR)/development.yaml
	@echo "Creating production config..."
	@echo "production:" > $(CONFIG_DIR)/production.yaml
	@echo "  debug: false" >> $(CONFIG_DIR)/production.yaml
	@echo "  log_level: INFO" >> $(CONFIG_DIR)/production.yaml
	@echo "Installing python-box for config management..."
	$(VENV_PIP) install python-box pyyaml
	@echo "Configuration structure created!"

# Display available commands
help:
	@echo "Available commands:"
	@echo "  make venv          - Create a new virtual environment"
	@echo "  make install       - Install data science packages"
	@echo "  make update        - Update packages from requirements.txt"
	@echo "  make freeze        - Update requirements.txt with current packages"
	@echo "  make activate      - Show command to activate virtual environment"
	@echo "  make deactivate    - Show command to deactivate virtual environment"
	@echo "  make list-packages - List all installed packages"
	@echo "  make clean         - Remove virtual environment and cache files"

