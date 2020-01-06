#This is the range inclusion formula: x1 <= y2 && y1 <= x2; 
#for range A, x1:x2, and range B, y1:y2, 
#when the x1 is less than or equal to y2, AND y1 
#is less than or equal to x2, the ranges overlap. 


#Below are the 4 possible ways valid ranges can overlap
#[x1]===========[x2]
#          [y1]===========[y2]

#          [x1]===========[x2]
#[y1]===========[y2]

#[x1]=======================[x1]
#        [y1]=======[y2]


#[y1]=======================[y2]
#        [x1]=======[x2]

#Returns an index vector for comp where overlap exists. 

ranger <- function(x1,x2,
                   y1,y2){
  stopifnot(x1 <= x2 & y1 <= y2)
  return(x1 <= y2 & y1 <= x2)
}

ranger(x1, x2, y1, y2)



