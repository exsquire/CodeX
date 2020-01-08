#Base R Data melter for ggplots
#Takes in wideform dataframe with numeric/integer columns and descriptive columns, outputs longform data
#Separates the numeric and non-numeric data
#For numeric data, concats the numeric rows to form the "value" column, reps the colnames per nrow
#Iterates through non-numeric data columns, within column, iterates through rows, repping the row value by ncol(numDF)
#cbinds list of "variable", "value", and non-numeric data vectors. 

gruyere <- function(x){
  classFilt <- sapply(x, class) == "numeric" | sapply(x, class) == "integer"
  numDF <- x[,classFilt]
  etcDF <- x[,!classFilt]
  
  #multiply the colnames by the number of rows
  var <- rep(colnames(numDF), nrow(numDF))
  
  #concat all the rows
  val <- numeric()
  for(i in 1:nrow(numDF)){
    val <- c(val, as.numeric(numDF[i,]))
  }
  #Process the etc data, rep for each col in numDF
  etcList <- list()
  for(j in 1:ncol(etcDF)){
    desig <- colnames(etcDF)[j]
    tmp1 <- etcDF[,desig]
    etcMelt <- c()
    for(k in tmp1){
      etcMelt <- c(etcMelt, rep(k, ncol(numDF)))
    }
    etcList[[desig]] <- etcMelt
  }
  etcList[["value"]] <- val
  etcList[["variable"]] <- var
  #stop if all vector lengths are NOT the same
  stopifnot(length(unique(sapply(etcList, length))) == 1)
  return(do.call("cbind", etcList))
}

