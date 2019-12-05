#eveRest
scanOut <- readRDS("test/testOut.rds")
annot <- readRDS("test/testAnnot.rds")
pmap <- reaDRDS("test/pmap.rds")

oneScan <- scanOut[,24, drop = F]

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
                    "probe_stop_loc",
                    "ENTREZID",
                    "SYMBOL",
                    "GENENAME")]
  cleanPeak <- cbind(cleanPeak, addAnnot)
  cleanPeak <- cleanPeak[which(!is.na(cleanPeak$posLoc)),]
  cleanPeak$CT_loose <- ifelse(peak$chr == peak$probeChr, "cis", "trans")
  #cleanPeak$CT_strict <- 
  
  if(exists("error_probes")){
    print(error_probes)
  }
  return(peak)
}

#########Format final outlist##########
#library(pbapply)
#input <- list.files([inputfolder],full.names = T)
#peak_list <- pblapply(input, eveRest)

#output <- do.call("rbind", peak_list)
#Format output
#source("../../Extility_Belt/offsetter9000.R")

#Offset the marker positions - now for ci_lo and ci_hi, as well
#output <- offsetter9000(output, 4, 3, offset)
#output <- offsetter9000(output, 6, 3, offset)
#output <- offsetter9000(output, 7, 3, offset)

#Does the probePos need offsetting? check first
#output$probePos_Mbp <- output$probePos_Mbp/(1e+06)
#output <- offsetter9000(output, 8, 7,offset)

#output$CT <- ifelse(output$chr == output$probeChr, "cis","trans")
#output$lodindex <- NULL
#output$offset   <- NULL

#saveRDS(output, file = "DO2_addRes.rds")