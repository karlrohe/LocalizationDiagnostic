library(tidyverse)

# this is the key function. 
# if you have deg (i.e. degree) and lev (i.e. leverage)
#  already computed, then use this function.  
# if you have a massive graph, then you might want to subsample
#  to make the plot faster to build.  Be careful with this... you could
#  miss the pattern.  If you want to do this, uncomment the middle lines of code.
plotDegLev= function(deg, lev, n = 100000){
  x = deg[deg>5]
  y = lev[deg>5]
  samp = 1:length(x)  # this will be overwrote and a subsample will be taken if you uncomment the next lines.
  #   # samp1 biases to high leverage/degree points.
  #   # samp2 is uniform sample
  # samp1 = sample(length(x), size = min(length(x), n)/2, prob = x+y)
  # samp2 = sample(length(x), size = min(length(x), n)/2)
  # samp is a mixture of both.
  # samp = c(samp1, samp2)  
  tibble(degree = x[samp], leverage = y[samp]) %>% 
    ggplot(aes(x=degree, y= leverage)) +
    geom_point(alpha = .05)+
    geom_smooth(se = F, method = "gam") + 
    scale_x_log10() + scale_y_log10()
}


# this returns the eigs of the regularized laplacian.
eigsL = function(A,k=5){
  n = nrow(A)
  deg = rowSums(A)
  D = Diagonal(n, 1/(sqrt(deg + mean(deg))))
  L = D%*%A
  L = L%*%D
  eigs(L,k)
}
