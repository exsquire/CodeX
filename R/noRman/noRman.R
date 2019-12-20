#One stop shop for normalizing numeric data using logs
#Note: Yes, this is very old fashioned and is meant to be used
#when a generalized linear model cannot be fit into your workflow.

#Test data
#library(ALL)
#data(ALL)
#test <- t(exprs(ALL))[,1:100]


norMan <- function(x, base = exp(1), offset = FALSE,offval = 1e-6, summary = FALSE){
  #Check if data is a numeric matrix
  if(!is.matrix(x) | !all(sapply(x, is.numeric))){
    stop("Must submit a numeric matrix")
  }
  #Check if data is suitable for log transformation
  if(any(x <= 0)){
    stop("Matrix contains values zero or less than zero.\n Set offset to TRUE.")
  }
  #If offset = TRUE, add the minimum + a very small number offval
  if(offset == TRUE){
    x <- apply(x,2, function(y) y + abs(min(y))+offval)
  }
  #Use shapiro test W to determine non-normal columns
  nonNorm <- function(x){
    apply(x, 2, function(x) shapiro.test(x)$statistic < 0.95)
  }
  if(any(nonNorm(x))){
    #Non-norms
    colnames(x)[nonNorm(x)]
    #Transform the non-normals and check for non-normality
    tmp <- x[,nonNorm(log(x[,nonNorm(x)], base))]
    #If log transformation makes them normal, apply a log transformation to non-normal columns
    
    #Bind them to the original data
  
    #Output new matrix with transformation summary
    
  }else{
    stop("W-statistic >= 0.95 in all variables.")
  }
}
