#eveRest
source("../extilityBelt/zaWoruldo.R")

#Testing
#offset <- readRDS("test/mmus_offset.rds")
#scanOut <- readRDS("test/testOut.rds")
#annot <- readRDS("test/testAnnot.rds")
#pmap <- reaDRDS("test/pmap.rds")
#oneScan <- scanOut[,1, drop = F]

#Can select betwen dropLOD (default 1.8 lod for intercross studies) or Bayesian credible interval (default 95%) 
#Will work for different annotation files, as long as the match key for the lodcolumn is in the first column of the annotation file.
eveRest <- function(oneScan, thresh = NULL, map , annot, confType = "lod" ){
  library(qtl2)
  
  #If thresh null use 6 as default
  if(is.null(thresh)){
    thresh = 5
  }
  
  #scan must be a matrix
  if(!is.matrix(oneScan)){
    oneScan <- as.matrix(oneScan)
  }
  
  #Some checks before find_peaks
  if(is.null(oneScan)){
    return(NULL)
  }else if(nrow(oneScan)==0){
    return(NULL)
  }else if(max(oneScan) < thresh){
    return(NULL)
  }else{
    if(confType == "bayes"){
      peak <- find_peaks(oneScan, map = map, threshold = thresh, prob = 0.95)
    }else{
      peak <- find_peaks(oneScan, map = map, threshold = thresh, drop = 1.8)
    }
  }
  
  if(nrow(peak)==0){
    return(NULL)
  }
  ########Format peak object########
  cleanPeak <- peak[,-1]
  rm(peak)
  #Add markers
  cleanPeak$markers <- find_marker(map = map,
                                   cleanPeak$chr,
                                   cleanPeak$pos)
  #Format chromosome
  cleanPeak$chr <- as.character(cleanPeak$chr)
  cleanPeak$chr <- paste0("chr", cleanPeak$chr)
  
  #specify "pos" as local position, relative to chromosome
  names(cleanPeak)[3] <- "posLoc"
  
  #Append annotation info using the lodcol as the key
  addAnnot <- annot[match(cleanPeak[,1],annot[,1]), c(
                    "probe_chr",
                    "probe_start_loc",
                    "ENTREZID",
                    "SYMBOL",
                    "GENENAME")]
  cleanPeak <- cbind(cleanPeak, addAnnot)
  
  #Reformat annotation names to match qtl2 vernacular
  colnames(cleanPeak)[c(9, 12)] <- c("probe_posLoc", "DESC")
  cleanPeak <- cleanPeak[which(!is.na(cleanPeak$posLoc)),]
  cleanPeak$CT_loose <- ifelse(cleanPeak$chr == cleanPeak$probe_chr, "cis", "trans")
  
  #Add global positions
  cleanPeak$posGlob <- zaWoruldo(cleanPeak, 2, 3, offset)
  cleanPeak$probe_posGlob <- zaWoruldo(cleanPeak, 8, 9, offset)
  #Must take into account crossing chr in global mode  - set normally, then adjust
  chr_bound <- data.frame(lo = offset$offset - 4, hi = offset$offset +4)
  cleanPeak$CT_strict <- ifelse(cleanPeak$posGlob >= (cleanPeak$probe_posGlob - 4) & 
                                  cleanPeak$posGlob <= (cleanPeak$probe_posGlob + 4),"cis", "trans")
 
  #If cross-boundary, set eQTl to trans
  for(j in 1:nrow(cleanPeak)){
    pos <- cleanPeak$posGlob[j]  
    if(any(pos >= chr_bound$lo & pos <= chr_bound$hi)){
      cleanPeak$CT_strict[j] <- "trans"
    }
  }
  

  
  return(cleanPeak)
}

#########Use with full genome scan##########
#outlist <- list()

#pb <- txtProgressBar(min = 0, max = ncol(scanOut), style = 3)
#for(i in 1:ncol(scanOut)){
#  outlist[[i]] <- eveRest(scanOut[,i,drop = F], map = pmap, annot = annot)
#  setTxtProgressBar(pb, i)
#}
#close(pb)

#outlist[sapply(outlist, is.null)] <- NULL
#res <- do.call("rbind", outlist)

