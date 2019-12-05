#Convert genome positions to and from global format
#Useful for genome-wide plotting

#x = dataframe or matrix containing a chromosome/position pair for offsetting
#chr = column index of chromosome/position pair
#pos = column index of chromosome/position pair
#offset = offset dataframe with "chr" and "offset" columns as key:value pairs, format of chromosome must match 
#x$chr format, e.g.(chrom1, chr1, 1, etc...)
#unWorld = boolean, convert global positions to local positions wrt chromosome

zaWoruldo <- function(x, chr, pos, offset, unWorld = F){
  
  if(!(is.numeric(chr) & is.numeric(pos))){
    stop("Error: chr and pos must both be numeric column indices.")
  }
  
  #takes a vector of absolute positions and their chromosome, then uses offset values to convert to local positions
  off <- offset$offset[match(x[[chr]],offset$chr)]
  
  if(length(off) != length(x[[chr]])){
    stop("Error: offset mismatch")
  }
  if(unWorld == F){
    res <- x[,pos] + off
  }else{
    res <- x[,pos] - off
  }
  return(res)
}

cleanPeak$posGlob<- zaWoruldo(cleanPeak, 2, 3, offset)
cleanPeak$posGlobRev<- zaWoruldo(cleanPeak, 2, 14, offset, unWorld = T)
