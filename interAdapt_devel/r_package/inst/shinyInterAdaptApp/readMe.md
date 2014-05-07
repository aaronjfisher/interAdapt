Description of files for Shiny App
===============


* help_tab.html - contains the text for the tab that's first displayed to users when they open interAdapt.
* Adaptive_Group_Sequential_Design.R contains functions used in (Rosenblum et. al 2013) for calculating the power, expected sample size, and expected duration of the trials shown. These functions are sourced by the Shiny application.
    * http://biostats.bepress.com/jhubiostat/paper250
* boxTable.csv and sliderTable.csv contain information on the input devices shown in the side panel of the Shiny application. sliderTable.csv contains information used to create the basic parameters, and boxTable.csv contains information used to create the advanced parameters. Variable names given to the user inputs are referenced by functions in Adaptive_Group_Sequential_Design.R.
* knitr_report files are used to create the reports users can download, via the "Generate Report" button.
* last_default_inputs.RData shows values of the default inputs (see boxTable.csv and sliderTable.csv) when interAdapt was last run. If boxTable.csv or sliderTable.csv is altered in between runs of interAdapt, the output for the new default parameters must be recalculated. If not, this initial calculation procedure can be skipped by loading "last_default_table1_&_xlim.RData".
* server.R and ui.R are standard Shiny application files (http://rstudio.github.io/shiny/tutorial/).
* session_log.txt shows the ouput from the last session of interAdapt. This can be useful for debugging.
