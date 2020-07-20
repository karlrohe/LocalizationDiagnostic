
# When the blue line curves down for A, 
# this could be from an artifact of fastRG.
# fastRG generates a poisson graph.  To get a {0,1} graph,
# edges fastRG thresholds all positive edges into 1.  
# This primarily reduces the edges between high degree nodes. 
# This leads to attenuation in the leverage for high degree nodes. 

# This simulation demostrates this.  First, a poisson graph is generated.
# Blue line is flat. 
# Then, edges are thresheld. Then, blue line curves down.

library(fastRG)
library(rARPACK)
source("KeyFunctionsForDiagnosticPlots.R")


set.seed(1)
theta = rexp(n)^2  # this is the shape of the degree distribution.
params <- chung_lu_params(theta)
A = fastRG(params$X, params$S, poisson_edges = T, directed = F, avg_deg = 30)+0

degree = rowSums(A)
ei = eigs(A, 5)
max(A@x)

leverage = ei$vectors[,1]^2
plotDegLevReg(degree, leverage)

A@x = (A@x>0)+0
degree = rowSums(A)
ei = eigs(A, 5)


leverage = ei$vectors[,1]^2
plotDegLevReg(degree, leverage)
