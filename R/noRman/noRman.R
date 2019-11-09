#One stop shop for normalizing numeric data using logs
norMan <- function(x, base = exp(1), offset = FALSE, summary = FALSE){
  #Check if data is a numeric matrix
  if(!is.matrix(x)){
    stop("Must submit a numeric matrix")
  }
  #Check if data is suitable for log transformation
  if(any(x <= 0)){
    stop("Matrix contains values zero or less than zero.\n Set offset to TRUE.")
  }
  #Use shapiro test W to determine non-normal columns
  nonNorm <- function(x){
    apply(x, 2, function(x) shapiro.test(x)$statistic < 0.95)
  }
  if(any(nonNorm(x))){
    #Transform the non-normals and check for non-normality
    tmp <- x[,nonNorm(log(x[,nonNorm(x)], base))]
    #If log transformation makes them normal, apply a log transformation to non-normal columns
    
    
    
    #Bind them to the original data
  
    #Output new matrix with transformation summary
    
  }else{
    stop("W-statistic >= 0.95 in all variables.")
  }
}
