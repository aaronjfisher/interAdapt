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

pbreak<-HTML('<P CLASS=breakhere>')

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
  readHelpTabHTML<- paste0(readLines('help_tab.html'),collapse='')
  cat("found code locally...", file=stderr())

  #### action buttons
  # No reason for all the action buttons to do the same thing, so
  # we add the resource here once. 
  # Maybe we should test that ./actionbutton/actionbutton.js exists. #AF - this is now incoporated I think :)
  # We have stolen this file from shinyIncubator.
  # suppressMessages(addResourcePath(
  #     prefix='actionbutton', 
  #     directoryPath=file.path(getwd(), 'actionbutton')
  # ))  
      
  # # adapted from shinyIncubator, so we don't require that package
  # my_actionButton <- function(inputId, label) {
  #   tagList(
  #     singleton(tags$head(tags$script(src = 'actionbutton/actionbutton.js'))),
  #     tags$button(id=inputId, type="button", class="btn action-button", label)
  #   )
  # }
  ################
  getItOnline<-FALSE #if we haven't gotten an error yet!

},silent=TRUE)
try({
  if(getItOnline){

    library(devtools)
    library(RCurl)
    library(digest) #some reason this is a dependency not auto-loaded by devtools?
    library(stringr)
    gitDir<-"https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/"
    if(exists('appVersion')) {
      if(appVersion=='stable'){
        gitDir<-"https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp_stable/"
    }}
    st<-read.csv(text=getURL(paste0(gitDir,"sliderTable.csv")),header=TRUE,as.is=TRUE)
    bt<-read.csv(text=getURL(paste0(gitDir,"boxTable.csv")),header=TRUE,as.is=TRUE)
    source_url(paste0(gitDir,"Adaptive_Group_Sequential_Design.R"))
    readHelpTabRaw <-getURL(paste0(gitDir,"help_tab.html"))
    readHelpTabHTML<-str_replace_all(readHelpTabRaw,'\n','')

    #################
    # TO USE SHINY 0.5 instead of 0.6
    # Stolen from shinyIncubator
    # needs actionbutton/actionbutton.js
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
    actionButton <- my_actionButton
    #################

    cat("found code online...", file=stderr())
  }
},silent=TRUE)







#################################


allVarNames<-c(st[,'inputId'],bt[,'inputId'])

sliderList<-list()
boxList<-list()

#build the inputs that will be seen
#THIS IS NO LONGER USED!!!!?!?!: Since sliders & boxes are now dynamic objects defined in the server.
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



animationOptions(interval = 5000, loop = FALSE, playButton = NULL, pauseButton = NULL)






  #  _____ _     _               _____           _      
  # /  ___| |   (_)             /  __ \         | |     
  # \ `--.| |__  _ _ __  _   _  | /  \/ ___   __| | ___ 
  #  `--. \ '_ \| | '_ \| | | | | |    / _ \ / _` |/ _ \
  # /\__/ / | | | | | | | |_| | | \__/\ (_) | (_| |  __/
  # \____/|_| |_|_|_| |_|\__, |  \____/\___/ \__,_|\___|
  #                       __/ |                         
  #                      |___/                          




shinyUI(pageWithSidebar(


  my_headerPanel("Group Sequential, Adaptive Enrichment Design Planner"),  



    #      _     _      
    #     (_)   | |     
    #  ___ _  __| | ___ 
    # / __| |/ _` |/ _ \
    # \__ \ | (_| |  __/
    # |___/_|\__,_|\___|
                      
                      

  # "Advanced" forces batch mode
  sidebarPanel(
        #TOP PANEL

        selectInput("Which_params", "", c("Show basic parameters" = "1",
                "Show advanced parameters" = "2", "Show all parameters" = "3") ),

        #SAVE & LOAD
        conditionalPanel(condition="input.Which_params == '3'",
            br(),
            strong('Save current parameters to file:'),br(),
            downloadButton('downloadInputs', 'Save Inputs'),
            br(),br(),
            strong('Load previous parameters from file:'),
            fileInput('uploadData', '',
                    accept=c('text/csv', 'text/comma-separated-values,text/plain')),
            conditionalPanel(condition='false', #need to make this actually contional!?
              strong('Reset parameters to uploaded file:'),br(),
              actionButton(inputId='loadReset',label='Reset')
            ),
            strong("Current Parameters:")
          ),

        #INTERACTIVE MODE ONLY IF JUST SLIDERS
          #Note interactive mode is auto-disabled if you're not in the "just sliders" view
        conditionalPanel(condition= "input.Which_params== '1'",
          selectInput("Batch", "", c("Batch mode" = "1",
                "Interactive mode" = "2"))
        ),
        #BASIC SLIDERS
        conditionalPanel(condition = "input.Which_params == '1' || input.Which_params == '3'",
          #show apply button if you're in batch mode, or showing all inputs and batch mode is enforced
          conditionalPanel(condition='input.Batch== "1" || input.Which_params== "3" ',
            actionButton("Parameters1", "Apply")),
          #uiOutput('actionButton'),
          br(), br(),
          uiOutput('fullSliders')
        ),
        #ADVANCED BOXES
        conditionalPanel(condition = "input.Which_params == '2' || input.Which_params == '3'",
          #always show apply button
          actionButton("Parameters2", "Apply"),
          #uiOutput('actionButton'),
          br(), br(),
          uiOutput('fullBoxes'))
  ),


  # # "Advanced" forces batch mode
  # sidebarPanel(
  #       selectInput("Which_params", "", c("Basic parameters" = "1",
  #               "Advanced parameters" = "2")),
  #       conditionalPanel(condition = "input.Which_params == '1'",
  #               selectInput("Batch", "", c("Batch mode" = "1",
  #                       "Interactive mode" = "2")),
  #               conditionalPanel(condition = "input.Batch == '1'",
  #                       my_actionButton("Parameters", "Apply"),
  #                       br(), br()),
  #               sliderList),
  #       conditionalPanel(condition = "input.Which_params == '2'",
  #               my_actionButton("Parameters", "Apply"),
  #               br(), br(),
  #               boxList)
  # ),



  #                  _       
  #                 (_)      
  #  _ __ ___   __ _ _ _ __  
  # | '_ ` _ \ / _` | | '_ \ 
  # | | | | | | (_| | | | | |
  # |_| |_| |_|\__,_|_|_| |_|
                           
                           

  mainPanel(
  #INITIALIZE PAGE BREAK CODE
  HTML('<STYLE TYPE=text/css> P.breakhere {page-break-before: always} </STYLE>'),

  #WARNINGS
  h4(textOutput('warn1')),
  h4(textOutput('warn2')),
  h4(textOutput('warn3')),
  #br(),br(),

  #OUTPUT
  #???!?? need to add some more breaks in here to space out the download buttons.
  radioButtons("OutputSelection", em(strong("Output selection")),
  c("About EAGLE" = "1", Designs = "2", Performance = "3"), selected="About EAGLE"),
  
  br(), pbreak,

  conditionalPanel(condition = "input.OutputSelection == '1'",
    HTML(paste(readHelpTabHTML,collapse=''))),

  conditionalPanel(condition = "input.OutputSelection == '2'",
    em(strong("Designs")),
    #br(), br(),
    tabsetPanel(
    	tabPanel("Adaptive",
    		my_plotOutput("adapt_boundary_plot"),
        br(),pbreak,
        tableOutput("adaptive_design_sample_sizes_and_boundaries_table"),
        downloadButton('downloadDesignAD.1', 'Download table as csv'),br()),
    	tabPanel("Fixed, Total Population",
        my_plotOutput("fixed_H0C_boundary_plot"),
        br(),pbreak,
    		tableOutput("fixed_H0C_design_sample_sizes_and_boundaries_table"),
        downloadButton('downloadDesignFC.1', 'Download table as csv'),br()) ,
    	tabPanel("Fixed, Subpop. 1 only",
    		my_plotOutput("fixed_H01_boundary_plot"),
        br(),pbreak,
        tableOutput("fixed_H01_design_sample_sizes_and_boundaries_table"),
        downloadButton('downloadDesignFS.1', 'Download table as csv'),br()),
    	tabPanel("All designs",
    		tableOutput("adaptive_design_sample_sizes_and_boundaries_table.2"),
        pbreak,
    		tableOutput("fixed_H0C_design_sample_sizes_and_boundaries_table.2"),
        pbreak,
        tableOutput("fixed_H01_design_sample_sizes_and_boundaries_table.2"),
        br(),br(),downloadButton('downloadDesignAD.2', 'Download AD design table as csv'),
        br(),br(),downloadButton('downloadDesignFS.2', 'Download FS design table as csv'),
        br(),br(),downloadButton('downloadDesignFC.2', 'Download FC design table as csv')),
  selected="Adaptive")
  ),

  conditionalPanel( condition = "input.OutputSelection == '3'",
    tabsetPanel(
    	tabPanel("Power", my_plotOutput("power_curve_plot")),
    	tabPanel("Sample Size", my_plotOutput("expected_sample_size_plot")),
    	tabPanel("Duration", my_plotOutput("expected_duration_plot")),
    	tabPanel("Overruns", my_plotOutput("overruns")),
      selected='Power'),
    pbreak,
    tableOutput("performance_table"),
    downloadButton('downloadPerformance.1', 'Download table as csv')
  ),
  conditionalPanel(condition = "input.OutputSelection != '1'",
    br(),
    downloadButton('knitr', 'Generate report')
  ),
  br(),br() )
))
