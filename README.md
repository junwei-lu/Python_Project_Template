# Data Science Project Template

## To Do

- [ ] Add sample raw data (data_raw.csv eg) and sample preprocessing code
- [ ] Add the pipeline for configuration management

## Project Structure

```
src/
├── docs/                           # Documentation (.md/.rst files)
├── configs/                        # Config files (.yml)
├── logs/                           # Logfiles
├── notebooks/                      # EDA and validation (.ipynb)
├── scripts/                        # Deployment, Dockerfile, etc.
├── env/                            # Virtual env, add to .gitignore
├── src/                     # Top level package dir
│   ├── source/                     # Data sourcing (.py, not shown)
│   ├── preprocess/                 # Preprocessing (.py, not shown)
│   ├── model/                      # Modeling (.py)
│   │   ├── __init__.py             # Designates as (sub)package
│   │   ├── train_eval.py
│   │   └── predict.py
│   ├── utils/                      # Util functions used in source,
│   │   ├── __init__.py             # preprocess, model.
│   │   ├── spark.py
│   │   ├── date_time.py
│   │   └── io.py
│   ├── tests/                      # Unit tests
│   │   ├── source/
│   │   ├── preprocess/
│   │   ├── model/
│   │   │   ├── __init__.py
│   │   │   ├── test_train_eval.py
│   │   │   └── test_predict.py
│   │   ├── utils/
│   │   │   ├── __init__.py
│   │   │   ├── test_spark.py
│   │   │   ├── test_date_time.py
│   │   │   └── test_io.py
│   │   └── __init__.py
│   ├── __main__.py                 # Package execution entry point
│   ├── __init__.py
│   ├── config.py                   # Loads and Boxes configuration
│   └── run.py                      # Called from __main__.py
├── README.md                       # Intro to package
├── setup.py                        # Installing the package
├── requirements.txt                # Lists dependencies
├── .gitignore                      # Files/dirs to git ignore
└── LICENSE.md                      # License
```

## Key Points

- **Root Directory**: The root directory is not a Python package (it has no `__init__.py`), but the same-named directory `src`, and its subdirectories, are Python packages.

- **Unit Tests**: Unit tests are located in `src/tests` and are organized in directories and files mirroring the structure of `src`. For instance, functions in `src/utils/spark.py` are tested in `src/tests/utils/test_spark.py`.

- **Setup**: `setup.py` contains a call to the `setup` function from `setuptools`, with `install_requires` loading requirements from `requirements.txt`. This avoids duplication of requirements in `setup.py` and `requirements.txt`.

- **Configuration**: `config.py` should load and Box your config file(s) and add in any environment variables. In all other modules, import the config Box as `from src.config import cfg`.

- **Main Entry Point**: `__main__.py` calls the `main()` function in `run.py`, which is the single entry point for all functionality. This enables the user to execute the package in a standard way: `python -m src` (with optional arguments following).

- **Naming**: If you find it confusing that the root directory and top-level package directory have the same name, consider changing one of the names (e.g., scikit-learn has root directory “scikit-learn” and top-level package “sklearn”). Personally, I avoid multiplicity of names, so I use the same name for both.

- **Flexibility**: This structure is not meant to be exhaustive or set in stone. Depending on the nature of the project and the approach, you may have multiple top-level packages (e.g., a separate, extensive ETL or reporting process), an `interfaces/` directory for abstract classes if taking an object-oriented approach to the pipeline, a separate directory for integration and end-to-end tests, etc.

## Instructions

### Generate and Update Configurations

To initialize the configuration structure, run:

```bash
make init_config
```

This will create a `configs/` directory with base, development, and production configuration files.

### Create Virtual Environment

To create a virtual environment, run:

```bash
make venv
```

This will create a virtual environment in the `venv/` directory and upgrade `pip`.

### Activate Virtual Environment

To activate the virtual environment, run the following command in your terminal:

```bash
source venv/bin/activate
```

### Install Packages

To install the necessary data science packages, run:

```bash
make install
```

### Update Packages

To update the packages listed in `requirements.txt`, run:

```bash
make update_packages
```

### Freeze Current Packages

To save the current package versions to `requirements.txt`, run:

```bash
make freeze
```

### Clean Up

To remove the virtual environment and cache files, run:

```bash
make clean
```

### Development Tools

To install development tools like `pytest`, `black`, `flake8`, and `mypy`, run:

```bash
make dev-install
```

### Format Code

To format your code using `black`, run:

```bash
make format
```

### Lint Code

To run linting tools, run:

```bash
make lint
```

### Run Tests

To run tests with coverage, run:

```bash
make test
```

### Help

To display all available commands, run:

```bash
make help
```
