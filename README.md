# NYC-Subway-analysis

## Introduction and data description

The Turnstile weather dataset includes data regarding NYC subway use during the month of May 2011. Number of entries and exits are aggregated according to different sensors located within different Subway stations. The dataset also includes details regarding weather conditions. This makes possible to assess whether Subway use is affected by weather conditions and to what extent. A more detailed description of the variables available can be found in the pdf file *turnstile-weather-variables*

Plotting a histogram of hourly entries during rainy and not rainy days it is possible to clearly see how none of the two is distributed following a normal distribution. 

![Histogram]
(https://github.com/drabbit17/NYC-Subway-analysis/blob/master/exploratory.png)

Therefore, when we test whether the difference between average entries during rainy and not rainy days is statistically significant, a non parametric test, such as the Mann-Whitney test, results more appropriate.
## References

1. pandas [http://pandas.pydata.org/pandas-docs/stable/] (http://pandas.pydata.org/pandas-docs/stable/)
2. Gradient Descendent [http://scikit-learn.org/stable/modules/sgd.html] (http://scikit-learn.org/stable/modules/sgd.html)
3. Ggplot2 [http://docs.ggplot2.org/0.9.3.1/facet_wrap.html] (http://docs.ggplot2.org/0.9.3.1/facet_wrap.html)
4. Indexing in pandas [http://pandas.pydata.org/pandas-docs/stable/advanced.html] (http://pandas.pydata.org/pandas-docs/stable/advanced.html)
5. Selecting data in pandas [http://pandas.pydata.org/pandas-docs/stable/indexing.html] (http://pandas.pydata.org/pandas-docs/stable/indexing.html)
6. Map creation in ggplot2 [http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf] (http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf)
