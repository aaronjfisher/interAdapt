#install.packages(RCurl)
#install.packages(devtools)
#install.packages(digest)
#install.packages('stringr')
#install.packages('knitr')

#install.packages(c("httr", "RCurl", "memoise", "whisker", "evaluate"))
#download.file('http://cran.rstudio.com/src/contrib/Archive/devtools/devtools_1.1.tar.gz',
#              destfile='devtools_1.1.tar.gz')
#install.packages('devtools_1.1.tar.gz', type='source', repos=NULL)
#unlink('devtools_1.1.tar.gz')

library(shiny)
library(digest)
library(RCurl)
library(devtools)
library(stringr)

source_url('https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/ui.R')



