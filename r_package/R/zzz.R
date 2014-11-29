.onLoad <- function(libname, pkgname) {
	if(interactive()) {
		ans <- readline("Launch the interAdapt app? (type 'yes' or 'no')")
		if(tolower(substr(ans, 1, 1)) == "y")
			runInterAdapt()
	}
}
