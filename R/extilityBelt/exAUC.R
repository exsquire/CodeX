#AUCv2: Allow flexibility with number of draws, allow selection with check boxes
#Output a list of each row to visualize AUC, integrated vs default

#Generate Data
#a<- c(65,150,200,170,90)
#b<- c(75,175,120,70,50)
#c<- c(50,120,90,80,65)
#d <- c(100,90,80,60,40) #should have AUC = 0
#e <- c(10,10,10,10,10) #should have AUC = 4*300 = 1200
#testdf <- as.data.frame(rbind(a,b,c,d,e))
#names(testdf) <- paste0("t",time)

#Generate time vector
#time <- c(0,30,90,180,360)

exAUC <- function(x, time, iAUC = FALSE, expand = FALSE, allowNeg = FALSE){
  #Works on one row, apply it through dataframe
  dat <- unlist(x)

  if(iAUC == TRUE){
  #If not all elements return TRUE, one or more must be lower than baseline, if so, set those to baseline
    if(allowNeg == FALSE){   
      if(all(dat >= dat[1]) == FALSE){
        dat[which(dat < dat[1])] <- dat[1]
      }
    }  
  }  
  
  lb <- dat[-length(dat)]
  ub <- dat[-1]
  timeDiff <- time[-1] - time[-(length(time))]

  sideSum <- lb + ub
  if(identical(length(lb),length(ub),length(timeDiff)) == FALSE){
    stop("Error, time and concentration vectors unequal in length")
  }

  trapAreas <- (sideSum*timeDiff)/2

  if(iAUC == TRUE){
   #create vector to subtract from trapAreas
   sub <- dat[1]*timeDiff  
   trapAreas <- trapAreas -  sub
  }

  if(expand == TRUE){ #be extra AF here
      output <- list()
      output[["data"]] <- data.frame(lb = lb, ub = ub, timeDiff = timeDiff)
      output[["trapezoids"]] <- trapAreas
      output[["sum"]] <- sum(trapAreas)
      return(output)
    }else{
      return(sum(trapAreas))
    }
}

#apply(testdf,1,exAUC, time)

#Plot an example
#test <- exAUC(testdf[3,], time, expand = T, iAUC = T, allowNeg = T)
#plot(time,testdf[3,], type = "l")
#abline(v = time, h = testdf[3,1], col = "blue")
