#BUGS!
#When you load new data, the back boxes and sliders don't finish updating until you look at both of them!
  #Add some form of the inValues to the dummyText?


cat("source'ing code...", file=stderr())

#Get the csv file either online or locally
getItOnline<-TRUE
try({
  source("Adaptive_Group_Sequential_Design.R", local=TRUE)
  st<-read.csv(file= "sliderTable.csv",header=TRUE,as.is=TRUE)
  bt<-read.csv(file= "boxTable.csv",header=TRUE,as.is=TRUE)
  getItOnline<-FALSE #if we haven't gotten an error yet!
  cat("found code locally...", file=stderr())
},silent=TRUE)
try({
  if(getItOnline){
    library(devtools)
    library(RCurl)
    library(digest) #some reason this is a dependency not auto-loaded by devtools?
    st<-read.csv(text= getURL("https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/sliderTable.csv"),header=TRUE,as.is=TRUE)
    bt<-read.csv(text=getURL("https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/boxTable.csv"),header=TRUE,as.is=TRUE)
    source_url("https://raw.github.com/aaronjfisher/Adaptive_Shiny/master/eagle_gui/shinyApp/Adaptive_Group_Sequential_Design.R")
    cat("found code online...", file=stderr())
  }
},silent=TRUE)

cat("...got code!...", file=stderr())

allVarNames<-c(st[,'inputId'],bt[,'inputId'])



for(i in 1:dim(st)[1]){
  assign(st[i,'inputId'], st[i,'value'])
}
for(i in 1:dim(bt)[1]){
  assign(bt[i,'inputId'], bt[i,'value']) 
}






shinyServer(function(input, output) {
  Apply_button <- -1
  totalcalls<-0 #a place keeper to watch when we cat to stderr
  regenCalls<-0
  uploadFileTicker<-0
  lastLoadReset<-0
  inValues<-NULL

  params<-reactive({input$Parameters1 + input$Parameters2})


  #LOADING DATA
  #a reactive chunk to feed to the dynamicBoxes & dynamicSliders
  regenUpload<-reactive({
    upFile <- input$uploadData
    x<-NULL
    if (!is.null(upFile)){
      x<-c(read.csv(file=upFile$datapath, row.names=1, header=FALSE))[[1]]
      names(x)<-allVarNames
      #regenCalls<-0
      uploadFileTicker<<-0
      output$uploadTime<<-renderText({as.character(Sys.time())})
      print('resetting upload')
    }
    inValues<<-x
  })

  regenLoadReset<-reactive({
    dummy<-input$loadReset
  })



  #current value of all the data, need to store this if we want to change the sliders to all be animated in interactive mode, but not change their values.
  allVars<-reactive({
      x<-c()
      for(i in 1:length(allVarNames)) x[allVarNames[i]]<- input[[allVarNames[i] ]]
      x
    })

  #update for error: if you isolate the animate change, the animate won't change until you add a new file :/. Here we fix it by adding a uploadFileTicker that tracks if it's the first time the sliders have been updated since the last time we uploaded a file. Only if it's the first time do we change the sliders to the uploaded values. If it's not the first time, we use the current value of the variable, taken from allVars.
  sliders <- reactive({ #NOTE: if you upload the same file again it won't update b/c nothing's techincally new!!!
    print('sliders')
    regenUpload()
    #browser()
    sliderList<-list()
    animate<-FALSE
    if(input$Batch=='2') animate<-TRUE 
    for(i in 1:dim(st)[1]){
      value_i<-st[i,'value']
      if((!is.null(inValues)) ) value_i<-inValues[st[i,'inputId']]
      if(uploadFileTicker>0)    value_i<-allVars()[st[i,'inputId']]
      sliderList[[i]]<-sliderInput(inputId=st[i,'inputId'], label=st[i,'label'], min=st[i,'min'], max=st[i,'max'], value=value_i, step=st[i,'step'], animate=animate)
    }
    uploadFileTicker<<-uploadFileTicker+1
    print('           sliders updating!!!!!!')
    print(sliderList[[1]])
    sliderList
  })
  #Need to make a small version to ensure that both update immediately.
  output$fullSliders<-renderUI({sliders()})
  output$smallSliders<-renderText({
    as.character(sliders())
  })


  boxes <- reactive({ #NOTE: if you upload the same file again it won't update b/c nothing's techincally new!!!
    print('                    boxes')
    #browser()
    regenUpload()
    #dummy<-input$uploadData
    #dummy2<-input$loadReset
    boxList<-list()
    for(i in 1:dim(bt)[1]){
      value_i<-bt[i,'value']
      if( (!is.null(inValues)) ){ value_i<-inValues[bt[i,'inputId']]}
      boxList[[i]]<-numericInput(inputId=bt[i,'inputId'], label=bt[i,'label'], min=bt[i,'min'], max=bt[i,'max'], value=value_i, step=bt[i,'step'])
      #print(value_i)
    }
    #browser()
    boxList
  })
  #Need to make a small version to ensure that both update immediately.
  output$fullBoxes<-renderUI({boxes()})
  output$smallBoxes<-renderText({
    as.character(boxes())
  })

  # output$showReset<-reactive({
  #     x<-0
  #     if(!is.null(inValues())) x<-1
  #     browser()
  #     x
  #   })

    # boxList<-list()
    # for(i in 1:dim(bt)[1]){
    #   value_i<-bt[i,'value']
    #   if(!is.null(inValues() )) value_i<-inValues()[bt[i,'inputId']]
    #   boxList[[i]]<-sliderInput(inputId=bt[i,'inputId'], label=bt[i,'label'], min=bt[i,'min'], max=bt[i,'max'], value=value_i, step=bt[i,'step'])
    # }
    # boxList
  

# # Partial example
# output$cityControls <- renderUI({
#   # cities <- input$iter
#   # list(numericInput("cities", "Choose Cities", value=inValues()[11])  ,numericInput("cities", "Choose Cities", value=inValues()[12])  )
#     i<-1
#     value_i<-bt[i,'value']
#     if(!is.null(inValues() )) value_i<-inValues()[bt[i,'inputId']]
#     boxList<-numericInput(inputId=bt[i,'inputId'], label=bt[i,'label'], min=bt[i,'min'], max=bt[i,'max'], value=value_i, step=bt[i,'step'])
#     boxList
# })

  # output$actionButton<-renderUI({
  #   actionButton("Parameters", "Apply")
  #   })



  # In interactive mode, we re-export the parameters and rebuild table1
  # every time.  In batch, only on the first call for a given push of the
  # Apply button.
  regen <- function(apply_button_value, caller='no caller specified') {
#cat("regen:", input$Batch, "\n", file=stderr())

  totalcalls<<-totalcalls+1
  print(paste('total calls =',totalcalls))
  print(paste('regenCalls =',regenCalls))
  print(paste('caller =',caller))
  print(paste('apply_button_value =',apply_button_value))

  if(is.null(input$Batch) || is.null(apply_button_value))
    {print('regen out') ; return()}

  for(name in allVarNames){
     if(is.null(input[[name]])) {print('null regen Input');return()}
  }

	if (input$Batch == "1" && apply_button_value <= Apply_button)
	    return()
  if (input$Batch == "2" && regenCalls>0 ){
      return()
  }

	if (input$Batch == "1"){
    isolate(for(i in 1:length(allVarNames))
  		assign(allVarNames[i], input[[allVarNames[i]]], inherits=TRUE)
    )
  } else {
    for(i in 1:length(allVarNames)){
	    assign(allVarNames[i], input[[allVarNames[i]]], inherits=TRUE)
      print(input[[allVarNames[i]]])
    }
  }

  #browser()
  cat("making table1 ...")
  table1 <<- table_constructor()
  cat("Done\n")

	if (input$Batch == "1")
		Apply_button <<- apply_button_value
  }

# apply_button <- quote({
# 	val <- params()
# 	if (val == 0)
# 		return("")
# 	regen(val)
# 	#as.character(val)
# 	""
# })
# output$params <- renderText(apply_button, quoted=TRUE)
  
  refresh<-function(){ # a function requires use of all inputs. This is meant to be used to make a code chunk reactive to everything
    #in interactive mode, I think the code shiny sees for regen isn't "reactive enough" but adding this function to a plot call makes the plot update as desired (in interactive mode).
    #if(input$Batch == "2"){
      for(name in allVarNames) if(is.null(input[[name]])) return()
      
      #browser()
      storeInputChar<<-rep('',length=length(allVarNames))
      for(i in 1:length(allVarNames)){
            storeInputChar[i]<<-as.character(input[[allVarNames[i] ]])
      }
      #if(!is.null(input$uploadData)) storeInputChar[length(storeInputChar)+1] <- as.character(input$uploadData)
      storeInputChar[length(storeInputChar)+1] <- as.character(input$loadReset)
      storeInputChar[length(storeInputChar)+1] <- as.character(lastLoadReset)
      storeInputChar[length(storeInputChar)+1] <- input$loadReset>lastLoadReset
      return(paste(storeInputChar,collapse=' '))
    #}
  }


  output$dummyText<-renderText({ #We want to call regen only once.
    #I'm not sure what it means that this reactive chunk always seems to be "evaluated first"
    print('resetting regenCalls')
    regenCalls<<-0
    regen(params(),caller='dummy')
    print('adding to regenCalls')
    regenCalls<<-1
    substr(refresh(),0,0) #ADDING EXTRA STUFF HERE TO MAKE IT VISIBLE.
    #refresh()
  })


  output$power_curve_plot <- renderPlot({
	regen(params(),caller='power_curve_plot') #NOTE! adding a "if(input$Batch=='1')" qualifier to this regen call appears to not change anything, since regen exists under anyother conditions thanks for the regenCalls resetting
  refresh()
	power_curve_plot()
  })

  output$expected_sample_size_plot <- renderPlot({
	regen(params(),caller='expected_sample_size_plot')
  refresh()
	expected_sample_size_plot()
  })

  output$expected_duration_plot <- renderPlot({
	regen(params(),caller='expected_duration_plot')
  refresh()
	expected_duration_plot()
  })

  #overruns <- function() plot(1:2, main="Overruns")
  output$overruns <- renderPlot({
	regen(params(),caller='overruns')
  refresh()
	overrun_plot()
  })

# HJ - x must be a list of length 3, with a digits and caption
xtable <- function(x) {
	xtable::xtable(x[[1]], digits=x$digits, caption=x$caption) #NEED TO EXPAND HERE!!
}

# HJ - see shiny:::htmlEscape (why is this necessary?)
renderTable <- function (expr, ..., env = parent.frame(), quoted = FALSE, func = NULL, include.colnames=TRUE) 
{
    if (!is.null(func)) {
        shinyDeprecated(msg = "renderTable: argument 'func' is deprecated. Please use 'expr' instead.")
    }
    else {
        func <- exprToFunction(expr, env, quoted)
    }
    function() {
        classNames <- getOption("shiny.table.class", "data table table-bordered table-condensed")
        data <- func()
        if (is.null(data) || identical(data, data.frame())) 
            return("")
        return(paste(capture.output(print(xtable(data, ...), include.colnames=include.colnames, 
            type = "html", html.table.attributes = paste("class=\"", 
                #htmlEscape(classNames, TRUE), "\"", sep = ""), 
                shiny:::htmlEscape(classNames, TRUE), "\"", sep = ""), 
            ...)), collapse = "\n"))
    }
}

  output$adaptive_design_sample_sizes_and_boundaries_table.2 <-
  output$adaptive_design_sample_sizes_and_boundaries_table <- renderTable({    
	regen(params(),caller='adaptive_table')
  refresh()  
	adaptive_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0C_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0C_design_sample_sizes_and_boundaries_table <- renderTable({
	regen(params(),caller='HOC_table')
  refresh()
	fixed_H0C_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0S_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0S_design_sample_sizes_and_boundaries_table <-renderTable({
	regen(params(),caller='HOS_table')
  refresh()
	fixed_H0S_design_sample_sizes_and_boundaries_table()
  })

  output$performance_table <- renderTable(expr={
	regen(params(),caller='performance_table')
  refresh()
	transpose_performance_table(performance_table())
    },include.colnames=FALSE)


  #SAVE DATA:
  output$downloadData <- downloadHandler(
    filename =  'inputs.csv',
    content = function(file) {
      inputCsv<-rep('',length=length(allVarNames))
      for(i in 1:length(allVarNames)) inputCsv[i]<- input[[ allVarNames[i] ]]
      write.table(inputCsv, file, row.names=allVarNames, col.names=FALSE, sep=',')
    }
  )

})
