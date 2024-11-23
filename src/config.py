from pathlib import Path
from box import Box
import yaml

def load_config(env="development"):
    """Load configuration files and return a Box object."""
    # Load base config
    with open("config/config.yaml", "r") as f:
        config = Box(yaml.safe_load(f))
    
    # Load environment specific config
    env_config_path = f"config/{env}.yaml"
    if Path(env_config_path).exists():
        with open(env_config_path, "r") as f:
            env_config = Box(yaml.safe_load(f))
            config.merge_update(env_config)
    
    return config

# Usage example
if __name__ == "__main__":
    # Load development config
    cfg = load_config("development")
    
    # Access config using dot notation
    print(f"Data path: {cfg.base.path.data}")
    print(f"Random seed: {cfg.base.params.random_seed}")
    print(f"Debug mode: {cfg.development.debug}")
    print(f"Log level: {cfg.development.log_level}")
    
    # Load production config
    cfg_prod = load_config("production")
    print(f"\nProduction debug mode: {cfg_prod.production.debug}")
    print(f"Production log level: {cfg_prod.production.log_level}") 