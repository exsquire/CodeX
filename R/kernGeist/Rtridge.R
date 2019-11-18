#setwd("~/R/Parent/Extility_Belt/CodeX/R/kernGeist/")
#source("kernGeist.R")
input <- kernGeist("scan1")

#Ask which parameters to change
makeRtrige <- function(input){
  chooseArgs <- select.list(input, preselect = NULL, 
                            multiple = TRUE,
                            title = "Choose your arguments:")
  
  Rtridge <- list()
  for(i in seq_along(chooseArgs)){
    tmp <- chooseArgs[i]
    cat("=========================\n")
    cat("Argument", i ,":", tmp,"\n")
    argType <- ""
    while(!toupper(argType) %in% c("P", "N", "O", "E")){
        cat("=========================\n")
        argType <- readline("Select argument type: \n\n-path (P)\n-numeric (N)\n-object (O)\n-evaluate (E)\n")
      } 
      cat("Enter argument:\n")
      #Enter the path to your object - supports RDS only
      if(argType == "P"){
        Rtridge[["args"]][[tmp]] <- readRDS(readline())
      }
      #Accept an evaluation
      if(argType == "E"){
        Rtridge[["args"]][[tmp]] <- eval(parse(text = readline()))
      }
      #accept name of object from environment
      if (argType == "O"){
        Rtridge[["args"]][[tmp]] <- get(readline())
      }
      #numeric value
      if(argType == "N"){
        Rtridge[["args"]][[tmp]] <- as.numeric(readline())
    }
  }
  attr(Rtridge, "Function")<- attributes(input)$Function
  return(Rtridge)
}

#test <- makeRtrige(input)

