#ConveCorr
#Does, like, everything correlation-related (<-redundant?)
#Must input a numerical matrix
conveCorr <- function(dat, type = "pearson" ,alpha = 0.05, plot_order = "hclust", FDR_correct = F, mar = c(0,0,0,0)){
  #load libraries
  library(Hmisc)
  library(corrplot)
  library(stats)
  #Add custom code
  flattenCorrMatrix <- function(cormat, pmat) {
    ut <- upper.tri(cormat)
    data.frame(
      row = rownames(cormat)[row(cormat)[ut]],
      column = rownames(cormat)[col(cormat)[ut]],
      cor  =(cormat)[ut],
      p = pmat[ut]
    )
  }
  
  #convert data to matrix
  dat <- as.matrix(dat)
  tmp <- rcorr(dat, type = type)
  
  cor_r <- tmp$r
  cor_p <- tmp$P
  
  flat_mat <- flattenCorrMatrix(cor_r, cor_p)
  
  flat_mat <- as.data.frame(flat_mat)
  names(flat_mat)[c(1,2)] <- c("var1","var2")
  names(flat_mat)
  
  #If user wants FDR corrected, oblige the user. 
  if(FDR_correct == T){
    p.adj <- p.adjust(flat_mat$p, method = "BH")
    flat_mat <- cbind.data.frame(flat_mat, p.adj)
    flat_mat_sig <- flat_mat[which(flat_mat$p.adj <= alpha),]
    cor_p <- p.adjust(cor_p, method = "BH")
  }
  else{
    #subset the flattened matrix so that only significant values appear
    flat_mat_sig <- flat_mat[which(flat_mat$p <= alpha),]
  }
  
  #visualize 
  corrplot(cor_r, 
           type = "upper", 
           order = plot_order, 
           p.mat = cor_p, 
           insig = "blank", 
           mar = mar)
  
  
  if(type == "pearson"){
    print("Running Pearson Correlation")
  }
  else{
    print("Running Spearman Correlation")
  }
  
  return(flat_mat_sig)
  
}
