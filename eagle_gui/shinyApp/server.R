cat("source'ing code...", file=stderr())
source("Adaptive_Group_Sequential_Design.R", local=TRUE)

st<-read.csv(file= "sliderTable.csv",header=TRUE,as.is=TRUE)
bt<-read.csv(file= "boxTable.csv",header=TRUE,as.is=TRUE)
allVarNames<-c(st[,'inputId'],bt[,'inputId'])

# T.adaptive <- NULL
# T.fixed_H0C <- NULL
# T.fixed_H0S<- NULL
# T.performance_table <- NULL

# cat("making table1...", file=stderr())
# table1 <- table_constructor()
# cat("Done\n", file=stderr())
# print(str(table1))






shinyServer(function(input, output) {

regen <-reactive({

  for(i in 1:length(allVarNames)){
    stringToDo<-paste0(allVarNames[i],' <<- input$', allVarNames[i])
    eval(parse(text=stringToDo))
  }


  # p1_user_defined <<- input$p1_user_defined
  # p10_user_defined  <<- input$p10_user_defined
  # p20_user_defined  <<- input$p20_user_defined
  # p11_user_defined  <<- input$p11_user_defined
  # p21_user_defined  <<- input$p21_user_defined
  # alpha_FWER_user_defined <<- input$alpha_FWER_user_defined
  # alpha_H0C_user_defined  <<- input$alpha_H0C_user_defined
  # per_stage_sample_size_combined_adaptive_design_user_defined <<- input$per_stage_sample_size_combined_adaptive_design_user_defined
  # per_stage_sample_size_when_only_subpop_2_enrolled_adaptive_design_user_defined  <<- input$per_stage_sample_size_when_only_subpop_2_enrolled_adaptive_design_user_defined
  # Delta <<- input$Delta
  # iter  <<- input$iter
  # total_number_stages <<- input$total_number_stages
  # recruitment_rate_subpop_1 <<- input$recruitment_rate_subpop_1
  # recruitment_rate_subpop_2 <<- input$recruitment_rate_subpop_2
  # lower_bound_treatment_effect_subpop_2 <<- input$lower_bound_treatment_effect_subpop_2
  # upper_bound_treatment_effect_subpop_2 <<- input$upper_bound_treatment_effect_subpop_2
  # last_stage_subpop_2_enrolled_adaptive_design  <<- input$last_stage_subpop_2_enrolled_adaptive_design
  # H0C_futility_boundary_proportionality_constant_adaptive_design  <<- input$H0C_futility_boundary_proportionality_constant_adaptive_design
  # H0S_futility_boundary_proportionality_constant_adaptive_design  <<- input$H0S_futility_boundary_proportionality_constant_adaptive_design
  # H0C_futility_boundary_proportionality_constant_fixed_design <<- input$H0C_futility_boundary_proportionality_constant_fixed_design
  # H0S_futility_boundary_proportionality_constant_fixed_design <<- input$H0S_futility_boundary_proportionality_constant_fixed_design

cat("making table...")
  table1<<-table_constructor()

  T.adaptive <<- 
	adaptive_design_sample_sizes_and_boundaries_table()

  T.fixed_H0C <<-
	fixed_H0C_design_sample_sizes_and_boundaries_table()

  T.fixed_H0S<<-
	fixed_H0S_design_sample_sizes_and_boundaries_table()

  T.performance_table <<- performance_table()

cat("Done\n")
})

  output$power_curve_plot <- renderPlot({
cat(input$p1_user_defined, "...", file=stderr())
	regen()
	power_curve_plot()
cat("Done\n", file=stderr())
  })

  output$expected_sample_size_plot <- renderPlot({
cat(input$p1_user_defined, "...", file=stderr())
	regen()
	expected_sample_size_plot()
cat("Done\n", file=stderr())
  })

  output$expected_duration_plot <- renderPlot({
cat(input$p1_user_defined, "...", file=stderr())
	regen()
	expected_duration_plot()
cat("Done\n", file=stderr())
  })

  overruns <- function() plot(1:2, main="Overruns")
  output$overruns <- renderPlot({
cat(input$p1_user_defined, "...", file=stderr())
	regen()
	overruns()
cat("Done\n", file=stderr())
  })

# HJ - removed the ... from the print call
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
		type = "html",
		html.table.attributes = paste(
			"class=\"", shiny:::htmlEscape(classNames, TRUE),
		"\"", sep = ""))), collapse = "\n"))
    }
}

  output$adaptive_design_sample_sizes_and_boundaries_table <- renderTable({
	regen()
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

  output$performance_table <- renderTable({
    regen()
    T.performance_table[[1]]
    },digits=T.performance_table$digits, caption=T.performance_table$caption)

})
