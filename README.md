# NYC-Subway-analysis

## Introduction and data description

The Turnstile weather dataset includes data regarding NYC subway use during the month of May 2011. Number of entries and exits are aggregated according to different sensors located within different Subway stations. The dataset also includes details regarding weather conditions. This makes possible to assess whether Subway use is affected by weather conditions and to what extent. A more detailed description of the variables available can be found in the pdf file *turnstile-weather-variables*

## Exploratory analysis and statistical testing 

Plotting a histogram of hourly entries during rainy and not rainy days it is possible to see clearly how none of the two is distributed following a normal distribution.

![Histogram]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/exploratory.png)

Therefore, when we test whether the difference between average entries during rainy and not rainy days is statistically significant, a non parametric test, such as the Mann-Whitney test, results more appropriate. This test reliability is based on the following assumptions:
1. All observations from the two groups are independent one from each other.
2. The values are ordinal, one can always say which one is the larger among two observations.
This test Null Hypothesis H0 assumes that randomly extracting an observation from the "rainy" sample, the probability that this is larger than another observation from the "non-rainy" sample equals the probability that a value extracted from the "non-rainy" sample exceeds the the "rainy" one. This implies that the two distributions have the same distributions.
On the other hand, the alternative hypothesis H1 states that the two probabilities are different. If we have reasons to assume that this probability is larger for one specific group of the two, then we should run a one-tail test (as this case may suggest). I opted for a p-critical value of 0.05.

Rainy days have a mean number of hourly entrances of 1105.446, while for non rainy days the value is of 1090.278.The p-value resulting is of 0.02499. This being smaller than the p-critical value of 0.05 is a statistically significant result leading us to reject the Null Hypothesis that the two distributions are equal.

## Statistical relationship between hourly entries and other variables

## References

1. pandas [http://pandas.pydata.org/pandas-docs/stable/] (http://pandas.pydata.org/pandas-docs/stable/)
2. Gradient Descendent [http://scikit-learn.org/stable/modules/sgd.html] (http://scikit-learn.org/stable/modules/sgd.html)
3. Ggplot2 [http://docs.ggplot2.org/0.9.3.1/facet_wrap.html] (http://docs.ggplot2.org/0.9.3.1/facet_wrap.html)
4. Indexing in pandas [http://pandas.pydata.org/pandas-docs/stable/advanced.html] (http://pandas.pydata.org/pandas-docs/stable/advanced.html)
5. Selecting data in pandas [http://pandas.pydata.org/pandas-docs/stable/indexing.html] (http://pandas.pydata.org/pandas-docs/stable/indexing.html)
6. Map creation in ggplot2 [http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf] (http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf)
