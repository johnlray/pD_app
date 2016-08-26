<p>Welcome to p(Death)! To run this app, simply open your RStudio and run:</p>

```
shiny::runGitHub('pD_app', 'johnlray')
```

<p>This app provides a crude calculation of the probability that someone matching certain demographic characteristics will die in the next year. This calculation has only two parts: A numerator representing how many people with given demographic characteristics die, and a denominator representing an imputed estimate of how many such people there are in the United States. The numerator comes from <a href=http://www.nber.org/mortality/ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/>CDC</a>, denominator from <a href=https://usa.ipums.org/usa/>IPUMS</a>. Numerator is number of deaths reported in aggregate CDC data, disaggregated by <a href=http://www.cdc.gov/nchs/icd/icd10.htm>ICD-10 cause-of-death code</a> for some plots, and denominator is a national total imputed using raw, unweighted IPUMS data. Improvements will be made as suggested. IPUMS sample age max is 96, while CDC data's is higher. For both datasets, I use their annual files covering the years 2009, 2010, 2011, 2012, 2013, and 2014.</p>

<p>Why is your probability of dying so low? This project is based on the sadly now-defunct Death Risk Rankings project based in Carnegie Mellon's Social and Decision Sciences department which found that, among other things, your probability of dying does not cross 0.5 until age... wait for it... 107! Dying is a less likely occurrence for you than you probably think. They used a different (and more involved) approach to calculating their denominator than I did, as I only want to give an impressionistic view of the most important points of an exercise like this: You are very unlikely to die, you will probably die of something other than what you think you'll die of, and people of different backgrounds have very different life experiences than you. Play around and observe how the relative risks change, over lifetime and across groups.</p>

<p>Are you a veteran of the Death Risk Rankings project? Do you have comments on what death data you want to see? Please get in touch at your leisure via my github contact info!!</p>
