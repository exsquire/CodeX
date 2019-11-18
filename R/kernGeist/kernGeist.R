#Input function
#library(qtl2)
kernGeist <- function(input = ""){
  funcName <- input
  if(exists(input, mode = "function")){
    sink("funArgs.txt")
    str(args(input))
    sink()
  }else{
    stop("Error: Function does not exists.")
  }
  
  rawArgs <- readChar("funArgs.txt",
                      file.info("funArgs.txt")$size)
  
  unlink("funArgs.txt")
  #remove "..."
  f0 <- gsub("\\.\\.\\.", "", rawArgs)
  #remove function call text prefix
  f1 <- gsub("^function \\(|",
             "",f0)
  #remove function call text suffix
  f2 <- gsub('(.*)\\).*$', '\\1', f1)
  #Remove newlines, carriage returns, and spaces
  f3 <- gsub("\r\n","",f2)
  #Replace multiple value arg defaults with NULL
  f4 <- gsub("c\\(.*\\)","NULL",f3)
  #Remove anything that is not an alphanumeric or a   common punctuation in naming arguments
  f5 <- gsub("[^[:alnum:],\\.=_]","",f4)
  #Remove any equal sign and trailing alphanumerics, preserving commas
  argList <- unlist(strsplit(gsub("=[[:alnum:]]*",
                                  "",f5),","))
  #Add funcName as attr
  attr(argList, "Function") <- funcName
  #return
  argList
}  


kernGeist("calc_genoprob")
