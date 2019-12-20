#theDash
test <- sort(sample(seq(100), 75))

#There are 4 categories:
#seqL:sequential on the left only - KEEP
#seqR:sequential on the right only - KEEP
#none:sequential on neither side - KEEP
#both:sequential on both sides - DUMP

status <- numeric(length(test))
for(i in seq_along(test)){
  if(i == 1 | i == length(test)){
    status[i] <- test[i]
  }else if(test[i-1] == test[i]-1 & test[i+1] == test[i]+1){
    status[i] <- 0
  }else{
    status[i] <- test[i]
  }
}
#Compare to a single offset dummy
collapseDupes <- status[status!=c(status[-1], FALSE)]
res <- gsub(",0,","-",paste(collapseDupes, collapse = ","))
test
res


