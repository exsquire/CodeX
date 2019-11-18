#plays Rtridges
veeseeR <- function(x){
  do.call(attributes(x)$Function,x$args )
}
