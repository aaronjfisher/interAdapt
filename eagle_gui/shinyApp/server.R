library(shiny)

# Define server logic required to plot various variables against mpg

#STILL NEED TO ALSO IMPLEMENT THE ERROR 1 "min" fix

errors<-function(input){
	errorMessages<-c()
	errors<-c()

	#error1: max stages<last stage for subpop2
	notEnoughStages<- input$total_number_stages< input$last_stage_subpop_2_enrolled_adaptive_design 
	errorMessages[1]<- paste0('WARNING: The last stage in which subpopulation 2 is enrolled must be less than or equal to the total number of stages. Here, the last stage in which subpopulation 2 is enrolled is reset to: ',input$total_number_stages,'.')
	if(notEnoughStages){
		errors[1]<-errorMessages[1]
	}
	else {errors[1]<-""}
	
	errorsOut<-paste(errors,collapse='')
	return(errorsOut)
}

shinyServer(function(input, output) {

	# maxStages<-reactive({ input$last_stage_subpop_2_enrolled_adaptive_design })
	# minStages<-reactive({ min(maxStages(),input$total_number_stages) })

	# output$tns<-renderUI({
	#   numericInput(inputId='inputId', label='last stage', min=1, max=maxStages(), value=minStages())
	#   })
	
	
	
	output$errors<-renderText(errors(input))

})