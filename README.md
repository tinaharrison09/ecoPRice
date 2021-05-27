# ecoPRice
Analyses of community composition and ecosystem services based on ecological Price equations

The code here reproduces the example analyses presented in Harrison, Winfree and Gibbs 20xx. There are three main functions. All functions give the abundance-based partitions presented in Harrison et al. when input data are species abundances and per-capita function at a site. They give the richness-based partitions presented in Fox 2006 and Fox & Kerr 2012, if input data are species presence-absence and total function at a site.


## Functions

### xsite_mean_P 
xsite_mean_P receives species by site abundance and function matrices and returns each site's partitions from the cross-site mean baseline, summary regression slopes with either total abundance or total function, and a figure (Figure 2 in Harrison et al.). 

### continous_P 
continous_P receives species by site abundance and function matrices and a vector of site gradient values (e.g. time or environmental conditions) and returns partitioned linear regression slopes of ecosystem function over the gradient, and a figure (Figure 3 in Harrison et al.).

### pairwise_P
pairwise_P returns the partitioned pairwise difference in EF between two sites, or between all pairwise combinations of sites in a species-site array. This function includes an option to analyze species loss and gain separately (set split.migrants = TRUE), which results in either the seven-part partition presented in Harrison et al Appendix 2, or (when applied to presence-absence data) the five-part partition presented Fox & Kerr 2012.


## Testing data
The functions are here saved together with the data sets used in Harrison et al. "stream" data are appropriate for testing continuous_P, and "watermelon" data are appropriate for testing xsite_mean_P. Data citations:

Pomeranz, J. P. F., Warburton, H. J., & Harding, J. S. (2019). Anthropogenic mining alters macroinvertebrate size spectra in streams. Freshwater Biology, 64(1), 81–92. https://doi.org/10.1111/fwb.13196

Winfree, R., Fox, J. W., Williams, N. M., Reilly, J. R., & Cariveau, D. P. (2015). Abundance of common species, not species richness, drives delivery of a real-world ecosystem service. Ecology Letters, 18(7), 626–635. https://doi.org/10.1111/ele.12424

## Citations
Fox, J. W. (2006). Using the Price equation to partition the effects of biodiversity loss on ecosystem function. Ecology, 87(11), 2687–2696. http://www.esajournals.org/doi/pdf/10.1890/0012-9658(2006)87%5B2687:UTPETP%5D2.0.CO%3B2
Fox, J. W., & Kerr, B. (2012). Analyzing the effects of species gain and loss on ecosystem function using the extended Price equation partition. Oikos, 121, 290–298. https://doi.org/10.1111/j.1600-0706.2011.19656.x
Harrison, T., Winfree, R., & Genung, M. Price equations for biodiversity-ecosystem function research. submitted American Naturalist Januaray 2021.
