import pandas as pd
import numpy as np
from scipy.stats import mannwhitneyu
import matplotlib.pyplot as plt
from ggplot import *
from sklearn import linear_model

dfrm = pd.read_csv('turnstile_data_master_with_weather.csv')

Rain = dfrm[dfrm.rain == 1]['ENTRIESn_hourly'].values
NoRain = dfrm[dfrm.rain == 0]['ENTRIESn_hourly'].values
	
plt.figure()
	
plt.hist(NoRain, bins=250, color='b', alpha=0.7, label='NoRain')
plt.hist(Rain, bins=250, color='g', alpha=0.7, label='Rain')
	
plt.title("Histogram of hourly entries")
plt.xlabel("hourly entries")
plt.ylabel("Frequency")
plt.axis([0, 6000, 0, 45000])
plt.legend() 
plt.grid()

plt.savefig('exploratory.png', bbox_inches='tight')

# Mann Whitney U-Test

with_rain_mean = np.mean(Rain)
without_rain_mean = np.mean(NoRain)
man = mannwhitneyu(Rain, NoRain)
U = man[0]
pval = man[1]

print "rainy mean is", with_rain_mean, ", while no rainy mean is", without_rain_mean 
print "U test value is", U, " and p-value is ", pval

### section 2 Gradient descendent

# definition of dependent and independent variables
# the model specification is here under features !
features = dfrm[['rain', 'precipi', 'Hour', 'meantempi', 'maxtempi', 'mintempi' ]]
dummy_units1 = pd.get_dummies(dfrm['UNIT'], prefix='unit')
features = features.join(dummy_units1)

values = dfrm['ENTRIESn_hourly']
features_array = features.values
values_array = values.values

# normalization
means = np.mean(features, axis=0)
std_devs = np.std(features, axis=0)
normalized_features = (features - means) / std_devs

# linear regression with gradient descendent
clf = linear_model.SGDRegressor(alpha=0.0001, epsilon=0.1,  loss='squared_loss', n_iter=100)
clf.fit(normalized_features, values_array)
norm_intercept = clf.intercept_
norm_params = clf.coef_

# recover parameters
intercept = norm_intercept - np.sum(means * norm_params / std_devs)
params = norm_params / std_devs

print "the intercept value is ", intercept
print "While the coefficients are:"
for i in 

# compute R_squared
predictions = intercept + np.dot(features_array, params)
ybar = np.mean(values)
ssreg = np.sum((predictions-values)**2)
sstot = np.sum((values - ybar)**2)
Rsquared = 1 - ssreg/sstot


string_feat = ['rain', 'precipi', 'Hour', 'meantempi', 'maxtempi', 'mintempi', 'UNIT']

for i in np.arange(1,len(string_feat)):
	print string_feat[i-1], ' parameter is equal to', params[i-1]

print 'Moreover, the R-squared is equal to', Rsquared