interAdapt
==========



About this software
----------

When designing a clinical trial, study coordinators often have prior evidence that the treatment might work better in a one subpopulation than another. One strategy in these scenarios is to conduct a trial with an adaptive enrollment criteria, where we decide whether or not to continue enrolling patients from each subpopulation based on interim analyses of whether each subpopulation is benefiting. In order for the type I error and the power of the trial to be calculable, the decision rules for changing enrollment must be set before the trial starts. 


<i>interAdapt</i> is a Shiny application for generating pre-determined decision rules for trials with adaptive enrollement criteria. Using this application, you can also compare the performance of the resulting adaptive trial designs to the performance of standard designs with fixed enrollment criteria.

Usage
------------

The primary functions in this package are `runInterAdapt`, which opens a shiny application for interactive exploration of trial designs, and `compute_design_performance`, which can be used for similar explorations of trial designs directly in the command line.


<i>interAdapt</i> is available from CRAN, and can be installed via `install.packages('interAdapt')`. Alternatively, the development version in this repository can be installed via:

```S
## if needed
install.packages("devtools")

## main package
library(devtools)
install_github('interAdapt','aaronjfisher',subdir="r_package")

## to access help pages
library(interAdapt)
help(package=interAdapt)
``` 


Structure of this repository
------------

Files in this home directory are referenced by interAdapt to check for version updates, and to link to the most current version of the documentation (About_interAdapt.pdf). 

The code for the Shiny application is located in the "r_package / inst / shinyInterAdaptApp" folder.

