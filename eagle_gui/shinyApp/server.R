#BUGS!
# Add Michael's Warnings
# Add a checkbox to autoupdate new parameters, or a warning saying they're not yet applied.
# Need to make sure the initialized image is set correctly. 
    # For beta testing it's just commented out to maintain consistency.

#############################################
#############################################
# PREAMBLE
#############################################
#############################################


subH0 <- function(x){ #make a function that does the same thing as "strong()" but for <sub></sub>
#finds all H0C and H0S terms and subs them!
  x <- strong(x)
  x <- gsub("<strong>", "", x)
  x <- gsub("</strong>", "", x)
  x <- gsub("H0C", "H<sub>0C</sub>", x)
  x <- gsub("H0S", "H<sub>0S</sub>", x)
  return(x)
}

#To be used in our xtable function!
subH0sanitize<-function(x){
  x <- gsub("H0C", "H<sub>0C</sub>", x)
  x <- gsub("H0S", "H<sub>0S</sub>", x)
  return(x)
}



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
allVarLabels<-c(st[,'label'],bt[,'label'])
lastAllVars<-rep(0,length(allVarNames))
names(lastAllVars)<-allVarNames

for(i in 1:dim(st)[1]){
  assign(st[i,'inputId'], st[i,'value'])
  lastAllVars[st[i,'inputId']] <- st[i,'value']
}
for(i in 1:dim(bt)[1]){
  assign(bt[i,'inputId'], bt[i,'value']) 
  lastAllVars[bt[i,'inputId']] <- bt[i,'value']
}

#table1 <- table_constructor() #getting error in x y length differing when we call plots the first time, if we call table_constructor too soon?





#THIS LAST BIT HAS BEEN TRICKY TO GET WORKING! Maybe better to start with just a 
# whole image file, but for beta testing just leave it as is.

# buildTable1Now<-TRUE
# if(!getItOnline){
#   try({
#     load(file='initialized_image_&_table1.RData')
#     cat("loaded table1 & image...", file=stderr())
#     buildTable1Now<-FALSE
#   })
# }
# if(buildTable1Now){
#   table1 <- table_constructor()
#   cat("built table1...", file=stderr())
# }
# Saving table1 for future use
# iter<-10000
# save.image(file='initialized_image_&_table1.RData')





#############################################
#############################################
# END OF PREAMBLE
#############################################
#############################################




shinyServer(function(input, output) {


  #############################################
  #############################################
  # Initialize some static & reactive variables
  #############################################
  #############################################


  lastApplyValue <- -1
  totalCalls<-0 #a place keeper to watch when we cat to stderr
  uploadFileTicker<-0
  inValues<-NULL

  #current value of all the data, need to store this if we want to change the sliders to all be animated in interactive mode, but not change their values.
  #all used a comparison against static lastAllVars
  #Also do error checks for invalid inputs
  allVars<-reactive({
    x<-c()
    for(i in 1:length(allVarNames)) x[allVarNames[i]]<- input[[allVarNames[i] ]]

    #Check to make sure all box inputs are within the required ranges. 
    #Don't need to do this for sliders, since you can't set them past the min/max
    minMaxErrs<-rep('',dim(bt)[1]) #vector to store error/warnings messages. The ith entry is '' if allVars()[i] is valid
    for(i in 1:dim(bt)[1]){
      nameInd<- i+dim(st)[1]
      minMaxErrs_ind<-FALSE
      if( x[allVarNames[nameInd]]>bt[i,'max'])  {
        x[allVarNames[nameInd]]<-bt[i,'max']
        minMaxErrs_ind<-TRUE
      }
      if( x[allVarNames[nameInd]]<bt[i,'min'])  {
        x[allVarNames[nameInd]]<-bt[i,'min']
        minMaxErrs_ind<-TRUE
      }
      if(minMaxErrs_ind) minMaxErrs[i]<- paste0('Warning: the variable "',bt[i,'label'], '" exceeds the allowed range, and has been set to ',x[allVarNames[nameInd]],'. ')
    }
    output$warn3<-renderText({paste(minMaxErrs,collapse='')})

    #Other error checks on inputs.
    warn2<-""
    if(x['total_number_stages']<x['last_stage_subpop_2_enrolled_adaptive_design']){
        x['last_stage_subpop_2_enrolled_adaptive_design']<-x['total_number_stages']
        warn2<-paste("Warning: the last stage sub population 2 is enrolled must be less than the total number of stages. Here the last stage in which sub population 2 is enrolled is set to",x['total_number_stages'],"the total number of stages")
    }
    output$warn2<-renderText({warn2})

    #Done! Send back the error-checked list of inputs
    x
  })


  params<-reactive({ input$Parameters1 + input$Parameters2 })

  #when we're not just looking at basic parameters, we force batch mode.
  effectivelyBatch<- reactive({input$Batch == "1" | input$Which_params != "1"})


  #############################################
  #############################################
  # Warnings
  #############################################
  #############################################
  output$warn1<-renderText({
    x<-""
    if(input$Which_params!="1" & input$Batch=="2")x<-"Note: interactive mode not enabled for advanced parameters, defaulting to batch mode."
    x    
  })
#See also the allVars() for other errors
  


  #############################################
  #############################################
  # LOADING DATA
  #############################################
  #############################################

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







  #############################################
  #############################################
  # SLIDERS & BOXES
  #############################################
  #############################################


  #NOTE - June 26: When sliders update, regen thinks it needs to be called again because sliders have updated values and you're now in interactive mode.
        #solution -- added lastAllVars (nonreactive) variable that cancels this out.
  #explanation of uploadFileTicker: Only if it's the first time do we change the sliders to the uploaded values. If it's not the first time, we use the current value of the variable, taken from allVars.
  sliders <- reactive({ #NOTE: if you upload the same file again it won't update b/c nothing's techincally new!!!
    print('sliders')
    print(uploadFileTicker)
    regenUpload() #reactive input to uploaded file
    labelSliderList<-list()
    animate<-FALSE
    if(input$Batch=='2' & input$Which_params=='1' ) animate<-TRUE # reactive input
    for(i in 1:dim(st)[1]){
      #case1: null upfile & zero uploadFileTicker (sliders haven't changed yet)
      value_i<-st[i,'value']
      #case2: something uploaded, and hasn't been called yet (uploadFileTicker==0)
      if(!is.null(inValues)) value_i<-inValues[st[i,'inputId']]
      #case3: whatever's there has been called already, ignore uploaded data.
      if(uploadFileTicker>0) isolate(value_i<-allVars()[st[i,'inputId']])
      labelListi<-subH0(st[i,'label'])
      sliderListi<-sliderInput(inputId=st[i,'inputId'], label='', min=st[i,'min'], max=st[i,'max'], value=value_i, step=st[i,'step'], animate=animate)
      ind<-length(labelSliderList)
      labelSliderList[[ind+1]]<-labelListi
      labelSliderList[[ind+2]]<-sliderListi
    }
    uploadFileTicker<<-uploadFileTicker+1
    print('           sliders updating!!!!!!')
    labelSliderList
  })
  output$fullSliders<-renderUI({sliders()})


  boxes <- reactive({ #NOTE: if you upload the same file again it won't update b/c nothing's techincally new!!!
    print('                    boxes')
    regenUpload()
    labelBoxList<-list()
    for(i in 1:dim(bt)[1]){
      value_i<-bt[i,'value']
      if( (!is.null(inValues)) ){ value_i<-inValues[bt[i,'inputId']]}
      boxLabeli<-subH0(bt[i,'label'])
      boxListi<-numericInput(inputId=bt[i,'inputId'], label='', min=bt[i,'min'], max=bt[i,'max'], value=value_i, step=bt[i,'step'])
      ind<-length(labelBoxList)           
      labelBoxList[[ind+1]]<-boxLabeli
      labelBoxList[[ind+2]]<-boxListi
      labelBoxList[[ind+3]]<-br()      
    }
    labelBoxList
  })
  output$fullBoxes<-renderUI({boxes()})









  #############################################
  #############################################
  # REGEN
  #############################################
  #############################################


  # In interactive mode, we re-export the parameters and rebuild table1
  # every time.  In batch, only on the first call for a given push of the
  # Apply button.
  #argument applyValue is usally fed in as params(), the sum of the two apply buttons



  regen <- reactive({
    applyValue<-params()
    totalCalls<<-totalCalls+1
    print(paste('total calls =',totalCalls))
    #ESCAPE --
    #escape if it's called when dynamic sliders/buttons are still loading
    if(is.null(input$Batch) || is.null(applyValue))
      {print('regen null batch or apply -> out') ; return()}
    for(name in allVarNames){
      isolate(if(is.null(input[[name]])) {print('null regen input -> out');return()})
    }
    #in batch mode: if buttons have NOT been pressed since last time, 
  	if (  effectivelyBatch() && (applyValue <= lastApplyValue) )
  	    return()
    #In batch or interactive, check for no change -- especially useful for slider asthetic changes.
        #no need to isolate this next line -- if we're not in interative mode we would have already exited by now.
    if(all(allVars()==lastAllVars)) {
      print('no change')
      lastApplyValue <<- applyValue #fixes bug where if you hit apply w/ no changes, the next slider change will interactively call table_constructor()
      return()
    }


    #if Batch==1, we don't want things updating automatically, so we use isolate()
    #JUNE 26 - This must be done in conjunction with isolating the is.null tests @ the start of the function
    #need to use allVars() so that we head off some potential errors
    assignAllVars<-function(){
      for(i in 1:length(allVarNames))
        assign(allVarNames[i], allVars()[allVarNames[i]], inherits=TRUE)
    }
    cat("assigning Variables ...")
  	if (effectivelyBatch()){ isolate(assignAllVars() )
    } else { assignAllVars() }

    #browser()
    cat("making table1 ...")
    table1 <<- table_constructor()
    cat("Done\n")

  	if (effectivelyBatch() ) lastApplyValue <<- applyValue
    lastAllVars<<-allVars()
})





  #############################################
  #############################################
  # PLOTS
  #############################################
  #############################################


  
  table1 <<- table_constructor() #temporary fix -- moving this initializer down to just before it's called, to make sure all the settings are adjusted right.



  #############
  #Performance plots

  output$power_curve_plot.1 <-
  output$power_curve_plot.2 <- renderPlot({
	regen() 
  print('power plot')
	power_curve_plot()
  })

  output$expected_sample_size_plot.1 <-
  output$expected_sample_size_plot.2 <- renderPlot({
	regen()
  print('sample plot')
	expected_sample_size_plot()
  })

  output$expected_duration_plot.1 <-
  output$expected_duration_plot.2 <- renderPlot({
	regen()
  print('duration plot')
	expected_duration_plot()
  })

  #overruns <- function() plot(1:2, main="Overruns")
  output$overruns.1 <-
  output$overruns.2 <- renderPlot({
	regen()
  print('overruns plot')
	overrun_plot()
  })


  #############
  #Boundary Plots
  output$fixed_HOC_boundary_plot.1 <-
  output$fixed_HOC_boundary_plot.2 <-renderPlot({
    regen()
    print('H0C Boundary Plot')
    boundary_fixed_HOC_plot()
  })

  output$fixed_HOS_boundary_plot.1 <-
  output$fixed_HOS_boundary_plot.2 <-renderPlot({
    regen()
    print('H0S Boundary Plot')
    boundary_fixed_HOS_plot()
  })

  output$adapt_boundary_plot.1 <-
  output$adapt_boundary_plot.2 <-renderPlot({
    regen()
    print('H0C Boundary Plot')
    boundary_adapt_plot()
  })





  #############################################
  #############################################
  # TABLES (& new xtable/renderTable functions)
  #############################################
  #############################################

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
            type = "html",sanitize.text.function=subH0sanitize,
            html.table.attributes = paste("class=\"", 
                #htmlEscape(classNames, TRUE), "\"", sep = ""), 
                shiny:::htmlEscape(classNames, TRUE), "\"", sep = ""), 
            ...)), collapse = "\n"))
    }
}
  
  output$adaptive_design_sample_sizes_and_boundaries_table.3 <-
  output$adaptive_design_sample_sizes_and_boundaries_table.2 <-
  output$adaptive_design_sample_sizes_and_boundaries_table <- renderTable({    
	regen()
  print('adapt table')
	adaptive_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0C_design_sample_sizes_and_boundaries_table.3 <-
  output$fixed_H0C_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0C_design_sample_sizes_and_boundaries_table <- renderTable({
	regen()
  print('HOC table')
	fixed_H0C_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0S_design_sample_sizes_and_boundaries_table.3 <-
  output$fixed_H0S_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0S_design_sample_sizes_and_boundaries_table <-renderTable({
	regen()
  print('HOS table')
	fixed_H0S_design_sample_sizes_and_boundaries_table()
  })

  output$performance_table.1<-
  output$performance_table.2<- renderTable(expr={
	regen()
  print('perf table')
	transpose_performance_table(performance_table())
    },include.colnames=FALSE)






  #############################################
  #############################################
  #SAVE DATA
  #############################################
  #############################################
  output$downloadInputs <- downloadHandler(
    filename =  paste0('inputs_',gsub('/','-',format(Sys.time(), "%D")),'.csv'),
    contentType =  'text/csv',
    content = function(filename) {
      inputCsv<-rep(NA,length=length(allVarNames))
      for(i in 1:length(allVarNames)) inputCsv[i]<- input[[ allVarNames[i] ]]
      write.table(inputCsv, filename, row.names=allVarLabels, col.names=FALSE, sep=',')
    }
  )

  roundTable<-function(tab,digits){
    newTab<-array(0,dim=dim(tab))
    for(i in 1:dim(tab)[1]){
      for(j in 1:dim(tab)[2]){
        newTab[i,j]<-round(tab[i,j],digits=digits[i,j])
      }
    }
    rownames(newTab)<-rownames(tab)
    return(newTab)
  }

  designTable2csv<-function(t1,filename){
      K<-dim(t1[[1]])[2]
      designsCsv<-rbind( 
        'labeltext'=rep(NA,K),
        'Stage'=1:K,
        roundTable(tab=t1[[1]],digits=t1[[2]][,-1])
      )
      rownames(designsCsv)[1]<-t1[[3]]
      write.table(designsCsv, filename, row.names=TRUE, col.names=FALSE, sep=',')

  }


  #Look good, but double check these files below in the future.
  
  output$downloadDesignAD.1<-
  output$downloadDesignAD.2 <- downloadHandler(
    filename =  paste0('DesignAD_',gsub('/','-',format(Sys.time(), "%D")),'.csv'),
    contentType =  'text/csv',
    content = function(filename) {
      t1<-adaptive_design_sample_sizes_and_boundaries_table()
      designTable2csv(t1,filename)
    }
  )
  output$downloadDesignFC.1<-
  output$downloadDesignFC.2<- downloadHandler(
    filename =  paste0('DesignFC_',gsub('/','-',format(Sys.time(), "%D")),'.csv'),
    contentType =  'text/csv',
    content = function(filename) {
      t1<-fixed_H0C_design_sample_sizes_and_boundaries_table()
      designTable2csv(t1,filename)
    }
  )
  output$downloadDesignFS.1<-
  output$downloadDesignFS.2 <- downloadHandler(
    filename =  paste0('DesignFS_',gsub('/','-',format(Sys.time(), "%D")),'.csv'),
    contentType =  'text/csv',
    content = function(filename) {
      t1<-fixed_H0S_design_sample_sizes_and_boundaries_table()
      designTable2csv(t1,filename)
    }
  )

  output$downloadPerformance.1<-
  output$downloadPerformance.2<-
  output$downloadPerformance.3<-
  output$downloadPerformance.4<- downloadHandler(
    filename =  paste0('Performance_',gsub('/','-',format(Sys.time(), "%D")),'.csv'),
    contentType =  'text/csv',
    content = function(filename) {
      t1<-transpose_performance_table(performance_table())
      perfCsv<-rbind(
        'labeltext'=NA,
        round(t1[[1]],digits=max(t1[[2]]))#NOT SURE WHY ROUND ISN"T WORKING WELL IF WE PUT IN THE MATRIX???
      )
      rownames(perfCsv)[1]<-t1[[3]]
      write.table(perfCsv, filename, row.names=TRUE, col.names=FALSE, sep=',')
    }
  )




})
