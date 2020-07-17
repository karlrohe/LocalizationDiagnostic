# This simulation generates the plots in /plots


# There are two simulations.  In one, the average degree is 4.  In the other it is 30.  
# 
# In the first row of plots, it is for A.  In the second row, it is for L (with tau = avg degree)
# 
# In the first column A is erdos renyi.  (super mild degree heteogeneous)
# In the second column A is chung lu with theta = rexp. (mildly degree heterogeneous) 
# In the third column A is chung lu with theta = rexp^4  (highly degree heterogeneous)
# 
# Look for the bend in the line on high degree nodes.  This is localization on high degree nodes. 
# 
# Look for “separation” in point clouds for low degree nodes.  This is localization on low degree nodes. 


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









# you can adjust the average degree here:
avg_deg = 4
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

ggsave("plots/degree4.jpeg", 
       grid.arrange(pAer,pAcl1, pAcl4, pLer,pLcl1, pLcl4, nrow =2, top = "Degree 4; erdos-renyi, mild degree hetero, heavy degree hetero", left = "A on top, L on bottom"),
       device = "jpeg"
)

