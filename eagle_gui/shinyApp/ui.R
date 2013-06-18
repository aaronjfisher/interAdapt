## Subpopulation 1 proportion (Range: 0 to 1)
p1 <- 0.61

## Prob. outcome = 1 under control:
## for Subpop. 1 (Range: 0 to 1)
p10_user_defined <- 0.33
## for Subpop. 2 (Range: 0 to 1)
p20_user_defined <- 0.12

## Prob. outcome = 1 under treatment, at alternative:
## for Subpop. 1 (Range: 0 to 1)
p11_user_defined<- 0.33 + 0.125
## for Subpop. 2 (Range: 0 to 1)
p21_user_defined<- 0.12 + 0.125


# non-standard plot dimensions
width <- "90%"          # narrower
height <- "500px"       # more than 400

my_plotOutput <- function(...)
	plotOutput(..., width=width, height=height)

# NOTE: header element defaults to h3 instead of h1
my_headerPanel <- function (title, windowTitle = title, h=h3)
{
    tagList(tags$head(tags$title(windowTitle)), div(class = "span12", 
        style = "padding: 10px 0px;", h(title)))
}

# from Aaron
#Load csv's with info about the input sliders & boxes
#then build lists of input sliders & boxes
#slider table & box table


#Get the csv file either online or locally
getItOnline<-TRUE
try({
  source("Adaptive_Group_Sequential_Design.R", local=TRUE)
  st<-read.csv(file= "sliderTable.csv",header=TRUE,as.is=TRUE)
  bt<-read.csv(file= "boxTable.csv",header=TRUE,as.is=TRUE)
  cat("found code locally...", file=stderr())
  
  ################ action buttons
  ## No reason for all the action buttons to do the same thing, so
  ## we add the resource here once. 
  # Maybe we should test that ./actionbutton/actionbutton.js exists.
  # We have stolen this file from shinyIncubator.
  suppressMessages(addResourcePath(
      prefix='actionbutton', 
      directoryPath=file.path(getwd(), 'actionbutton')
  ))  
      
  # adapted from shinyIncubator, so we don't require that package
  my_actionButton <- function(inputId, label) {
    tagList(
      singleton(tags$head(tags$script(src = 'actionbutton/actionbutton.js'))),
      tags$button(id=inputId, type="button", class="btn action-button", label)
    )
  }
  ################
  getItOnline<-FALSE #if we haven't gotten an error yet!

},silent=TRUE)
try({
  if(getItOnline){

    library(devtools)
    library(RCurl)
    library(digest) #some reason this is a dependency not auto-loaded by devtools?
    st<-read.csv(text= getURL("https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/sliderTable.csv"),header=TRUE,as.is=TRUE)
    bt<-read.csv(text=getURL("https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/boxTable.csv"),header=TRUE,as.is=TRUE)
    source_url("https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/Adaptive_Group_Sequential_Design.R")
    
    # adapted from shinyIncubator, so we don't require that package
    my_actionButton <- function(inputId, label) {
      tagList(
        singleton(tags$head(tags$script(src = 'https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/actionbutton/actionbutton.js'))),
        tags$button(id=inputId, type="button", class="btn action-button", label)
      )
    }

    cat("found code online...", file=stderr())
  }
},silent=TRUE)


allVarNames<-c(st[,'inputId'],bt[,'inputId'])


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
################################

shinyUI(pageWithSidebar(
    
  my_headerPanel("Multi-stage design tool"),
  
  sidebarPanel(
	selectInput("Batch", "", c("Batch mode" = "1", Interactive = "2")),
	conditionalPanel(condition = "input.Batch == '1'",
		#textOutput("params"),
		my_actionButton("Parameters", "Apply"),
		br()),
	br(),
	sliderList,
	br(),
	boxList
  ),

  mainPanel(
  radioButtons("ComparisonCriterion", em(strong("Comparison criterion")),
	c(Designs = "1", Performance = "2")),	
  br(),
  conditionalPanel(condition = "input.ComparisonCriterion == '1'",
    #em(strong("Designs")),
    #br(), br(),
    tabsetPanel(
	tabPanel("Adaptive",
		tableOutput("adaptive_design_sample_sizes_and_boundaries_table")),
	tabPanel("Fixed, Total Population",
		br(), br(),
		tableOutput("fixed_H0C_design_sample_sizes_and_boundaries_table")),
	tabPanel("Fixed, Subpop. 1 only",
		br(), br(), br(), br(), br(),
		tableOutput("fixed_H0S_design_sample_sizes_and_boundaries_table")),
	tabPanel("All designs",
		tableOutput("adaptive_design_sample_sizes_and_boundaries_table.2"),
		tableOutput("fixed_H0C_design_sample_sizes_and_boundaries_table.2"),
		tableOutput("fixed_H0S_design_sample_sizes_and_boundaries_table.2"))
    )),
    #HTML("<hr>"),
    #em(strong("Performance comparisons")),
    #br(), br(),
  conditionalPanel(condition = "input.ComparisonCriterion == '2'",
    tabsetPanel(
	tabPanel("Power", my_plotOutput("power_curve_plot")),
	tabPanel("Sample Size", my_plotOutput("expected_sample_size_plot")),
	tabPanel("Duration", my_plotOutput("expected_duration_plot")),
	tabPanel("Overrunns", my_plotOutput("overruns"))
    ),
    br(),
    tableOutput("performance_table"))
  )
))
