#input <- kernGeist("scan1")
#Ask which parameters to change
makeRtrige <- function(input, openType = FALSE){
  chooseArgs <- select.list(input, preselect = NULL, 
                            multiple = TRUE,
                            title = "Choose your arguments:")
  
  Rtridge <- list()
  for(i in seq_along(chooseArgs)){
    tmp <- chooseArgs[i]
    cat("=========================\n")
    cat("Argument", i ,":", tmp,"\n")
    argType <- ""
    if(openType == TRUE){
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
    }else{
      cat("=========================\n")
      cat("Enter path to argument input:\n")
    }
  }
  return(Rtridge)
}

#test <- makeRtrige(input)

