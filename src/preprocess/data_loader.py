from pathlib import Path
from typing import Dict, Any
import pandas as pd
from box import Box

class DataLoader:
    """Handle all data loading operations with proper logging and error handling."""
    
    def __init__(self, config: Box):
        """Initialize with configuration.
        
        Args:
            config: Configuration object with data paths and parameters
        """
        self.config = config
        self.data_path = Path(config.base.path.data)
        
    def load_raw_data(self) -> pd.DataFrame:
        """Load raw data with proper error handling.
        
        Returns:
            DataFrame containing raw data
        
        Raises:
            FileNotFoundError: If raw data file doesn't exist
        """
        try:
            df = pd.read_csv(self.data_path / "raw/data.csv")
            print(f"Loaded raw data with shape: {df.shape}")
            return df
        except FileNotFoundError as e:
            print(f"Error loading raw data: {e}")
            raise 