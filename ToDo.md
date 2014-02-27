#To Do

## For use to talk about
* Citaiton style? Manually add things like (Rosenblum et al) or change citation syle?


## For Michael to do


#### Things to do now
* first pull changes from github
* Aesthetic Changes:
    - Edit wording of "(Press Apply after loading)" caption that appears above the load data input button. This can be changed in the ui.R file.
    - Update legend with "futility boundary" language (i.e. Futility boundary for H0C? for ZC?)
* After Aaron sends back pdf, make changes to the tex file based on the annotations Aaron was confused about
* Add some comments to the code, above each function maybe? The JSS people say they the code to be commented and readable.
* Update the decision boundaries in the code to be proportional inverse of n_k/sum(n_k), not to the stage number (because number of patients enrolled varies). Keep sum n_k so that the proportionality constants are on a smaller scale. 

 

#### When Aaron eventually sends a final draft
* Specified sections with changes
* Make adjustments where you see "!!!" in the comments.






## For Aaron to do
* See Harris email
* Ask about sum nk/nk stuff
* 
I think we need to define the per-stage sample sizes n_k in the JSS
paper. Also, the expressions of the type:
\{(\sum_{k'=1}^{K} n_{k'})/n_k\}^{-\delta}
should be
\{(\sum_{k'=1}^{K} n_{k'})/(\sum_{k'=1}^{k})\}^{-\delta}
correct?

* I think this is done, but keep an eye out as you read, you search replaced all the "we" statements.
    *   michael email: Can you change all instances of "we find the proportionality constant..." and "we compute..." etc., to be something like: "the proportionality constant is computed by interAdapt ..." and "interAdapt computes". I want it to be clear that interAdapt computes these for the user.
* Send Michael pdf with remaining comments
* Ask Michael about !!!! marks in tex file
* (After Michael reads over final draft) adjust knitr Rmd files.
    * need to change links to documentation, and to EAGLE named stuff.
    * point to github in the about/help page.
    * Change .bib 
* Change links at the head of the knitr files to point to github and interAdapt.
* When ready: Adjust final links and set everything up with interAdapt
    - Update github and spark interAdapt files.
* Add user tracking to spark repo (can do after we submit paper)

#### Done stuff
* Jeff says use GPL-2 License

