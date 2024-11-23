from typing import List, Dict
import pandas as pd
import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin

class FeatureEngineer(BaseEstimator, TransformerMixin):
    """Handle feature engineering following sklearn transformer pattern."""
    
    def __init__(self, numeric_columns: List[str], categorical_columns: List[str]):
        """Initialize feature engineering parameters.
        
        Args:
            numeric_columns: List of numeric column names
            categorical_columns: List of categorical column names
        """
        self.numeric_columns = numeric_columns
        self.categorical_columns = categorical_columns
        
    def fit(self, X: pd.DataFrame, y=None) -> 'FeatureEngineer':
        """Fit the feature engineer (compute means, modes, etc.).
        
        Args:
            X: Input features
            y: Target variable (not used, included for sklearn compatibility)
            
        Returns:
            self: The fitted transformer
        """
        # Store fitting parameters
        self.numeric_means_ = X[self.numeric_columns].mean()
        self.categorical_modes_ = X[self.categorical_columns].mode().iloc[0]
        return self
        
    def transform(self, X: pd.DataFrame) -> pd.DataFrame:
        """Transform the data.
        
        Args:
            X: Input features
            
        Returns:
            Transformed features
        """
        X_copy = X.copy()
        
        # Fill missing values
        X_copy[self.numeric_columns] = X_copy[self.numeric_columns].fillna(self.numeric_means_)
        X_copy[self.categorical_columns] = X_copy[self.categorical_columns].fillna(self.categorical_modes_)
        
        return X_copy 