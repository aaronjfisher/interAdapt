library(shiny)
runApp('/Users/aaronfisher/Documents/JH/Michael - Shiny App /new_gui/github/eagle_gui/shinyApp')

runGitHub(repo='Adaptive_Shiny',user='aaronjfisher',subdir='eagle_gui/shinyApp')

source('https://raw.github.com/aaronjfisher/ADAMachine/master/lmstep.R')

runUrl("http://biostat.jhsph.edu/~hjaffee/Shiny/new_gui.tar")#Harris' Version
#https://github.com/aaronjfisher/Adaptive_Shiny/tree/master/eagle_gui

setwd('/Users/aaronfisher/Documents/JH/Michael - Shiny App /new_gui/github/eagle_gui/shinyApp')







###############################################################
###############################################################
###############################################################
#Aaron's Random Scratch


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

