import pandas as pd
import numpy as np
from scipy.stats import mannwhitneyu
import matplotlib.pyplot as plt
from ggplot import *

dfrm = pd.read_csv('turnstile_data_master_with_weather.csv')

Rain = dfrm[dfrm.rain == 1]['ENTRIESn_hourly'].values
NoRain = dfrm[dfrm.rain == 0]['ENTRIESn_hourly'].values
	
plt.figure()
	
plt.hist(NoRain, bins=250, color='b', alpha=0.7, label='NoRain')
plt.hist(Rain, bins=250, color='g', alpha=0.7, label='Rain')
	
plt.title("Histogram of ENTRIESn_hourly")
plt.xlabel("ENTRIESn_hourly")
plt.ylabel("Frequency")
plt.axis([0, 6000, 0, 45000])
plt.legend() 
plt.grid()

plt.savefig('exploratory.png', bbox_inches='tight')


