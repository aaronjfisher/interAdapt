library(shiny)

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


################################

shinyUI(pageWithSidebar(
    
  my_headerPanel("Multi-stage design tool"),
  
  sidebarPanel(
	sliderList,
	br(),
	boxList
  ),

  mainPanel(
    em(strong("Designs")),
    br(), br(),
    tabsetPanel(
	tabPanel("Adaptive",
		tableOutput("adaptive_design_sample_sizes_and_boundaries_table")),
	tabPanel("Fixed, Total Population",
		br(), br(),
		tableOutput("fixed_H0C_design_sample_sizes_and_boundaries_table")),
	tabPanel("Fixed, Subpop. 1 only",
		br(), br(), br(), br(), br(),
		tableOutput("fixed_H0S_design_sample_sizes_and_boundaries_table"))
    ),
    HTML("<hr>"),
    em(strong("Performance comparisons")),
    br(), br(),
    tabsetPanel(
	tabPanel("Power", my_plotOutput("power_curve_plot")),
	tabPanel("Sample Size", my_plotOutput("expected_sample_size_plot")),
	tabPanel("Duration", my_plotOutput("expected_duration_plot")),
	tabPanel("Overrunns", my_plotOutput("overruns"))
    ),
    br(),
    tableOutput("performance_table")
  )
))
