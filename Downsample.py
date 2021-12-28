import pandas as pd
from collections import Counter
from sklearn.utils import resample

def find_min_max(df):
    y_val = df.recidivism_event
    counter = Counter(y_val)
    # print(counter)
    count_zero = counter[0]
    count_one = counter[1]
    if count_zero > count_one:
        return count_one, count_zero, 1, 0
    else:
        return count_zero, count_one, 0, 1

def downsample(X_train):
    # downsample on training data (this includes the y status still)
    df = X_train

    # Separate majority and minority classes
    minority_count, majority_count, minority_val, majority_val = find_min_max(df)

    df_majority = df[df.recidivism_event == majority_val]
    df_minority = df[df.recidivism_event == minority_val]

    df_majority_downsampled = resample(df_majority,
                                       replace=False,  # sample without replacement
                                       n_samples=minority_count,  # to match minority class
                                       random_state=123)  # reproducible results

    # Combine minority class with downsampled majority class
    df_downsampled = pd.concat([df_majority_downsampled, df_minority])

    return df_downsampled
