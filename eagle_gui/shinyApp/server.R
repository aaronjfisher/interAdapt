  # ______ _   _ _____  _____ _ 
  # | ___ \ | | |  __ \/  ___| |
  # | |_/ / | | | |  \/\ `--.| |
  # | ___ \ | | | | __  `--. \ |
  # | |_/ / |_| | |_\ \/\__/ /_|
  # \____/ \___/ \____/\____/(_)
                              

# Need to make sure the initialized image is set correctly. 
    # For beta testing it's just commented out to maintain consistency.
# If you upload the same dataset twice, it won't notice the change. you have to clear first.
# search !!! and ???
# Once we have stable code, make sure the default xlims are right when we load table1 from file.
# (AF) I believe HJ wrote the renderTable function?
# Adding π to the sliders means you can't edit them in excel anymore, or excel will mess it up when it saves
# Right now we don't have any more subscripts than in the null hypothesis tests. 
  # we could add for instance p_{1,2} but this would require more work with our custom "sanitize text" functions
  #it's find for now, don't bother.


  # ______                         _     _      
  # | ___ \                       | |   | |     
  # | |_/ / __ ___  __ _ _ __ ___ | |__ | | ___ 
  # |  __/ '__/ _ \/ _` | '_ ` _ \| '_ \| |/ _ \
  # | |  | | |  __/ (_| | | | | | | |_) | |  __/
  # \_|  |_|  \___|\__,_|_| |_| |_|_.__/|_|\___|
                                              
                                              

library(knitr)


###########
#Functions

subH0 <- function(x){ #make a function that does the same thing as "strong()" but for <sub></sub>
#finds all H0C and H01 terms and subs them!
  x <- strong(x)
  x <- gsub("<strong>", "", x)
  x <- gsub("</strong>", "", x)
  x <- gsub("H0C", "H<sub>0C</sub>", x)
  x <- gsub("H01", "H<sub>01</sub>", x)
  return(x)
}

#To be used in our xtable function!
subH01anitize<-function(x){
  x <- gsub("H0C", "H<sub>0C</sub>", x)
  x <- gsub("H01", "H<sub>01</sub>", x)
  return(x)
}


#To print2log errors that we can read in a log later, useful for checking sessions on RStudio/glimmer/spark
#first override last session/start new log
#In final release, set "print2R" to FALSE
cat(file='session_log.txt',paste(Sys.time(),'\n \n')) 
print2log<-function(x,logFileName='session_log.txt',print2R=FALSE){ #takes a string as input
  if(print2R) print(x)
  cat(file=logFileName,paste(x,'\n'),append=TRUE)
}
###############



print2log("source'ing code...")

#Get the csv file either online or locally
getItOnline<-TRUE
try({
  #loading & saving table 1 is done elsewhere, all through local file management
  source("Adaptive_Group_Sequential_Design.R", local=TRUE)
  st<-read.csv(file= "sliderTable.csv",header=TRUE,as.is=TRUE)
  bt<-read.csv(file= "boxTable.csv",header=TRUE,as.is=TRUE)
  getItOnline<-FALSE #if we haven't gotten an error yet!
  print2log("found code locally...")
},silent=TRUE)
#removed code for finding files online.


print2log("...supplementary files found and loaded...")

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


#The following code answers the question: do we need to regen table1? Try to see if you have it locally. If you don't, or if you need to update it, do it again & save (wherever you are, either on glimmer, spark, or locally)
stillNeedTable1<-TRUE
try({
load('last_default_inputs.RData') #won't work first time on glimmer, but it's OK
  if(all(bt==lastBt)&all(st==lastSt)){ #lastBt and lastSt are from the last time we generated table1, contained in the RData file we just loaded. If we're a match, then:
      load('last_default_table1_&_xlim.RData')
      stillNeedTable1<-FALSE
      print2log("loaded table1...")
  }
})
if(stillNeedTable1){ 
  table1<- table_constructor()
  lastBt<-bt
  lastSt<-st
  save(list=c('table1','risk_difference_list'),file='last_default_table1_&_xlim.RData')
  save(list=c('lastBt','lastSt'),file='last_default_inputs.RData')
  print2log("built table1...")
}






  #  _____                          _____           _      
  # /  ___|                        /  __ \         | |     
  # \ `--.  ___ _ ____   _____ _ __| /  \/ ___   __| | ___ 
  #  `--. \/ _ \ '__\ \ / / _ \ '__| |    / _ \ / _` |/ _ \
  # /\__/ /  __/ |   \ V /  __/ |  | \__/\ (_) | (_| |  __/
  # \____/ \___|_|    \_/ \___|_|   \____/\___/ \__,_|\___|
                                                         
                                                         




shinyServer(function(input, output) {


  ##########
  # (_)     (_) | (_)     | (_)        
  #  _ _ __  _| |_ _  __ _| |_ _______ 
  # | | '_ \| | __| |/ _` | | |_  / _ \
  # | | | | | | |_| | (_| | | |/ /  __/
  # |_|_| |_|_|\__|_|\__,_|_|_/___\___|
                                     
  # Initialize some static & reactive variables
  ##########


  lastApplyValue <- 0 # need to put -1 here if we don't load table 1 beforehand
  totalCalls<-0 #a place keeper to watch when we cat to stderr
  uploadCsvTicker<-0
  uploadDatasetTicker<-0
  inCsvValues<-NULL
  inDatasetValues<-NULL

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


  params<-reactive({ input$Parameters1 + input$Parameters2 }) #one button for advanced, one for basic.

  #when we're not just looking at basic parameters (which_params!=1), we force batch mode.
  effectivelyBatch<- reactive({input$Batch == "1" | input$Which_params != "1"})


  #                          (_)                
  # __      ____ _ _ __ _ __  _ _ __   __ _ ___ 
  # \ \ /\ / / _` | '__| '_ \| | '_ \ / _` / __|
  #  \ V  V / (_| | |  | | | | | | | | (_| \__ \
  #   \_/\_/ \__,_|_|  |_| |_|_|_| |_|\__, |___/
  #                                    __/ |    
  #                                   |___/     
  output$warn1<-renderText({
    x<-""
    if(input$Which_params!="1" & input$Batch=="2")x<-"Note: interactive mode not enabled for advanced parameters, defaulting to batch mode."
    x    
  })
#See also the allVars() for other errors
  


  #  _                     _  ______      _        
  # | |                   | | |  _  \    | |       
  # | |     ___   __ _  __| | | | | |__ _| |_ __ _ 
  # | |    / _ \ / _` |/ _` | | | | / _` | __/ _` |
  # | |___| (_) | (_| | (_| | | |/ / (_| | || (_| |
  # \_____/\___/ \__,_|\__,_| |___/ \__,_|\__\__,_|

  #below are 2 reactive chunks to feed to the dynamicBoxes & dynamicSliders


  csvUpload<-reactive({
    upFile <- input$uploadCsvInput
    x<-NULL
    if (!is.null(upFile)){
      x<-c(read.csv(file=upFile$datapath, row.names=1, header=FALSE))[[1]]
      names(x)<-allVarNames
      uploadCsvTicker<<-0
      print2log('resetting upload csv all inputs')
    }
    inCsvValues<<-x
  })






  datasetVarNames<-c('p1_user_defined','p10_user_defined','p11_user_defined','p20_user_defined','p21_user_defined')

  datasetUpload<-reactive({
    upFile <- input$uploadDataTable
    x<-NULL
    if (!is.null(upFile)){
      tmp <- read.csv(file=upFile$datapath, header=TRUE)
      S <- tmp$S        # subpopulation, 1 or 2
      A <- tmp$A        # study arm, 0 or 1
      Y <- tmp$Y        # outcome, 0 or 1
      x['p1_user_defined'] <- mean(S==1)
      x['p10_user_defined'] <- mean(Y*(S==1)*(A==0))/mean((S==1)*(A==0))
      x['p11_user_defined'] <- mean(Y*(S==1)*(A==1))/mean((S==1)*(A==1))
      x['p20_user_defined'] <- mean(Y*(S==2)*(A==0))/mean((S==2)*(A==0))
      x['p21_user_defined'] <- mean(Y*(S==2)*(A==1))/mean((S==2)*(A==1))
      # HJ -- perform sanity checks?
      uploadDatasetTicker<<-0
      print2log('new Data calculated from')
      print2log(x)
      print2log('resetting upload dataset')      
    }
    inDatasetValues<<-x
  })






#      _ _     _                          _                        
#     | (_)   | |                 ___    | |                       
#  ___| |_  __| | ___ _ __ ___   ( _ )   | |__   _____  _____  ___ 
# / __| | |/ _` |/ _ \ '__/ __|  / _ \/\ | '_ \ / _ \ \/ / _ \/ __|
# \__ \ | | (_| |  __/ |  \__ \ | (_>  < | |_) | (_) >  <  __/\__ \
# |___/_|_|\__,_|\___|_|  |___/  \___/\/ |_.__/ \___/_/\_\___||___/


  #NOTE - June 26: When sliders update, regen thinks it needs to be called again because sliders have updated values and you're now in interactive mode.
        #solution -- added lastAllVars (nonreactive) variable that cancels this out.
  #explanation of uploadCsvTicker: Only if it's the first time since uploading do we change the sliders to the uploaded values from the full csv list. If it's not the first time, we use the current value of the variable, taken from allVars.
  #for uploadDatasetTicker, it's the same basic idea, but we only check it for variables in the vector 'datasetVarNames'.
  sliders <- reactive({ #NOTE: if you upload the same file again it won't update b/c nothing's techincally new!!!
    print2log('sliders')
    print2log(uploadCsvTicker)
    print2log(uploadDatasetTicker)
    csvUpload() #reactive input to uploaded file; sets ticker to zero when it's activated & does stuff
    datasetUpload() #reactive input to uploaded file; sets ticker to zero when it's activated & does stuff
    labelSliderList<-list()
    animate<-FALSE
    if(input$Batch=='2' & input$Which_params=='1' ) animate<-TRUE # reactive input
    for(i in 1:dim(st)[1]){
      #each of these cases overrides the previous one
      #case1: null upfile & zero uploadCsvTicker (sliders haven't changed yet)
      value_i<-st[i,'value']
      #case2: something uploaded in csv input file, and hasn't been incorporated yet (uploadCsvTicker==0)
      if(!is.null(inCsvValues)) value_i<-inCsvValues[st[i,'inputId']]
      #case3: whatever's there has been called already, ignore uploaded input csv data.
      if(uploadCsvTicker>0) isolate(value_i<-allVars()[st[i,'inputId']])
      #case4: someone just uploaded a dataset that we parsed to get slider values
        #(only do this for sliders that are in the datasetVarNames vector)
      if(uploadDatasetTicker==0 & (!is.null(inDatasetValues)) & st[i,'inputId'] %in% datasetVarNames)
        value_i<-inDatasetValues[st[i,'inputId']]
      #end of cases

      labelListi<-subH0(st[i,'label']) #Labels are stored as non slider text objects, so that we can apply subscripts
      sliderListi<-sliderInput(inputId=st[i,'inputId'], label='', min=st[i,'min'], max=st[i,'max'], value=value_i, step=st[i,'step'], animate=animate)
      ind<-length(labelSliderList) #starts at 0, grows on each repeat of this loop
      labelSliderList[[ind+1]]<-labelListi #alternate labels inbetween sliders
      labelSliderList[[ind+2]]<-sliderListi
    }
    uploadCsvTicker<<-uploadCsvTicker+1
    uploadDatasetTicker<<-uploadDatasetTicker+1
    print2log('           sliders updating!!!!!!')
    labelSliderList
  })
  output$fullSliders<-renderUI({sliders()})


  boxes <- reactive({ #NOTE: if you upload the same file again it won't update b/c nothing's techincally new!!!
    print2log('                    boxes')
    csvUpload()
    labelBoxList<-list()
    for(i in 1:dim(bt)[1]){
      value_i<-bt[i,'value']
      if( (!is.null(inCsvValues)) ){ value_i<-inCsvValues[bt[i,'inputId']]}
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








# ______ _____ _____  _____ _   _ 
# | ___ \  ___|  __ \|  ___| \ | |
# | |_/ / |__ | |  \/| |__ |  \| |
# |    /|  __|| | __ |  __|| . ` |
# | |\ \| |___| |_\ \| |___| |\  |
# \_| \_\____/ \____/\____/\_| \_/

  # In interactive mode, we re-export the parameters and rebuild table1
  # every time.  In batch, only on the first call for a given push of the
  # Apply button.
  #argument applyValue is usally fed in as params(), the sum of the two apply buttons



  regen <- reactive({
    applyValue<-params()
    totalCalls<<-totalCalls+1
    print2log(paste('total calls =',totalCalls))
    #ESCAPE SCENARIOS
    #escape if it's called when dynamic sliders/buttons are still loading (just when app starts up)
    if(is.null(input$Batch) || is.null(applyValue))
      {print2log('regen null batch or apply -> out') ; return()}
    for(name in allVarNames){
      isolate(if(is.null(input[[name]])) {print2log('null regen input -> out');return()})
    }
    #in batch mode: if buttons have NOT been pressed since last time, 
  	if (  effectivelyBatch() && (applyValue <= lastApplyValue) )
  	    return()
    #In batch or interactive, check for no change -- especially useful for slider asthetic changes.
        #no need to isolate this next line -- if we're not in interative mode we would have already exited by now.
    if(all(allVars()==lastAllVars)) {
      print2log('no change')
      lastApplyValue <<- applyValue #fixes bug where if you hit apply w/ no changes, the next slider change will interactively call table_constructor()
      return()
    }


    #If we haven't escaped, continue...


    #if Batch==1, we don't want things updating automatically, so we use isolate()
    #JUNE 26 - This must be done in conjunction with isolating the is.null tests @ the start of the function
    #need to use allVars() so that we head off some potential errors
    assignAllVars<-function(){
      for(i in 1:length(allVarNames))
        assign(allVarNames[i], allVars()[allVarNames[i]], inherits=TRUE)
    }
    print2log("assigning Variables ...")
  	if (effectivelyBatch()){ isolate(assignAllVars() )
    } else { assignAllVars() }

    print2log("making table1 ...") #Wait.. does this have to come before we assign variables?? Look over this stuff again.
    table1 <<- table_constructor()
    print2log("Done \n")

  	if (effectivelyBatch() ) lastApplyValue <<- applyValue
    lastAllVars<<-allVars()
})





  # ______ _       _       
  # | ___ \ |     | |      
  # | |_/ / | ___ | |_ ___ 
  # |  __/| |/ _ \| __/ __|
  # | |   | | (_) | |_\__ \
  # \_|   |_|\___/ \__|___/
                         


  #############
  #Performance plots

  output$power_curve_plot <- renderPlot({
	regen() 
  print2log('power plot')
	power_curve_plot()
  })

  output$expected_sample_size_plot <- renderPlot({
	regen()
  print2log('sample plot')
	expected_sample_size_plot()
  })

  output$expected_duration_plot <- renderPlot({
	regen()
  print2log('duration plot')
	expected_duration_plot()
  })

  #overruns <- function() plot(1:2, main="Overruns")
  output$overruns <- renderPlot({
	regen()
  print2log('overruns plot')
	overrun_plot()
  })


  #############
  #Boundary Plots
  output$fixed_H0C_boundary_plot <-renderPlot({
    regen()
    print2log('H0C Boundary Plot')
    boundary_fixed_H0C_plot()
  })

  output$fixed_H01_boundary_plot <-renderPlot({
    regen()
    print2log('H01 Boundary Plot')
    boundary_fixed_H01_plot()
  })

  output$adapt_boundary_plot <-renderPlot({
    regen()
    print2log('H0C Boundary Plot')
    boundary_adapt_plot()
  })





  #  _____     _     _           
  # |_   _|   | |   | |          
  #   | | __ _| |__ | | ___  ___ 
  #   | |/ _` | '_ \| |/ _ \/ __|
  #   | | (_| | |_) | |  __/\__ \
  #   \_/\__,_|_.__/|_|\___||___/
  # TABLES (& new xtable/renderTable functions)
  #####


# HJ - x must be a list of length 3, with a digits and caption
xtable <- function(x) {
	xtable::xtable(x[[1]], digits=x$digits, caption=x$caption) #NEED TO EXPAND HERE!!
}

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
            type = "html",sanitize.text.function=subH01anitize,
            html.table.attributes = paste("class=\"", 
                #htmlEscape(classNames, TRUE), "\"", sep = ""), 
                shiny:::htmlEscape(classNames, TRUE), "\"", sep = ""), 
            ...)), collapse = "\n"))
    }
}
  
  output$adaptive_design_sample_sizes_and_boundaries_table.2 <-
  output$adaptive_design_sample_sizes_and_boundaries_table <- renderTable({    
	regen()
  print2log('adapt table')
	adaptive_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0C_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0C_design_sample_sizes_and_boundaries_table <- renderTable({
	regen()
  print2log('H0C table')
	fixed_H0C_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H01_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H01_design_sample_sizes_and_boundaries_table <-renderTable({
	regen()
  print2log('H01 table')
	fixed_H01_design_sample_sizes_and_boundaries_table()
  })

  output$performance_table <- renderTable(expr={
	regen()
  print2log('perf table')
	transpose_performance_table(performance_table())
    },include.colnames=FALSE)






  #                            _       _        
  #                           | |     | |       
  #  ___  __ ___   _____    __| | __ _| |_ __ _ 
  # / __|/ _` \ \ / / _ \  / _` |/ _` | __/ _` |
  # \__ \ (_| |\ V /  __/ | (_| | (_| | || (_| |
  # |___/\__,_| \_/ \___|  \__,_|\__,_|\__\__,_|

  output$downloadInputs <- downloadHandler(
    filename =  paste0('inputs_',gsub('/','-',format(Sys.time(), "%D")),'.csv'),
    contentType =  'text/csv',
    content = function(filename) {
      inputCsv<-rep(NA,length=length(allVarNames))
      for(i in 1:length(allVarNames)) inputCsv[i]<- input[[ allVarNames[i] ]]
      write.table(inputCsv, filename, row.names=allVarLabels, col.names=FALSE, sep=',')
    }
  )

  output$knitr <- downloadHandler(
    filename =  'report.html',
    contentType =  'text/html',
    content = function(filename) {
      #can't say "if (file.exists(filename)) file.remove(filename)" because this would open the door to hacking?
      if (file.exists('knitr_report.html')) file.remove('knitr_report.html')
      if (file.exists('knitr_report.md')) file.remove('knitr_report.md')
      htmlKnitted<-knit2html('knitr_report.Rmd') #"plain" version, without knitrBootstrap
      x<-readLines(con=htmlKnitted) #"plain" version, without knitrBootstrap
      #library(knitrBootstrap)
      #knit_bootstrap('knitr_report.Rmd') #fancy knitrBootstrap version
      #x<-readLines(con='knitr_report.html')#fancy knitrBootstrap version
      writeLines(x,con=filename)
      # file.rename('knitr_report.html', filename)

    }
  )

  #functions for downloading table output.
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


  #!!! Double check these files below once we have new tables with new descision rules ???
  
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
      t1<-fixed_H01_design_sample_sizes_and_boundaries_table()
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
      perfTab<-t1[[1]]
      for(row in 1:dim(perfTab)[1]) perfTab[row,]<-round(t1[[1]][row,],digits=t1[[2]][row,2])
      perfCsv<-rbind('labeltext'=NA,perfTab)
      rownames(perfCsv)[1]<-t1[[3]]
      write.table(perfCsv, filename, row.names=TRUE, col.names=FALSE, sep=',')
    }
  )




})
