
library(quantmod)

# get exchange rates
EUR <- getFX("EUR/PLN",from="2014-01-01", auto.assign = FALSE)
USD <- getFX("USD/PLN",from="2014-01-01", auto.assign = FALSE)
GBP <- getFX("GBP/PLN",from="2014-01-01", auto.assign = FALSE)
CHF <- getFX("CHF/PLN",from="2014-01-01", auto.assign = FALSE)

# calculate daily returns
EUR <- dailyReturn(EUR)
EUR <- 100.0*EUR[2:length(EUR)]
USD <- dailyReturn(USD)
USD <- 100.0*USD[2:length(USD)]
GBP <- dailyReturn(GBP)
GBP <- 100.0*GBP[2:length(GBP)]
CHF <- dailyReturn(CHF)
CHF <- 100.0*CHF[2:length(CHF)]

bandWidthMethods <- c("nrd0", "nrd", "ucv", "bcv", "SJ-ste", "Sj-dpi")
kernelMethods <- c("gaussian", "epanechnikov", "rectangular", "triangular", "biweight", "cosine", "optcosine")
adjustBandWidth <- c(1.0 ,0.25, 4.0)

# plot histogram with bandwidth selection methods
bandWidthMethodsChart <- function(symbol, bwm, Max)
{
  #colors <- c(NA)
  for (i in 1:length(bwm))
  {
    dens <- density(symbol, bw=bwm[i])
    # We must correct if Max for histogram is < Max for density
    if (Max < max(dens$y))
    {
      Max <-  max(dens$y) 
    }
    Max <- Max;
  }
  # We plott histogram
  hist(symbol, probability=TRUE,ylim=c(0,Max),main=names(symbol), col="lightblue")
  for (i in 1:length(bwm))
  {
    # We plot lines of density
    lines(density(symbol, bw=bwm[i]), col=i, lwd=2) 
  }
  #leg <- c("Histogram", bwm)
  #lty <- c(NA)
  n <- length(bwm)
  colors <- 1:n
  lty <- rep(1,n)
  lwd <- rep(2,n)
  pch <- rep(NA,n)
  # We add legend
  legend("topright",legend=c("Histogram",bwm),lty=c(NA,lty), lwd=c(NA,lwd), pch = c(15,pch), col = c("lightblue", colors),
         merge=TRUE,inset=.01,cex=1.1,adj=0, text.font=1)
}

# plot histogram with kernel function methods
kernelMethodsChart <- function(symbol, kernels, Max)
{
  for (i in 1:length(kernels))
  {
    dens <- density(symbol, kernel=kernels[i])
    # We must correct if Max for histogram is < Max for density
    if (Max < max(dens$y))
    {
      Max <-  max(dens$y) 
    }
    Max <- Max; 
  }
  # We plott histogram
  hist(symbol, probability=TRUE,ylim=c(0,Max),main=names(symbol), col="lightblue")
  # We plot lines of density
  for (i in 1:length(kernels))
  {
    lines(density(symbol, kernel=kernels[i]), col=i, lwd=2) 
  }
  n <- length(kernels)
  colors <- 1:n
  lty <- rep(1,n)
  lwd <- rep(2,n)
  pch <- rep(NA,n)
  # We add legend
  legend("topright",legend=c("Histogram",kernels),lty=c(NA,lty), lwd=c(NA,lwd), pch = c(15,pch), col = c("lightblue", colors),
         merge=TRUE,inset=.01,cex=.9,adj=0)
}


