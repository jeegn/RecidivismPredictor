import numpy as np
import pickle
import xgboost as xgb
from xgboost import XGBClassifier

def predictor(input):
    predictions = []
    for i in range(1,13):
        model = pickle.load(open(f'Models/model{i}.clf', 'rb'))
        inputvector = np.array(input.split(" ")).reshape((1,-1)).astype(int)
        print(model.predict_proba(inputvector))
        predictions.append(model.predict_proba(inputvector)[0][1])
    return predictions

#print(predictor('34 5 '+'0 '*18+'0'))