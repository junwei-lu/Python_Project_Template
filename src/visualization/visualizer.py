from typing import List
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from pathlib import Path

class DataVisualizer:
    """Handle all visualization with consistent styling."""
    
    def __init__(self, save_dir: Path):
        """Initialize visualizer.
        
        Args:
            save_dir: Directory to save figures
        """
        self.save_dir = save_dir
        self.setup_style()
        
    def setup_style(self):
        """Set consistent style for all plots."""
        sns.set_theme(style="whitegrid")
        plt.rcParams['figure.figsize'] = (10, 6)
        plt.rcParams['font.size'] = 12
        
    def plot_feature_distributions(
        self, 
        df: pd.DataFrame, 
        features: List[str],
        save_name: str = "feature_distributions.png"
    ):
        """Plot distributions of multiple features.
        
        Args:
            df: DataFrame containing features
            features: List of feature names to plot
            save_name: Name of file to save plot
        """
        fig, axes = plt.subplots(
            nrows=(len(features) + 1) // 2, 
            ncols=2, 
            figsize=(15, 5 * ((len(features) + 1) // 2))
        )
        axes = axes.flatten()
        
        for ax, feature in zip(axes, features):
            sns.histplot(data=df, x=feature, ax=ax)
            ax.set_title(f"Distribution of {feature}")
            
        plt.tight_layout()
        plt.savefig(self.save_dir / save_name)
        plt.close() 