# ecoPRice
Analyses of community composition and ecosystem services based on ecological Price equations

The code here reproduces the example analyses presented in Harrison, Winfree and Gibbs 20xx. There are two main functions. xsite_mean_P receives site-species abundance and function matrices and returns each site's partitions from the cross-site mean baseline, summary regression slopes with either total abundance or total function, and a figure (Figure 2 in Harrison et al.). function_continous_P receives site-species abundance and function matrices and a vector of site gradient values (e.g. time or environmental conditions) and returns partitioned linear regression slopes of ecosystem function over the gradient, and a figure (Figure 3 in Harrison et al.).

Either function also works if input data are species presence-absence and total function at a site.
