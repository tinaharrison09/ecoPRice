# ecoPRice
Analyses of community composition and ecosystem services based on ecological Price equations

The code here reproduces the example analyses presented in Harrison, Winfree and Gibbs 20xx. There are two main functions. xsite_mean_P receives site-species abundance and function matrices and returns each site's partitions from the cross-site mean baseline, summary regression slopes with either total abundance or total function, and a figure (Figure 2 in Harrison et al.). continous_P receives site-species abundance and function matrices and a vector of site gradient values (e.g. time or environmental conditions) and returns partitioned linear regression slopes of ecosystem function over the gradient, and a figure (Figure 3 in Harrison et al.).

Either function also works if input data are species presence-absence and total function at a site.

The functions are here saved together with the data sets used in Harrison et al. "stream" data are appropriate for testing continuous_P, and "watermelon" data are appropriate for testing xsite_mean_P. Data citations:

Pomeranz, J. P. F., Warburton, H. J., & Harding, J. S. (2019). Anthropogenic mining alters macroinvertebrate size spectra in streams. Freshwater Biology, 64(1), 81–92. https://doi.org/10.1111/fwb.13196

Winfree, R., Fox, J. W., Williams, N. M., Reilly, J. R., & Cariveau, D. P. (2015). Abundance of common species, not species richness, drives delivery of a real-world ecosystem service. Ecology Letters, 18(7), 626–635. https://doi.org/10.1111/ele.12424
