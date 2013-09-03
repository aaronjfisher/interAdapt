#install.packages(RCurl)
#install.packages(devtools)
#install.packages(digest)
#install.packages(mvtnorm)

#install.packages(c("httr", "RCurl", "memoise", "whisker", "evaluate"))
#download.file('http://cran.rstudio.com/src/contrib/Archive/devtools/devtools_1.1.tar.gz',
#              destfile='devtools_1.1.tar.gz')
#install.packages('devtools_1.1.tar.gz', type='source', repos=NULL)
#unlink('devtools_1.1.tar.gz')

#make sure file size hasn't blown up absurdly.
#if not, write the current user time.
if(file.info("user_log.txt")$size < 1000000)
	cat(paste(date(),'\n'),file='user_log.txt',append=TRUE)


library(shiny)
library(digest)
library(RCurl)
library(devtools)

source_url('https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/server.R')
