# The main function in this code is xsite_mean. Its main arguments are two species-by-site matrices of abundance and per-capita ecosystem function (EF). The function partitions the difference between each site's total EF and the cross-site mean EF, into three partitions according to Equation 4 in Harrison et al. 2021: (1) difference between the site's total abundance and cross-site mean abundance; (2) difference between the site's composition and cross-site mean composition, relative to the species function distribution (selection effect); and (3) difference between the site's per-capita function and cross-site mean per-capita function. 

# If instead the arguments are given as a presence-absence matrix and matrix of species' total EF, the resulting three richness-based partitions correspond to Equation 5 in the Appendix of Harrison et al. 2021. The function will know (it checks if the abundance matrix is binary) and will change label plot axes and legends accordingly.

# Outputs 

# slopes. These are the slopes and 95% confidence intervals for the correlations between sites' total EF (actual and hypothetical), and either total function or abundance/richness. (Perhaps we should present correlation coefficients instead; either could be useful).

# covar. The total cross-site mean EF can only be separated into its different constituent factors, to the extent that abundance and community weighted mean function are uncorrelated across sites, and that relative abundance and per-capita function are uncorrelated across sites within species.

# xsite.mean. The actual cross-site mean EF, stored here in case someone wants to graph the output differently. This value is added back to the deviations to produce site EFS in senarios where only one community component (abundance, composition, or per-capita function) deviates from the cross-site mean.

# site.deviations. Each site's partitioned deviation from cross-site mean EF, stored here in case someone wants to graph the output differently. 


require(magrittr)

##########
# population covariance function
pop.cov = function(x, y) {
  x = as.numeric(x)
  y = as.numeric(y)
  mean(x*y) - mean(x)*mean(y)}

###########
## this function calculates abundance-based 
# derived data
xsite_mean = function(a,z, plot=TRUE, plot.over=c("total", "size")) {

S = nrow(a)
N = ncol(a)
p = apply(a, 2, function(x) x/sum(x)) # relative species frequencies at each site
A = colSums(a) # total abundance at each site
t = colSums(a*z) # total function provided to each site
z.bar = colSums(p*z) # mean per-visit (CWM) function provided to a site

# cross-site means
E.t = mean(t)
E.A = mean(A)
E.z.bar = mean(z.bar)
E.p = rowMeans(p) # for each sp
E.z = rowMeans(z) # for each sp


# detect if presence-absence and change labels accordingly:
if(max(a) == 1) {
  Xlab = "site richness (S)"
  Leg1 = "richness"
  Leg2 = "per-sp function"
} else {
       Xlab = "site abundance (A)"
       Leg1 = "abundance" 
       Leg2 = "per-cap function"}

if(plot.over == "total") {Xvar = t; Xlab = "total function"} else Xvar = A


# partition terms for each site
size = (A - E.A)*E.z.bar
comp = A*colSums(z*(apply(p, 1, function(x) {x - mean(x)}) %>% t))
perc = A*colSums(rowMeans(p)*(apply(z, 1, function(x) {x - mean(x)}) %>% t))
# NOTE perc is calculated relative to E(p) not p
# covariances
sp.cov = sum(sapply(1:nrow(a), function(i) pop.cov(c(p[i,]), c(z[i,]))))
site.cov = pop.cov(A, z.bar)


t.mod = lm(t ~ Xvar)
size.mod = lm(E.t + size ~ Xvar)
comp.mod = lm(E.t + comp ~ Xvar)
perc.mod = lm(E.t + perc ~ Xvar)
# coef(abund.mod)[2] + coef(cwm.mod)[2]; coef(t.mod)[2]

# total function partitions v. abundance.
sapply(list(t.mod, size.mod, comp.mod, perc.mod), 
       function(m) {
         c(coef(m)[2], confint(m, 'Xvar', level=0.95))}) -> out
colnames(out) = c("total", Leg1, Leg2, "intrasp")
rownames(out) = c("slope", "CI.upper", "CI.lower")

if(plot == T) {
plot(Xvar, t, col="darkgray", pch=19, lwd=2, cex=1.5,
     cex.axis = 1.3, cex.lab = 1.3,
     xlab = paste(Xlab),
     ylab = "total function (T)")
points(Xvar, E.t + size, col="red", lwd=2, cex=1.5)
points(Xvar, E.t + comp, col="blue", lwd=2, cex=1.5)
points(Xvar, E.t + perc, col="green", lwd=2, cex=1.5)
abline(t.mod, col="gray", lwd=3)
abline(size.mod, col="red", lwd=3)
abline(comp.mod, col="blue", lwd=3)
abline(perc.mod, col="green", lwd=3)
legend("topleft", c("original data", Leg1, Leg2, "intrasp"), lwd=2, bty="n", cex=0.8, col=c("gray", "red", "blue", "green"))
} # close plot

list(
slopes = out, # print slopes and coefficients
covar = c(site.cov = site.cov, sp.cov = sp.cov),
xsite.mean = E.t,
site.deviations = cbind(
size = size,
comp =  comp,
intr = perc
)
)

} # close function


###########
# examples
# test data
# Winfree et al. 2015 data, from watermelon farms observed in 2012
a = read.csv("data/watermelon_com.csv", row.names=1)
# single-visit pollen deposition data (per-visit)
z = read.csv("data/watermelon_fun.csv", row.names=1)
# for both data sets, sites are in columns, species in rows

# abundance
xsite_mean(a, z, plot.over = "size")
xsite_mean(a, z, plot.over = "total")
# richness
xsite_mean(ifelse(a>0,1,0), a*z, plot.over = "size")
xsite_mean(ifelse(a>0,1,0), a*z, plot.over = "total")
