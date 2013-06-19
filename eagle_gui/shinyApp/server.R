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


allVarNames<-c(st[,'inputId'],bt[,'inputId'])

shinyServer(function(input, output) {

  Apply_button <- -1
  totalcalls<-0 #a place keeper to watch when we cat to stderr
  regenCalls<-0

  # In interactive mode, we re-export the parameters and rebuild table1
  # every time.  In batch, only on the first call for a given push of the
  # Apply button.
  regen <- function(apply_button_value,caller='no caller specified') {
#cat("regen:", input$Batch, "\n", file=stderr())

  totalcalls<<-totalcalls+1
  print(paste('total calls =',totalcalls))
  print(paste('regenCalls =',regenCalls))
  print(paste('caller =',caller))

	if (input$Batch == "1" && apply_button_value <= Apply_button)
	    return()
  if (input$Batch == "2" && regenCalls>0 ){
      return()
  }

	if (input$Batch == "1")
    isolate(for(i in 1:length(allVarNames))
  		assign(allVarNames[i], input[[allVarNames[i]]], inherits=TRUE)
    )
	else{
    for(i in 1:length(allVarNames)){
	    assign(allVarNames[i], input[[allVarNames[i]]], inherits=TRUE)
    }
  }

  cat("making table1 ...")
  table1 <<- table_constructor()
  cat("Done\n")

	if (input$Batch == "1")
		Apply_button <<- apply_button_value
  }

# apply_button <- quote({
# 	val <- input$Parameters
# 	if (val == 0)
# 		return("")
# 	regen(val)
# 	#as.character(val)
# 	""
# })
# output$params <- renderText(apply_button, quoted=TRUE)
  
  refresh<-function(){
    if(input$Batch == "2"){
      storeInputChar<<-rep('',length=length(allVarNames))
      for(i in 1:length(allVarNames)){
            storeInputChar[i]<<-as.character(input[[allVarNames[i] ]])
      }
      return(paste(storeInputChar,collapse=' '))
    }
  }

  output$dummyText<-renderText({
    print('resetting regenCalls')
    regenCalls<<-0
    regen(input$Parameters,caller='dummy')
    print('adding to regenCalls')
    regenCalls<<-1
    substr(refresh(),0,0)
  })


  output$power_curve_plot <- renderPlot({
	regen(input$Parameters,caller='power_curve_plot')
  refresh()
	power_curve_plot()
  })

  output$expected_sample_size_plot <- renderPlot({
	regen(input$Parameters,caller='expected_sample_size_plot')
  refresh()
	expected_sample_size_plot()
  })

  output$expected_duration_plot <- renderPlot({
	regen(input$Parameters,caller='expected_duration_plot')
  refresh()
	expected_duration_plot()
  })

  overruns <- function() plot(1:2, main="Overruns")
  output$overruns <- renderPlot({
	regen(input$Parameters,caller='overruns')
  refresh()
	overruns()
  })

# HJ - x must be a list of length 3, with a digits and caption
xtable <- function(x) {
	xtable::xtable(x[[1]], digits=x$digits, caption=x$caption)
}

# HJ - see shiny:::htmlEscape (why is this necessary?)
renderTable <- function (expr, ..., env = parent.frame(), quoted = FALSE, func = NULL) 
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
        return(paste(capture.output(print(xtable(data, ...), 
            type = "html", html.table.attributes = paste("class=\"", 
                #htmlEscape(classNames, TRUE), "\"", sep = ""), 
                shiny:::htmlEscape(classNames, TRUE), "\"", sep = ""), 
            ...)), collapse = "\n"))
    }
}

  output$adaptive_design_sample_sizes_and_boundaries_table.2 <-
  output$adaptive_design_sample_sizes_and_boundaries_table <- renderTable({
	regen(input$Parameters,caller='adaptive_table')
  refresh()
	adaptive_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0C_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0C_design_sample_sizes_and_boundaries_table <- renderTable({
	regen(input$Parameters,caller='HOC_table')
  refresh()
	fixed_H0C_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0S_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0S_design_sample_sizes_and_boundaries_table <-renderTable({
	regen(input$Parameters,caller='HOS_table')
  refresh()
	fixed_H0S_design_sample_sizes_and_boundaries_table()
  })

  output$performance_table <- renderTable({
	regen(input$Parameters,caller='performance_table')
  refresh()
	transpose_performance_table(performance_table())
    })

})
