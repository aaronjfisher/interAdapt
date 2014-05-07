#' Run the interAdapt application
#'
#' \code{runInterAdapt} Runs the main application
#' 
#' @export
#'
runInterAdapt<-function(){
	shiny::runApp(system.file('shinyInterAdaptApp', package='interAdapt'))
	print('running application...')
}
