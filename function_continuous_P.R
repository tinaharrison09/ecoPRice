
# This function partitions continuous linear change in community ecosystem function (EF) over space or time, into components due to the continuous changes in community abundance, composition, or species' per-capita function. Its main arguments are a site-by-species matrix of abundance, a vector describing the sites' positions in time or on an environmental gradient, and a site-by-species matrix of per-capita EF, valued NA for any site-species where measurements are missing (particularly when abundance is 0).

# output is the slope and intercept of the linear trend in total function, and the same slope in counterfactual scenarios where only abundance, composition, or per-capita function respond to the gradient.

require(magrittr)

continuous_P = function(a, e, z, Xlab="gradient", Ylab="function") {

p = (a/rowSums(a))
A = rowSums(a)
t = rowSums(a*z, na.rm=T)
# e = e+abs(min(e))

mod.A = lm(A ~ e)
mod.p = apply(p, 2, function(y) lm(y ~ e))
mod.z = apply(z, 2, function(y) lm(y ~ e))
mod.t = lm(t~e)

# equation 6
beta.A = mod.A$coef[2]*sum(sapply(mod.p, coef)[1,]*sapply(mod.z, coef)[1,])
beta.p = mod.A$coef[1]*sum(sapply(mod.p, coef)[2,]*sapply(mod.z, coef)[1,])
beta.z = mod.A$coef[1]*sum(sapply(mod.p, coef)[1,]*sapply(mod.z, coef)[2,])


plot(e, t, pch=19, cex=1.5, col="gray", xlab=Xlab, ylab=Ylab, cex.axis=1.2, cex.lab=1.2)
abline(mod.t, col="gray", lwd=3)
points(e, mod.t$coef[1] + beta.A*e, col="red", type="l", lwd=3)
points(e, mod.t$coef[1] + beta.p*e, col="blue", type="l", lwd=3)
points(e, mod.t$coef[1] + beta.z*e, col="green", type="l", lwd=3)
legend("topright", c("original data", "abundance", "composition", "intrasp"), lwd=2, bty="n", cex=0.8, col=c("gray", "red", "blue", "green"))

c(mod.t$coef[1], 
        slope.obs = as.numeric(mod.t$coef[2]),
        slope.abund = as.numeric(beta.A),
        slope.comp = as.numeric(beta.p),
        slope.intr = as.numeric(beta.z)) %>% round(4)
}


# example
a = read.csv("data/stream_inverts.csv", row.names=1)
e = read.csv("data/stream_data.csv", row.names=1) %$% dist
z = read.csv("data/stream_invert_size.csv", row.names=1)
# the way I've written things, the partition takes 0 to be the "intercept". This works well here but I'm not sure if it won't make bugs in other analyses. Because this data happens to have its environmental variable scaled around 0, I am going to shift it so "0" represents pristine conditions:
e = e+abs(min(e))

continuous_P(a, e, z)
