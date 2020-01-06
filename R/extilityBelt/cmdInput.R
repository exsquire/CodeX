#Example script for user prompts in command line 
#To test, >Rscript cmdInput.R
cat("What is your favorite color?\n")
col = readLines(file("stdin"),n=1)
cat("Great! I like ",col,",too!\n", sep = "")
