#To Do

## Things to talk about
* All set for now

## For Michael to do


#### Things to do now
* first pull changes from github
* Aesthetic Changes:
    - Edit wording of "(Press Apply after loading)" caption that appears above the load data input button. This can be changed in the ui.R file.
    - Update legend with "futility boundary" language (i.e. Futility boundary for H0C? for ZC?)
* After Aaron sends back pdf, make changes to the tex file based on the annotations Aaron was confused about
* (done?) Add some comments to the code, above each function maybe? The JSS people say they the code to be commented and readable.
* (Done?) Update the decision boundaries in the code to be proportional inverse of n_k/sum(n_k), not to the stage number (because number of patients enrolled varies). Keep sum n_k so that the proportionality constants are on a smaller scale. 

 

#### When Aaron eventually sends a final draft
* Specified sections with changes
* Make adjustments where you see "!!!" in the comments.






## For Aaron to do
* Edit JSS.tex to take out delay & overrun references
* Add lines "The software requires user's default web browser to be set to either Firefox " to paper & about tab
* change R code to say "To exit press escape"
Add upload CSV to documentation!???!??
Add note on how duration is nessecarily proportional to sample size for AD, because it can be slower after k* if more patients, even considering no  delay time (which we no longer will mention). Duration is generally slower duration for SS than SC, if they have the same total sample size. The two enrollment rates don't affect eachother. Recruiting one subpop doesn't slow recruitment of the other.
Send Michael pdf with remaining comments
* Ask Michael about !!!! marks in tex file
* (After Michael reads over final draft) adjust knitr Rmd files. 
* Change links at the head of the knitr files to point to github and interAdapt.
* When ready: Adjust final links and set everything up with interAdapt
    - Update github and spark interAdapt files.
* Add user tracking to spark repo (can do after we submit paper)

#### Done stuff
* Jeff says use GPL-2 License

