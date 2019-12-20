#plays Rtridges
#do.call calls the function and takes in a list of arguments
#makeRtridge assures the argument list slots are named after the function parameters, so they can be passed easily to do.call
veeseeR <- function(x){
  do.call(attributes(x)$Function,x$args )
}
