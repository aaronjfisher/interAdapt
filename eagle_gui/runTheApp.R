rm(list=ls())
library(shiny)
runApp('/Users/aaronfisher/Documents/JH/Michael - Shiny App /new_gui/github/eagle_gui/shinyApp')


#test install of downloading it from github
myDir<-'/Users/aaronfisher/Documents/JH/Michael - Shiny App /new_gui/github/eagle_gui/test install/eagle_stable_solo-master'
runApp(myDir)

runGitHub(repo='Adaptive_Shiny',user='aaronjfisher',subdir='eagle_gui/shinyApp')

source('https://raw.github.com/aaronjfisher/ADAMachine/master/lmstep.R')

runUrl("http://biostat.jhsph.edu/~hjaffee/Shiny/new_gui.tar")#Harris' Version
runUrl("http://biostat.jhsph.edu/~hjaffee/Shiny/gui10.tar")

#https://github.com/aaronjfisher/Adaptive_Shiny/tree/master/eagle_gui

setwd('/Users/aaronfisher/Documents/JH/Michael - Shiny App /new_gui/github/eagle_gui/shinyApp')


H0Ctext<-as.character(div(HTML("H<sub>0C</sub>")))



###############################################################
###############################################################
###############################################################
###############################################################



library(tools)
setwd('/Users/aaronfisher/Documents/JH/Michael - Shiny App /new_gui/github/eagle_gui/shinyApp/sweaveTest')
Sweave('Sweave-test-1.Rnw')
texi2pdf("Sweave-test-1.tex",pdf=TRUE)


testfile <- system.file("Sweave", "Sweave-test-1.Rnw", package = "utils")

## enforce par(ask = FALSE)
options(device.ask.default = FALSE)

## create a LaTeX file
Sweave(testfile)

## This can be compiled to PDF by
## tools::texi2pdf(Sweave-test-1.tex)
## or outside R by
## R CMD texi2pdf Sweave-test-1.tex
## which sets the appropriate TEXINPUTS path.

tools::texi2pdf("Sweave-test-1.tex")
tools::texi2dvi("Sweave-test-1.tex", pdf=TRUE, quiet=FALSE)

## create an R source file from the code chunks
Stangle(testfile)
## which can be sourced, e.g.
source("Sweave-test-1.R")


#Aaron's Random Scratch

print(xtable(m),type='html')


subH0 <- function(x){ #make a function that does the same thing as "strong()" but for <sub></sub>
#finds all H0C and H0S terms and subs them!
  x <- strong(x)
  x <- gsub("<strong>", "", x)
  x <- gsub("</strong>", "", x)
  x <- gsub("H0C", "H<sub>0C</sub>", x)
  x <- gsub("H0S", "H<sub>0S</sub>", x)
  return(x)
}

subH0sanitize<-function(x){
  x <- gsub("H0C", "H<sub>0C</sub>", x)
  x <- gsub("H0S", "H<sub>0S</sub>", x)
  return(x)
}

plot(0,0,main=expression(paste('h'[g],' z'[h])))

library(xtable)
adf.results<-matrix(0,ncol=2,nrow=2)
colnames(adf.results) <- c( "H0C:AD","$R^r_t$")
print(xtable(adf.results),type='html')
print(xtable(adf.results),sanitize.text.function=subH0sanitize,type='html')

require(graphics)
(s.e <- substitute(expression(a + b), list(a = 1)))  #> expression(1 + b)
(s.s <- substitute( a + b,            list(a = 1)))  #> 1 + b
c(mode(s.e), typeof(s.e)) #  "call", "language"
c(mode(s.s), typeof(s.s)) #   (the same)
# but:
(e.s.e <- eval(s.e))          #>  expression(1 + b)
c(mode(e.s.e), typeof(e.s.e)) #  "expression", "expression"

substitute(x <- x + 1, list(x = 1)) # nonsense

myplot <- function(x, y)
    plot(x, y, xlab = deparse(substitute(x)),
         ylab = deparse(substitute(y)))

## Simple examples about lazy evaluation, etc:

f1 <- function(x, y = x)             { x <- x + 1; y }
s1 <- function(x, y = substitute(x)) { x <- x + 1; y }
s2 <- function(x, y) { if(missing(y)) y <- substitute(x); x <- x + 1; y }
a <- 10
f1(a)  # 11
s1(a)  # 11
s2(a)  # a
typeof(s2(a))  # "symbol"

#old stuff for debuggin
  output$uptable<-renderTable({
    upFile <- input$uploadData
        if (is.null(upFile))
      return(NULL)

    x<-c(read.csv(file=upFile$datapath, row.names=1, header=FALSE))[[1]]
    names(x)<-allVarNames
    browser()

    #print(x)
    data.frame(x)
    })


  
title1=expression(atop("Interannual variability in"~delta^1~C[3]~ratios, 
                       "in"~fish~samples))
plot(1,1, main=title1)
legend('bottomright',c(title1,title1))

#define all three of these things in Michael's script if we want, then they'll be sourced when we source that script.
#add evalText(argDefText) to the start of each function.
argDefText<-      paste(paste0(allVarNames,' <- ',allVarNames,'()'),   collapse='; ')
varAssignText<-   paste(paste0(allVarNames,' <- reactive({ input$',allVarNames,' })'), collapse='; ')
#argCallText<-     paste(paste0(allVarNames,' =' ,allVarNames,'())'),  collapse=', ')
evalText<-function(t) {eval(parse(text=t))}
evalText(varAssignText)
evalText(argDefText)

argDefText<- 'x=2'
testFun<-function(){
  evalText(argDefText)

}
fun1<-funArgs('print(x+2)')


  renderTable({
	T.adaptive[[1]]
  }, digits=T.adaptive$digits, caption=T.adaptive$caption)
		
  output$fixed_H0C_design_sample_sizes_and_boundaries_table <-
	renderTable({
    regen()
		T.fixed_H0C[[1]]
  }, digits=T.fixed_H0C$digits, caption= T.fixed_H0C$caption)

  output$fixed_H0S_design_sample_sizes_and_boundaries_table <-renderTable({
    regen()
    T.fixed_H0S[[1]]
  },digits=T.fixed_H0S$digits, caption=T.fixed_H0S$caption)
#build the inputs that will be seen
#building sliders
for(i in 1:dim(st)[1]){
  sliderList[[i]]<-sliderInput(inputId=st[i,'inputId'], label=st[i,'label'], min=st[i,'min'], max=st[i,'max'], value=st[i,'value'], step=st[i,'step'], animate=st[i,'animate'])
 if(is.na(st[i,'step'])){
   sliderList[[i]]$step<-(st[i,'max']-st[i,'min'])/20
   print('hi')
 }
}
names(sliderList)<-st[,'inputId']

#building numerical input boxes
for(i in 1:dim(bt)[1]){
  boxList[[i]]<-numericInput(inputId=bt[i,'inputId'], label=bt[i,'label'], min=bt[i,'min'], max=bt[i,'max'], value=bt[i,'value'], step=bt[i,'step'])
 if(is.na(bt[i,'step'])){
   boxList[[i]]$step<-(bt[i,'max']-bt[i,'min'])/20
   print('hi')
 }  
}
names(boxList)<-bt[,'inputId']

