

#' Run the interAdapt shiny application
#'
#' \code{runInterAdapt} Runs the interactive shiny application
#' 
#' @export
#' @import shiny RCurl mvtnorm knitr
runInterAdapt<-function(){
	shiny::runApp(system.file('shinyInterAdaptApp', package='interAdapt'))
	print('running application...')
}


