cat("source'ing code...", file=stderr())
source("Adaptive_Group_Sequential_Design.R", local=TRUE)

st<-read.csv(file= "sliderTable.csv",header=TRUE,as.is=TRUE)
bt<-read.csv(file= "boxTable.csv",header=TRUE,as.is=TRUE)
allVarNames<-c(st[,'inputId'],bt[,'inputId'])

shinyServer(function(input, output) {

  Apply_button <- -1

  # In interactive mode, we re-export the parameters and rebuild table1
  # every time.  In batch, only on the first call for a given push of the
  # Apply button.
  regen <- function(apply_button_value) {
#cat("regen:", input$Batch, "\n", file=stderr())
	if (input$Batch == "1" && apply_button_value <= Apply_button)
	    return()

	if (input$Batch == "1")
	    isolate(for(i in 1:length(allVarNames))
		assign(allVarNames[i], input[[allVarNames[i]]], inherits=TRUE)
	    )
	else
	    for(i in 1:length(allVarNames))
		assign(allVarNames[i], input[[allVarNames[i]]], inherits=TRUE)

#cat("making table1 ...")
	table1 <<- table_constructor()
#cat("Done\n")

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

  output$power_curve_plot <- renderPlot({
	regen(input$Parameters)
	power_curve_plot()
  })

  output$expected_sample_size_plot <- renderPlot({
	regen(input$Parameters)
	expected_sample_size_plot()
  })

  output$expected_duration_plot <- renderPlot({
	regen(input$Parameters)
	expected_duration_plot()
  })

  overruns <- function() plot(1:2, main="Overruns")
  output$overruns <- renderPlot({
	regen(input$Parameters)
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
	regen(input$Parameters)
	adaptive_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0C_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0C_design_sample_sizes_and_boundaries_table <- renderTable({
	regen(input$Parameters)
	fixed_H0C_design_sample_sizes_and_boundaries_table()
  })

  output$fixed_H0S_design_sample_sizes_and_boundaries_table.2 <-
  output$fixed_H0S_design_sample_sizes_and_boundaries_table <-renderTable({
	regen(input$Parameters)
	fixed_H0S_design_sample_sizes_and_boundaries_table()
  })

  output$performance_table <- renderTable({
	regen(input$Parameters)
	transpose_performance_table(performance_table())
    })

})
