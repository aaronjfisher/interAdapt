###############################################################
#SETUP
###############################################################

library(shiny)
#setwd('/Users/aaronfisher/Documents/JH/Michael - Shiny App /new_gui/cuttlefish_gui/shinyApp')

#Load csv's with info about the input sliders & boxes
#then build lists of input sliders & boxes
#slider table & box table
st<-read.csv(file= "sliderTable.csv",header=TRUE,as.is=TRUE)
bt<-read.csv(file= "boxTable.csv",header=TRUE)

sliderList<-list()
boxList<-list()

#build the inputs that will be seen
#building sliders
for(i in 1:dim(st)[1]){
	sliderList[[i]]<-sliderInput(inputId=st[i,'inputId'], label=st[i,'label'], min=st[i,'min'], max=st[i,'max'], value=st[i,'value'], step=st[i,'step'], animate=st[i,'animate'])
}
names(sliderList)<-st[,'inputId']

#building numerical input boxes
for(i in 1:dim(bt)[1]){
	boxList[[i]]<-numericInput(inputId=bt[i,'inputId'], label=bt[i,'label'], min=bt[i,'min'], max=bt[i,'max'], value=bt[i,'value'], step=bt[i,'step'])
}
names(boxList)<-bt[,'inputId']
#SPECIAL NUMERIC BOX -- update the max automatically?
#probably better to just use an error message (NOTE)
# i<-which(names(boxList)=='last_stage_subpop_2_enrolled_adaptive_design')
# boxList[[i]]<-uiOutput('tns')

###############################################################
###############################################################






###############################################################
#SHINY FUNCTIONS
###############################################################

shinyUI(pageWithSidebar(###########################
  # Application title
  headerPanel("Eagle GUI Test"),

  # Sidebar with controls to select the variable to plot against mpg
  sidebarPanel(sliderList,boxList),


 mainPanel(
 	textOutput('errors')
  )

))#################################################