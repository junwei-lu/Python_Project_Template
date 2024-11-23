from typing import Dict, Any, Tuple
import pandas as pd
from sklearn.base import BaseEstimator
from sklearn.model_selection import cross_val_score
import mlflow

class ModelTrainer:
    """Handle model training with proper logging and experiment tracking."""
    
    def __init__(self, config: Dict[str, Any]):
        """Initialize trainer with configuration.
        
        Args:
            config: Configuration dictionary with model parameters
        """
        self.config = config
        mlflow.set_tracking_uri(config.mlflow.tracking_uri)
        mlflow.set_experiment(config.mlflow.experiment_name)
        
    def train_model(
        self, 
        X: pd.DataFrame, 
        y: pd.Series,
        model: BaseEstimator
    ) -> Tuple[BaseEstimator, Dict[str, float]]:
        """Train model with cross-validation and logging.
        
        Args:
            X: Feature matrix
            y: Target variable
            model: Sklearn-compatible model
            
        Returns:
            Tuple of (fitted model, metrics dictionary)
        """
        with mlflow.start_run():
            # Log parameters
            mlflow.log_params(self.config.model.parameters)
            
            # Perform cross-validation
            cv_scores = cross_val_score(
                model, X, y, 
                cv=self.config.model.cv_folds,
                scoring=self.config.model.scoring
            )
            
            # Log metrics
            metrics = {
                'cv_mean_score': cv_scores.mean(),
                'cv_std_score': cv_scores.std()
            }
            mlflow.log_metrics(metrics)
            
            # Fit final model
            model.fit(X, y)
            
            # Log model
            mlflow.sklearn.log_model(model, "model")
            
            return model, metrics 