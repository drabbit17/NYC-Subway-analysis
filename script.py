import pandas as pd
import numpy as np
from scipy.stats import mannwhitneyu
import matplotlib.pyplot as plt
from ggplot import *
from sklearn import linear_model
import datetime

dfrm = pd.read_csv('turnstile_data_master_with_weather.csv')

#### plot 1 ####

Rain = dfrm[dfrm.rain == 1]['ENTRIESn_hourly'].values
NoRain = dfrm[dfrm.rain == 0]['ENTRIESn_hourly'].values

plt.figure()

binwidth = 250
plt.hist(NoRain, bins=np.arange(min(NoRain), max(NoRain) + binwidth, binwidth), color='b', alpha=0.7, label='NoRain')
plt.hist(Rain, bins=np.arange(min(Rain), max(Rain) + binwidth, binwidth), color='g', alpha=0.7, label='Rain')
	
plt.title("Histogram of hourly entries")
plt.xlabel("hourly entries")
plt.ylabel("Frequency")
plt.axis([0, 6000, 0, 45000])
plt.legend() 
plt.grid()

plt.savefig('exploratory.png', bbox_inches='tight')

#### Mann Whitney U-Test ####

with_rain_mean = np.mean(Rain)
without_rain_mean = np.mean(NoRain)
man = mannwhitneyu(Rain, NoRain)
U = man[0]
pval = man[1]

print "rainy mean is", with_rain_mean, ", while no rainy mean is", without_rain_mean 
print "U test value is", U, " and p-value is ", pval

#### section 2 Gradient descendent ####

# definition of dependent and independent variables
# the model specification is here under features !
# de facto only hour is useful

time = pd.to_datetime(pd.Series(dfrm.DATEn))
dfrm['weekday'] = time.dt.dayofweek

features = dfrm[[]]
dummy_units1 = pd.get_dummies(dfrm['UNIT'], prefix='unit')
dummy_units2 = pd.get_dummies(dfrm['weekday'], prefix='weekday')
dummy_units3 = pd.get_dummies(dfrm['Hour'], prefix='Hour')
features = features.join(dummy_units1)
features = features.join(dummy_units2)
features = features.join(dummy_units3)

values = dfrm['ENTRIESn_hourly']
features_array = features.values
values_array = values.values

# normalization
means = np.mean(features, axis=0)
std_devs = np.std(features, axis=0)
normalized_features = (features - means) / std_devs

# linear regression with gradient descendent
clf = linear_model.SGDRegressor(alpha=0.0001, epsilon=0.1,  loss='squared_loss', n_iter=1000)
clf.fit(normalized_features, values_array)
norm_intercept = clf.intercept_
norm_params = clf.coef_

# recover parameters
intercept = norm_intercept - np.sum(means * norm_params / std_devs)
params = norm_params / std_devs

# compute R_squared
predictions = intercept + np.dot(features_array, params)
ybar = np.mean(values)
ssreg = np.sum((predictions-values)**2)
sstot = np.sum((values - ybar)**2)
Rsquared = 1 - ssreg/sstot

residuals = values - predictions

res = pd.DataFrame( { 'residual' : residuals,
						'predicted' : predictions})

residual = ggplot(res, aes(x=predictions, y=residuals)) + \
    		geom_point() + xlab("Predicted") + ylab("Residual") + ggtitle("Residuals VS Predicted")
    			
ggsave(filename = 'residual.png', plot = residual)

#### displayed values ####

string_feat = ['Hour']

print ' '
print "the intercept value is ", intercept
print "While the coefficients are:" 

for i in np.arange(0,len(string_feat)):
	print string_feat[i-1], ' parameter is equal to', params[i-1]

print 'Moreover, the R-squared is equal to', Rsquared

####				####

#### plot2 ####

test = pd.DataFrame({'Entries' : dfrm.groupby( ['DATEn', 'rain'] )['ENTRIESn_hourly'].mean()}).reset_index()
test.rain = test.rain.replace([0,1], ['NoRain','Rain'])
test.rain = pd.Categorical(test.rain) 
test.DATEn = pd.to_datetime(test.DATEn)

plot2 = ggplot(test, aes( x = 'DATEn', y = 'Entries', color='rain')) + geom_line() + geom_point() + scale_x_date() + \
			ggtitle('Average Hourly Entries at Daily Level') + xlab('Date') + ylab('Entries') 
			
ggsave(filename = 'plot2.png', plot = plot2)

#### plot 3 ####

dfrm = pd.read_csv('turnstile_data_master_with_weather.csv')

time = pd.to_datetime(pd.Series(dfrm.DATEn))
dfrm['weekday'] = time.dt.dayofweek

# compute subgroups values
test = pd.DataFrame({'Entries' : dfrm.groupby( ['weekday','Hour', 'rain'] )['ENTRIESn_hourly'].mean()}).reset_index()
test['weekday'] = test.weekday.replace([0,1,2,3,4,5,6], ['Mon','Tue','Wed','Thu','Fri','Sat', 'Sun']) 
    
# organize weekdays as ordered categories
test['weekday'] = pd.Series(test['weekday'], dtype="category")
test['weekday'] = pd.Series(pd.Categorical(test['weekday'], categories=['Mon','Tue','Wed','Thu','Fri','Sat', 'Sun']))
    
# plot
plot3 = ggplot(test, aes( x = 'Hour', y = 'Entries', color='rain')) + geom_line() + facet_wrap('weekday') + \
    	scale_y_continuous(limits=(0,3700)) + ggtitle('Average Hourly Entries During Weekdays')

ggsave(filename = 'plot3.png', plot = plot3)
