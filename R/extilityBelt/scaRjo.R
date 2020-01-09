#scaRjo - a whitewashing tool
#Inputs data, creates dummy col and row names
#Permutes and noisifies the data, replaces non-numerics with dummy levels
scaRjo <- function(x){
  #permute rows
  x <- x[sample(nrow(x)),]
  
  #separate num and non-num
  numClass <- sapply(x,class) == "numeric" | sapply(x,class) == "integer"
  
  #Add random variation
  x[,numClass] <- apply(x[,numClass, drop = FALSE], 2, function(x) x + rnorm(length(x),0,3*var(x)))
  
  #Dummy the non-nums
  dumdum <- function(x){
    x <- factor(x)
    levels(x) = paste0("dummy",1:length(levels(x)))
    x
  }
  x[,!numClass] <- apply(x[,!numClass, drop = FALSE],2, dumdum)
  #strip names
  rownames(x) <- paste0("row_", seq(1:nrow(x)))
  colnames(x) <- paste0("col_", seq(1:ncol(x)))
  return(x)
}

#test <- scaRjo(iris)
