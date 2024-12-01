"""This module creates visualizations for the Random Forest regression results."""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import yaml
import os

def load_config(config_path='src/config/config.yaml'):
    """Load configuration from YAML file"""
    with open(config_path, 'r') as file:
        return yaml.safe_load(file)

def plot_feature_importance(importance_df, config, output_dir='src/output'):
    """Create and save a bar plot of feature importance"""
    # Set the style
    plt.style.use('ggplot')
    
    # Create figure with specified size
    fig_size = config['visualization']['figure_size']
    plt.figure(figsize=fig_size)
    
    # Create bar plot
    sns.barplot(
        data=importance_df,
        x='importance',
        y='feature',
        hue='feature',
        palette='viridis',
        legend=False
    )
    
    # Customize the plot
    plt.title('Feature Importance in Random Forest Model', 
              fontsize=config['visualization']['font_size'])
    plt.xlabel('Importance', fontsize=config['visualization']['font_size']-2)
    plt.ylabel('Features', fontsize=config['visualization']['font_size']-2)
    
    # Adjust layout
    plt.tight_layout()
    
    # Save the plot
    plt.savefig(os.path.join(output_dir, 'feature_importance.png'), 
                dpi=300, bbox_inches='tight')
    plt.close()

if __name__ == "__main__":
    # Load configuration
    config = load_config()
    
    # Read feature importance data
    importance_df = pd.read_csv('src/output/feature_importance.csv')
    
    # Create and save the plot
    plot_feature_importance(importance_df, config)
