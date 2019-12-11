#CT Plotter
#library
CTplot <- function(res, 
                   ptSize = 1.5, 
                   fntSize = 11,
                   ylab_shift = 0,
                   xlab_shift = 0){
  library(ggplot2)
  midpoints <-  c(97.7359855,  286.5285830,  457.6050350,  
                  615.8789330,  770.0503330,  920.8359480, 
                  1068.4249505, 1205.8462865, 1332.8444480,
                  1460.4894995, 1586.8782675, 1707.9840500, 
                  1828.2593805, 1950.9213220, 2065.3942865, 
                  2166.5200130, 2263.1175325, 2355.9624875, 
                  2432.0295900, 2548.2610225)
  
  offset <- data.frame(chr = paste0("chr", c(1:19, "X", "Y")), offset = c(0.000000, 195.471971, 377.585195,  
                                                                          537.624875,  694.132991,  845.967675,
                                                                          995.704221, 1141.145680, 1270.546893,
                                                                          1395.142003, 1525.836996, 1647.919539, 
                                                                          1768.048561, 1888.470200, 2013.372444, 
                                                                          2117.416129, 2215.623897, 2310.611168, 
                                                                          2401.313807, 2462.745373, 2633.776672), stringsAsFactors = F)
  
  chr_labels <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","X" )
  maxShade <- 2633.776672
  
  add <- c(offset$offset[2:20], maxShade)
  chr_shade <- data.frame(chr = offset$chr[1:20],
                          start = offset$offset[1:20], 
                          end = add)
  chr_shade2 <- chr_shade[c(1,3,5,7,9,11,13,15,17,19),]
  chr_shade3 <- chr_shade[c(2,4,6,8,10,12,14,16,18,20),]
  
  viz <- ggplot(data = res, aes(x = posGlob, y = probe_posGlob, color = CT_strict)) + geom_point(size = ptSize) + 
    theme_bw()+ 
    scale_x_continuous(limits = c(0,offset$offset[21]),breaks=midpoints, labels=chr_labels, expand=c(0, 0), minor_breaks=offset$offset) +
    scale_y_continuous(limits = c(0,offset$offset[21]), breaks=midpoints, labels=chr_labels, expand=c(0, 0), minor_breaks=offset$offset) + 
    labs(x = "Chromosome", y = "Chromosome") + 
    theme(text = element_text(size = fntSize),
          axis.title.x = element_text(margin = margin(t = xlab_shift, 
                                                      r = 0, 
                                                      b = 0, 
                                                      l = 0)),
          axis.title.y = element_text(margin = margin(t = 0, 
                                                      r = ylab_shift, 
                                                      b = 0, 
                                                      l = 0))) +
    geom_rect(data = chr_shade3,
              aes(xmin = start,
                  xmax = end,
                  ymin = -Inf, 
                  ymax = Inf, 
                  group = chr), 
              alpha = 0.2,inherit.aes = F) +
    geom_rect(data = chr_shade2,
              aes(ymin = start,
                  ymax = end,
                  xmin = -Inf,
                  xmax = Inf,
                  group = chr), 
              alpha = 0.2,inherit.aes = F)
  viz <- viz + scale_color_manual(values=c("dodgerblue2","black"), guide = FALSE) 
  return(viz)
}
#CTplot(mRes$addCov, ptSize = 1.5, fntSize = 20, xlab_shift = 10,ylab_shift = 10)

