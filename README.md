# NYC-Subway-analysis

## Introduction and Data Description

The Turnstile weather dataset includes data regarding NYC subway use during the month of May 2011. Number of entries and exits are collected by different sensors located in different Subway stations. The dataset also includes details regarding weather conditions. The combination of those two information makes possible to assess whether Subway use is affected by weather conditions and to what extent. A more detailed description of the variables available can be found in the pdf file *turnstile-weather-variables.pdf*

## Sect.1 Exploratory Analysis and Statistical Testing 

Plotting a histogram of hourly entries during rainy and not rainy days allow us to understand clearly that none of the two subsamples is distributed following a normal distribution.

![Histogram]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/exploratory.png)

Therefore, when testing whether the difference between average entries during rainy and not rainy days is statistically different from zero, a non parametric test, such as the Mann-Whitney test, results necessary. This test reliability is based on the following assumptions:
1. All observations from the two groups are independent one from each other.
2. The values are ordinal, one can always say which one is the larger among two observations.
This test Null Hypothesis H0 assumes that randomly extracting one observation from the "rainy" sample, the probability that this is larger than another observation from the "non-rainy" sample equals the probability that a value extracted from the "non-rainy" sample exceeds the the "rainy" one. This implies that the two distributions should have the same distribution.
On the other hand, the alternative hypothesis H1 states that the two probabilities are different. If we have reasons to assume that this probability is larger for one specific group of the two, then we should run a one-tail test. Otherwise, if we are not sure about which group may prevail, or we just want to be more conservative, we should run two-tails test. I opted for a two-tail test with a p-critical value of 0.05.

Looking at the data we see that rainy days have a mean number of hourly entrances of 1105.446, while for non rainy days the value is of 1090.278. The p-value resulting, representative of a one-tail test, is of 0.02499. So, to obtain the p-value for the two-tails test it is enough to multiply this number by two. The resulting number is almost equal to 0.05, therefore, the test is barely statistically significant and points to the rejection of the Null Hp that the two distributions are equal.

## Sect.2 Relationship between Hourly Entries and other Variables

In fitting a regression model to estimate hourly entries I opted for the use of the gradient descendent algorithm. Mainly because i had never used this methodology before and i wanted to try it. The use of this methodology is suggested when dealing with models involving a very large number of variables, where OLS may not be able to find a solution. So in this specific case an OLS approach would have probably been more correct.

I tested the model using several different features and then i opted for selecting just few of them. 

| Variable Considered   | Reason to include              | Final Model                  | Parameter value |
| --------------------- |:------------------------------:| ----------------------------:|----------------------------:|
| rain  | Rainy time should give people an incentive to use public transport | Not included, no improvement in the R squared||
| precipi | The amount of precipitation may give a stronger incentive to use public transport | Not included, no improvement in the R squared||
| `Hour` | During specific hours a larger number of people may need to use public transport| Included, improvements in the predicted R squared |*dummies*|
| `UNIT` | It is likely that a large body of users uses the same turnstile everyday | Included, large improvements in the predicted R squared|*dummies*|
| `weekday` | working days and not should help in predicting subway use | Included, improvements in the predicted R squared|*dummies*|

Using the model specified in the table a R squared of 0.5025 is obtained. Including the dummy rain in the model the obtained R square was equal to 0.5001, bringing no improvements. The R square gives us an idea of what share of the overall variability in the dependent variable is explained by the fitted model. A value like that may imply that IF the relationship between dependent and independent variables is casual (something that we cannot tell just looking at the R squared), then we should be able to correctly predict/explain almost 50% of variability in the dependent values considered. This does not mean that the model would correctly predict 50% of future values, but just that would explain around 50% of their variability. 

Moreover, if we look at the residuals plotted against the fitted value we notice a strange pattern. A possible explanation for the unexpected linear relationship between residuals and predicted values may be given by the presence of fixed values for a subgroup of dependent variables, such as the zeros at the beginning of the day. ([reference](http://stats.stackexchange.com/questions/33165/diagonal-lines-in-residuals-vs-fitted-values-plot-for-multiple-regression)).

![residual]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/residual.png)

## Sect.3 Distribution of Hourly Entries

The first required visualization is included in Sect.1 because it is used to show how the rainy and non rainy values are not distributed with a normal distribution. Regarding the second visualization I decided to investigate the change in average hourly entries under two main dimensions, the time and the geographic ones. 

Below it is possible to see how the average number of hourly entrances changes according to different hours of the day and different weekdays. As it is possible to see there are four main peaks and there is not a consistent difference between raining days (red line) and non raining ones (blue line). 

![plot3]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/plot3.png)

The only slight difference is on monday, but this is probably due to an outlier in the "rain group" that with a very low value during a national holiday (30 of May, Memorial day) pushes down monday mean value.

![BarPlot]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/BarPlot.png)

It is also interesting to look at how hourly entries and exits change during the day (morning, afternoon and night) according to different turnstiles in different NYC areas (UNIT). Obviously, for each turnstile we have both entry and exit data. In order to have those two distinct measures aggregated in a single one i changed the sign for exit values to negative and then computed the overall mean for traffic (both exits and entries) at turnstile level. As we can see from the two plots below, in the "morning" (hours 8 and 12) Exits (red color) are prevalent on Entries in Manhattan area, while in the areas around is the opposite (blue).

![MapMorning]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/MapMorning.png)

This behaviour is reversed during "afternoon" hours (16 and 20). While those two observed behaviors may result obvious due to commuters, it is still interesting to see how Elmhurst and Jamaica areas are the ones where this phenomena is sharper.

![MapAfternoon]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/MapAfternoon.png)

## Sect.4 and 5 Conclusions and Reflections

This analysis tried to study the behavior of NYC subway users in several ways. It started testing the statistical difference in number of entries between rainy and non rainy days, then it followed an attempt to identify the features that are strong predictors through a gradient descendent model and finally different visualizzations focused on time and geographic variations. While the statistical test identified a difference in distribution of entries between rainy and non rainy days, the predictive model did not improve when the rain dummy was inserted and the visualizations showed no strong variation between rainy and non rainy days. The only slight difference may be due to a national holiday (Memorial day 30 of May) that behaving as an outlier drastically reduced monday entries.

Given the directions of the above mentioned evidences i would exclude that there is a significance difference in number of people riding the subway during rainy and non rainy days.

For what regard dataset content, I think that some features should be included. First of all, measurements should be made available according to individual hours (10,11,12 am) rather than aggregated in big chunks (8,12…). Having available entries/exits measures aggregated according to individual hours would make possible to partially discriminate users going to work (more sticky in their subway use) from tourists (probably taking the metro slightly after the big morning rush). Another interesting feature to know may be the number of turnstiles available for each specific sensor, so that we may understand whether a specific station is underused or overused. Finally, another measure with some predictive power may be the population density and average income in the different areas; this may work as a proxy for the pool size of the potential users concentrated around the turnstile (even if UNITs dummies already account for part of those characteristics impact). Moving to the statistical techniques adopted, as said above the presence of an outlier within the rainy group presenting a consistently smaller value on Monday may have had an influence on the Mann-Whitney test result. Finally, the regression result, as specified above, should only be considered reliable in showing the relationship between the dependent variable and the independent ones. Using simple regressions causal relationship should never be assumed. Still, when we consider that out main predictors are features that stay fixed over time (weekday, hour and unit) it makes poor sense to assume the presence of reverse causality (i.e. the dependent variable determining the independent one rather than vice versa). So, we may still claim, given the case, that the impact magnitude over entries of a specific weekday and unit will stick over time and therefore, we may use them to predict entries. So, here the shortcoming is the unorthodox, but in this case justifiable use, of regression to predict entries.  Moreover, given the potentially predictive use of the model, I also deem as necessary to include national holidays and NYC ones as dummy variables in the regression. 

## References

1. pandas [http://pandas.pydata.org/pandas-docs/stable/] (http://pandas.pydata.org/pandas-docs/stable/)
2. Gradient Descendent [http://scikit-learn.org/stable/modules/sgd.html] (http://scikit-learn.org/stable/modules/sgd.html)
3. Ggplot2 [http://docs.ggplot2.org/0.9.3.1/facet_wrap.html] (http://docs.ggplot2.org/0.9.3.1/facet_wrap.html)
4. Indexing in pandas [http://pandas.pydata.org/pandas-docs/stable/advanced.html] (http://pandas.pydata.org/pandas-docs/stable/advanced.html)
5. Selecting data in pandas [http://pandas.pydata.org/pandas-docs/stable/indexing.html] (http://pandas.pydata.org/pandas-docs/stable/indexing.html)
6. Map creation in ggplot2 [http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf] (http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf)
