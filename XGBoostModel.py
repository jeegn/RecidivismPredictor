import pandas as pd
import numpy as np

import xgboost as xgb
from xgboost import XGBClassifier

import Downsample
import warnings
import pickle

warnings.filterwarnings('ignore')


def compare(i, cat):
    if cat == f'{i} to {i + 3}':
        return 1
    return 0


def get_training_data(df, time):
    X_train_ = df.iloc[:, 0:21]
    X_train_['recidivism_event'] = df[f'recidivism_{time}']
    X_train = Downsample.downsample(X_train_.copy())
    y_train = X_train['recidivism_event']
    X_train.drop(columns='recidivism_event', inplace=True)
    return X_train, y_train


# Data Preprocessing
df = pd.read_csv('synthetic data with time to recidivism.csv')
df = df.iloc[:, 1:25]
df['time_to_recidivism_months'] = df['time_to_recidivism_months'].replace(np.nan, 0)
df['time_to_recidivism_category'] = df['time_to_recidivism_category'].replace(np.nan, "")

# Encoding time specific data
for i in range(0, 36, 3):
    df[f'recidivism_{i}'] = df['time_to_recidivism_category'].apply(lambda cat: compare(i, cat))

# models for time specific prediction
XGB = XGBClassifier(eta=0.2, min_child_weight=8, gamma=5, max_depth=5, objective='binary:logistic')

for i in range(0, 36, 3):
    X_train, y_train = get_training_data(df, i)
    model = XGB.fit(X_train, y_train)
    pickle.dump(model, open(f'Models/model{int(i/3) + 1}.clf', 'wb'))

