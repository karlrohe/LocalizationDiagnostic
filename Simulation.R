# simulation to 
# plot(rs[rs>5], lev[rs>5], log = "xy")
# simulate 
# 1) average degree 3 and 30
# 2) erdos_renyi, rexp, rexp^4
# 3) A and L

library(fastRG)
library(rARPACK)

# this loads the diagnostic plotting code:
source("KeyFunctionsForDiagnosticPlots.R")

makePlot = function(A, whichMat = "A"){
  deg = rowSums(A)
  if(whichMat == "A") ei = eigs(A, 5)
  if(whichMat == "L") ei = eigsL(A, 5)
  lev = rowSums(ei$vectors^2)
  plotDegLev(deg, lev)
}



# you can adjust the average degree here:
avg_deg = 30
# you can adjust the number of nodes here:
n = 10^5

Aer = erdos_renyi(n, avg_deg = avg_deg)+0

theta = rexp(n)
Acl1 =chung_lu(theta, avg_deg = avg_deg, simple = T)+0

theta = rexp(n)^4
Acl4 =chung_lu(theta, avg_deg = avg_deg, simple = T)+0


# rs = rowSums(A)
# ei = eigsL(A, 5)
# lev = rowSums(ei$vectors^2)

library(gridExtra)
pAer = makePlot(Aer, whichMat = "A")
pAcl1 = makePlot(Acl1, whichMat = "A")
pAcl4 = makePlot(Acl4, whichMat = "A")

pLer = makePlot(Aer, whichMat = "L")
pLcl1 = makePlot(Acl1, whichMat = "L")
pLcl4 = makePlot(Acl4, whichMat = "L")

ggsave("plots/degree30.jpeg", 
       grid.arrange(pAer,pAcl1, pAcl4, pLer,pLcl1, pLcl4, nrow =2, top = "Degree 4; erdos-renyi, mild degree hetero, heavy degree hetero", left = "A on top, L on bottom"),
       device = "jpeg"
)

