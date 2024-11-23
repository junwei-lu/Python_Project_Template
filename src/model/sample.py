import pandas as pd
import numpy as np
import yaml
from sklearn.ensemble import RandomForestRegressor
def run(config_path=’./config.yml’):
    # Read in yaml file
    with open(config, ‘r’) as ymlfile:
        config = yaml.safe_load(ymlfile)
    
    # pull out paths up here
    training_path = config[‘DATA_PATH’] + ‘training_data.csv’
    scoring_path = config[‘DATA_PATH’] + ‘scoring_data.csv’
    output_path = config[‘DATA_PATH’] + ‘output_data.csv’
    
    # Read in training data
    training_data = pd.read_csv(training_path)
    X = training_data[config[‘X_VAR’]]
    y = training_data[config[‘Y_VAR’]]
    # Read in scoring data
    scoring_data = pd.read_csv(scoring_path)
    X_pred = scoring_data[config[‘X_VAR’]]
    
    # Fit your model
    regr = RandomForestRegressor(
        n_estimators=config[‘N_ESTIMATORS’]
    )
    regr.fit(X, y)
    
    # Make your predictions
    y_hat = regr.predict(X_pred)
    # Output to a csv
    np.savetxt(output_path, y_hat, delimiter=’,’)
			   
if __name__ == "__main__":
    run()