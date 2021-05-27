
require(magrittr)

# input: species vectors for two sites, or species by site matrices
# if reorder = "EF", function makes the site with more function the baseline site
# if reorder = "rich", function makes the site with more richness the baseline site
# if split.migrants = TRUE, results in a 7-part partition (or 5 if using presence-absence data)

# a1 etc. are species vectors
part_one_pair = function(a1, a2, z1, z2, 
                     reorder = c("no", "EF", "rich"),
                     split.migrants = FALSE){
  
  # baseline is 1; comparison is 2. 
  # if reorder, check if baseline 1 is LESS than comparison 2
  # if it is, re-assign them
  if(reorder == "EF" & sum(a1*z1) < sum(a2*z2)) {
    a1.1 = a2; z1.1 = z2
    a2 = a1; z2 = z1
    a1 = a1.1; z1 = z1.1}
  if(reorder == "rich" & sum(a1>0) < sum(a2>0)) {
    a1.1 = a2; z1.1 = z2
    a2 = a1; z2 = z1
    a1 = a1.1; z1 = z1.1}
  
 A1 = sum(a1); A2 = sum(A2)
 p1 = a1/A1; p2 = a2/A2
 T1 = A1*sum(p1*z1); T2 = A2*sum(p2*z2)
 
if(split.migrants == TRUE) {
   s = ifelse(a1 > 0 & a2 > 0, 1, 0) # shared species indicator vector
   Ahat1 = sum(a1*s); Ahat2 = sum(a2*s)
   phat1 = a1*s/Ahat1; phat2 = a2*s/Ahat2 
   
   out = c(
     diff = T2 - T1,
       
   size.loss = (Ahat1 - A1)*sum(p1*z1),
   size.gain = (A2 - Ahat2)*sum(p2*z2),
   size.pers = (Ahat2 - Ahat1)*sum(p1*z1),
   
   comp.loss = Ahat2*sum((phat1 - p1)*z1),
   comp.gain = Ahat2*sum((p2 - phat2)*z2),
   comp.pers = Ahat2*sum((phat2 - phat1)*z1),
   
   intr.pers = Ahat2*sum(phat2*(z2 - z1)))
 } else 
   out = c(
diff = T2 - T1,
size = (A2 - A1)*sum(p1*z1),
comp = A2*sum((p2 - p1)*z1),
intr = A2*sum(p2*(z2 - z1)))

 out
} # end function

# a, z are species by site matrices
part_all_pair = function(a, z, 
                         reorder = c("no", "EF", "rich"),
                         split.migrants = FALSE) {
  (combn(1:ncol(a), 2) -> sites) %>% 
    apply(2, function(ind) {
      x = ind[1]; y = ind[2]
      part_one_pair(a[x,], a[y,], z[x,], z[y,], 
                    reorder = reorder, split.migrants = split.migrants)
    }) %>% t %>% cbind(t(sites))
}




# Testing
# Winfree et al. 2015 data, from watermelon farms observed in 2012
a = read.csv("data/watermelon_com.csv", row.names=1)
# single-visit pollen deposition data (per-visit)
z = read.csv("data/watermelon_fun.csv", row.names=1)
# for both data sets, sites are in columns, species in rows
x = 4; y = 9 # pick a pair of sites
part_one_pair(a[x,], a[y,], z[x,], z[y,], reorder = "no")
part_one_pair(a[x,], a[y,], z[x,], z[y,], reorder = "no", split.migrants = TRUE)
# part_all_pair returns NAs for composition and intraspecific change when no species are shared between two sites. This is normal and good.
# the function is a little slow; this is fine for now but would need to fixed before, say, apply the partition to thousands of randomized species-site matrices
part_all_pair(a, z, reorder = "EF", split.migrants = FALSE)
part_all_pair(ifelse(a>0,1,0), a*z, reorder = "rich", split.migrants = TRUE)

