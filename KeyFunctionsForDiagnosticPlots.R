library(tidyverse)

# this is the key function. 
# if you have deg (i.e. degree) and lev (i.e. leverage)
#  already computed, then use this function.  
# if you have a massive graph, then you might want to subsample
#  to make the plot faster to build.  Be careful with this... you could
#  miss the pattern.  If you want to do this, uncomment the middle lines of code.
plotDegLev= function(degree, leverage, n = 100000){
  leverage = leverage[degree>0]
  degree= degree[degree>0]
  m = min(leverage[degree>5])
  M = max(leverage)
  samp = 1:length(degree)  # this will be overwrote and a subsample will be taken if you uncomment the next lines.
  #   # samp1 biases to high leverage/degree points.
  #   # samp2 is uniform sample
  # samp1 = sample(length(degree), size = min(length(degree), n)/2, prob = degree + leverage)
  # samp2 = sample(length(degree), size = min(length(degree), n)/2)
  # samp is a mixture of both.
  # samp = c(samp1, samp2)  
  tibble(degree = degree[samp], leverage = leverage[samp]) %>% 
    ggplot(aes(x=degree, y= leverage)) +
    geom_point(alpha = .05)+
    geom_smooth(se = F, method = "gam")+ 
    scale_x_log10() + scale_y_log10(limits = c(m,M))
 
}



plotDegLevReg= function(degree, leverage, n = 100000){
  leverage = leverage[degree>0]
  degree= degree[degree>0]
  
  
  dat = tibble(degree = degree, leverage = leverage)
  fit = lm(I(log(leverage))~I(log(degree)), subset = degree>5, data = dat)
  resid = log(leverage) - predict.lm(fit, dat)
  dat = bind_cols(dat, residuals = resid)
  
  m = min(resid[degree>5])
  M = max(resid)
  
  #   # samp1 biases to high leverage/degree points.
  #   # samp2 is uniform sample
  # samp1 = sample(length(degree), size = min(length(degree), n)/2, prob = degree + leverage)
  # samp2 = sample(length(degree), size = min(length(degree), n)/2)
  # samp is a mixture of both.
  # samp = c(samp1, samp2)  
  dat %>% 
    ggplot(aes(x=degree, y= residuals)) +
    geom_point(alpha = .05)+
    ggtitle(paste("   ", round(fit$coefficients[1],2),  " x deg ^", round(fit$coefficients[2],2)))+
    geom_smooth(se = F, method = "gam", data=subset(dat, degree >=7))+ 
    scale_x_log10() + ylim(m,M)
  
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
