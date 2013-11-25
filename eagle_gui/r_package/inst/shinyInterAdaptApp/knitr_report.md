# About This Report














This report was created using the EAGLE software for generating and analyzing trial designs with adaptive enrollment criteria. EAGLE can be accessed online at

http://spark.rstudio.com/mrosenblum/eagle_gui_demo

Additional documentation for the EAGLE, including instructions on how to download the application for offline use, can be found at

http://www.biostat.jhsph.edu/~afisher/AdaptiveShiny/About_Eagle.pdf

### Table of Contents:
* <a href="#Introduction"> Introduction </a>
* <a href="#Full List of Inputs"> Full List of Inputs </a>
* <a href="#Decision Boundaries"> Decision Boundaries </a>
* <a href="#Performance Comparison Plots"> Performance Comparsion Plots </a>
* <a href="#Performance Comparison Table"> Performance Comparison Table </a>
* <a href="#Formal Description of the Problem"> Formal Description of the Problem </a>
	* <a href="#Hypotheses"> Hypotheses </a>
	* <a href="#Test Statistics"> Test Statistics </a>
	* <a href="#Family-wise Type I Error"> Family-wise Type I Error </a>
	* <a href="#Decision Rules for Stopping the Trial Early"> Decision Rules for Stopping the Trial Early </a>
* <a href="#Inputs"> Inputs</a>
  * <a href="#Basic Parameters"> Basic Parameters</a>
  * <a href="#Advanced Parameters"> Advanced Parameters</a>
* <a href="#References"> References </a>



*************



# <a name="Introduction">Introduction</a>

In this report, we consider the scenario where we have prior evidence that the treatment might work better in a one subpopulation than another. We use the term "adaptive design" to refer to a group sequential design that starts by enrolling from both subpopulations, and then decides whether or not to continue enrolling from each subpopulation based on interim analyses.  We use the term "standard designs" to refer to group sequential designs where the enrollment criteria are fixed.

Below, we describe an adaptive design in more detail, and compare the performance of this design to the performance of standard designs. Performance is compared in terms of expected sample size, expected trial duration, and power, with family-wise type I error rate set to be constant (0.025) for all trials.



*******

# <a name="Full List of Inputs">Full List of Inputs</a>

<!-- html table generated in R 3.0.1 by xtable 1.7-1 package -->
<!-- Tue Nov 12 00:07:35 2013 -->
<TABLE border=1>
  <TR> <TD align="right"> Subpopulation 1 proportion </TD> <TD align="right"> 0.61 </TD> </TR>
  <TR> <TD align="right"> Prob. outcome = 1 under control, subpopulation 1 </TD> <TD align="right"> 0.33 </TD> </TR>
  <TR> <TD align="right"> Prob. outcome = 1 under control, subpopulation 2 </TD> <TD align="right"> 0.12 </TD> </TR>
  <TR> <TD align="right"> Prob. outcome = 1 under treatment for subpopulation 1 </TD> <TD align="right"> 0.46 </TD> </TR>
  <TR> <TD align="right"> Prob. outcome = 1 under treatment for subpopulation 2 </TD> <TD align="right"> 0.46 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size, combined population </TD> <TD align="right"> 150.00 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size for stages where only sub-population 2 is enrolled </TD> <TD align="right"> 311.00 </TD> </TR>
  <TR> <TD align="right"> Alpha (FWER) Requirement  </TD> <TD align="right"> 0.03 </TD> </TR>
  <TR> <TD align="right"> Proportion of Alpha allocated to H0C </TD> <TD align="right"> 0.24 </TD> </TR>
  <TR> <TD align="right"> Delta </TD> <TD align="right"> -0.50 </TD> </TR>
  <TR> <TD align="right"> # of Iterations for simulation </TD> <TD align="right"> 10000.00 </TD> </TR>
  <TR> <TD align="right"> Time limit for simulation, in seconds </TD> <TD align="right"> 45.00 </TD> </TR>
  <TR> <TD align="right"> Total number of stages </TD> <TD align="right"> 5.00 </TD> </TR>
  <TR> <TD align="right"> Participants enrolled per year from combined population </TD> <TD align="right"> 420.00 </TD> </TR>
  <TR> <TD align="right"> Delay time from enrollment to primary outcome in years </TD> <TD align="right"> 0.50 </TD> </TR>
  <TR> <TD align="right"> Lower bound for treatment effect in sub-population 2 </TD> <TD align="right"> -0.20 </TD> </TR>
  <TR> <TD align="right"> Upper bound for treatment effect in sub-population 2 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> Last stage sub-population 2 is enrolled under an adaptive design </TD> <TD align="right"> 4.00 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size for standard group sequential design enrolling combined pop. </TD> <TD align="right"> 106.00 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size for standard group sequential design enrolling only subpop. 1 </TD> <TD align="right"> 90.00 </TD> </TR>
  <TR> <TD align="right"> H0C futility boundary proportionality constant for the adaptive design </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> H01 futility boundary proportionality constant for the adaptive design </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> H0C futility boundary proportionality constant for the fixed design </TD> <TD align="right"> -0.10 </TD> </TR>
  <TR> <TD align="right"> H01 futility boundary proportionality constant for the fixed design </TD> <TD align="right"> -0.10 </TD> </TR>
   </TABLE>


*******
# <a name="Decision Boundaries">Decision Boundaries</a>


![plot of chunk unnamed-chunk-4](tempFiguresForKnitrReport/unnamed-chunk-4.png) 

<!-- html table generated in R 3.0.1 by xtable 1.7-1 package -->
<!-- Tue Nov 12 00:07:35 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Cumulative Sample Sizes and Decision Boundaries for Adaptive Design. Each column corresponds to a stage. All thresholds are given on the z-statistic scale. </CAPTION>
<TR> <TH>  </TH> <TH> 1 </TH> <TH> 2 </TH> <TH> 3 </TH> <TH> 4 </TH> <TH> 5 </TH>  </TR>
  <TR> <TD align="right"> Cum. Sample Size Subpop. 1 </TD> <TD align="right"> 92 </TD> <TD align="right"> 183 </TD> <TD align="right"> 274 </TD> <TD align="right"> 366 </TD> <TD align="right"> 677 </TD> </TR>
  <TR> <TD align="right"> Cum. Sample Size: Subpop. 2 </TD> <TD align="right"> 58 </TD> <TD align="right"> 117 </TD> <TD align="right"> 176 </TD> <TD align="right"> 234 </TD> <TD align="right"> 234 </TD> </TR>
  <TR> <TD align="right"> Cum. Sample Size Combined Pop. </TD> <TD align="right"> 150 </TD> <TD align="right"> 300 </TD> <TD align="right"> 450 </TD> <TD align="right"> 600 </TD> <TD align="right"> 911 </TD> </TR>
  <TR> <TD align="right"> H0C Efficacy Boundary </TD> <TD align="right"> 5.08 </TD> <TD align="right"> 3.59 </TD> <TD align="right"> 2.93 </TD> <TD align="right"> 2.54 </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> H0C Futility Boundary </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 2.54 </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> H01 Efficacy Boundary </TD> <TD align="right"> 4.74 </TD> <TD align="right"> 3.35 </TD> <TD align="right"> 2.74 </TD> <TD align="right"> 2.37 </TD> <TD align="right"> 2.12 </TD> </TR>
  <TR> <TD align="right"> H01 Futility Boundary </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 2.12 </TD> </TR>
   </TABLE>

*******
![plot of chunk unnamed-chunk-6](tempFiguresForKnitrReport/unnamed-chunk-6.png) 

<!-- html table generated in R 3.0.1 by xtable 1.7-1 package -->
<!-- Tue Nov 12 00:07:36 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Cumulative Sample Sizes and Decision Boundaries for Fixed Design Enrolling Combined Population. Each column corresponds to a stage. All thresholds are given on the z-statistic scale. </CAPTION>
<TR> <TH>  </TH> <TH> 1 </TH> <TH> 2 </TH> <TH> 3 </TH> <TH> 4 </TH> <TH> 5 </TH>  </TR>
  <TR> <TD align="right"> Cum. Sample Size Subpop. 1 </TD> <TD align="right"> 65 </TD> <TD align="right"> 129 </TD> <TD align="right"> 194 </TD> <TD align="right"> 259 </TD> <TD align="right"> 323 </TD> </TR>
  <TR> <TD align="right"> Cum. Sample Size: Subpop. 2 </TD> <TD align="right"> 41 </TD> <TD align="right"> 83 </TD> <TD align="right"> 124 </TD> <TD align="right"> 165 </TD> <TD align="right"> 207 </TD> </TR>
  <TR> <TD align="right"> Cum. Sample Size Combined Pop. </TD> <TD align="right"> 106 </TD> <TD align="right"> 212 </TD> <TD align="right"> 318 </TD> <TD align="right"> 424 </TD> <TD align="right"> 530 </TD> </TR>
  <TR> <TD align="right"> H0C Efficacy Boundary </TD> <TD align="right"> 4.56 </TD> <TD align="right"> 3.23 </TD> <TD align="right"> 2.63 </TD> <TD align="right"> 2.28 </TD> <TD align="right"> 2.04 </TD> </TR>
  <TR> <TD align="right"> H0C Futility Boundary </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -0.14 </TD> <TD align="right"> -0.12 </TD> <TD align="right"> -0.10 </TD> <TD align="right"> 2.04 </TD> </TR>
   </TABLE>

*******
![plot of chunk unnamed-chunk-8](tempFiguresForKnitrReport/unnamed-chunk-8.png) 

<!-- html table generated in R 3.0.1 by xtable 1.7-1 package -->
<!-- Tue Nov 12 00:07:36 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Cumulative Sample Sizes and Decision Boundaries for Fixed Design enrolling only Subpopulation 1. Each column corresponds to a stage. All thresholds are given on the z-statistic scale. </CAPTION>
<TR> <TH>  </TH> <TH> 1 </TH> <TH> 2 </TH> <TH> 3 </TH> <TH> 4 </TH> <TH> 5 </TH>  </TR>
  <TR> <TD align="right"> Cum. Sample Size </TD> <TD align="right"> 90 </TD> <TD align="right"> 180 </TD> <TD align="right"> 270 </TD> <TD align="right"> 360 </TD> <TD align="right"> 450 </TD> </TR>
  <TR> <TD align="right"> H01 Efficacy Boundary </TD> <TD align="right"> 4.56 </TD> <TD align="right"> 3.23 </TD> <TD align="right"> 2.63 </TD> <TD align="right"> 2.28 </TD> <TD align="right"> 2.04 </TD> </TR>
  <TR> <TD align="right"> H01 Futility Boundary </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -0.14 </TD> <TD align="right"> -0.12 </TD> <TD align="right"> -0.10 </TD> <TD align="right"> 2.04 </TD> </TR>
   </TABLE>

*******


# <a name="Performance Comparison Plots">Performance Comparison Plots</a>

![plot of chunk unnamed-chunk-10](tempFiguresForKnitrReport/unnamed-chunk-10.png) 

*******
![plot of chunk unnamed-chunk-11](tempFiguresForKnitrReport/unnamed-chunk-11.png) 

*******
![plot of chunk unnamed-chunk-12](tempFiguresForKnitrReport/unnamed-chunk-12.png) 

*******
![plot of chunk unnamed-chunk-13](tempFiguresForKnitrReport/unnamed-chunk-13.png) 

*******

# <a name="Performance Comparison Table">Performance Comparison Table</a>
<!-- html table generated in R 3.0.1 by xtable 1.7-1 package -->
<!-- Tue Nov 12 00:07:36 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Comparison of avg sample size (SS), avg duration (DUR), and power (as a percent), for the following designs: the Adaptive Design (AD), the Fixed Design Enrolling Combined Population (FC), and the Fixed Design Enrolling Subpop. 1 Only (FS). All designs strongly control the familywise Type I error rate at level FWER set using slider onleft. </CAPTION>
  <TR> <TD align="right"> Subpop.2 Tx. Effect </TD> <TD align="right"> -0.12 </TD> <TD align="right"> -0.07 </TD> <TD align="right"> -0.02 </TD> <TD align="right"> 0.03 </TD> <TD align="right"> 0.08 </TD> <TD align="right"> 0.13 </TD> <TD align="right"> 0.18 </TD> <TD align="right"> 0.23 </TD> <TD align="right"> 0.28 </TD> <TD align="right"> 0.34 </TD> </TR>
  <TR> <TD align="right"> AD:SS </TD> <TD align="right"> 723 </TD> <TD align="right"> 732 </TD> <TD align="right"> 741 </TD> <TD align="right"> 734 </TD> <TD align="right"> 711 </TD> <TD align="right"> 678 </TD> <TD align="right"> 639 </TD> <TD align="right"> 610 </TD> <TD align="right"> 583 </TD> <TD align="right"> 563 </TD> </TR>
  <TR> <TD align="right"> AD:DUR </TD> <TD align="right"> 2.5 </TD> <TD align="right"> 2.5 </TD> <TD align="right"> 2.5 </TD> <TD align="right"> 2.5 </TD> <TD align="right"> 2.4 </TD> <TD align="right"> 2.3 </TD> <TD align="right"> 2.1 </TD> <TD align="right"> 2.0 </TD> <TD align="right"> 1.9 </TD> <TD align="right"> 1.9 </TD> </TR>
  <TR> <TD align="right"> AD:Power H0C </TD> <TD align="right"> 5 </TD> <TD align="right"> 13 </TD> <TD align="right"> 28 </TD> <TD align="right"> 46 </TD> <TD align="right"> 66 </TD> <TD align="right"> 81 </TD> <TD align="right"> 92 </TD> <TD align="right"> 97 </TD> <TD align="right"> 99 </TD> <TD align="right"> 100 </TD> </TR>
  <TR> <TD align="right"> AD:Power H01 </TD> <TD align="right"> 81 </TD> <TD align="right"> 81 </TD> <TD align="right"> 82 </TD> <TD align="right"> 77 </TD> <TD align="right"> 61 </TD> <TD align="right"> 43 </TD> <TD align="right"> 26 </TD> <TD align="right"> 17 </TD> <TD align="right"> 11 </TD> <TD align="right"> 7 </TD> </TR>
  <TR> <TD align="right"> AD:Power H0C or H01 </TD> <TD align="right"> 81 </TD> <TD align="right"> 81 </TD> <TD align="right"> 83 </TD> <TD align="right"> 84 </TD> <TD align="right"> 88 </TD> <TD align="right"> 92 </TD> <TD align="right"> 95 </TD> <TD align="right"> 98 </TD> <TD align="right"> 99 </TD> <TD align="right"> 100 </TD> </TR>
  <TR> <TD align="right"> FC:SS </TD> <TD align="right"> 461 </TD> <TD align="right"> 477 </TD> <TD align="right"> 491 </TD> <TD align="right"> 501 </TD> <TD align="right"> 504 </TD> <TD align="right"> 504 </TD> <TD align="right"> 501 </TD> <TD align="right"> 493 </TD> <TD align="right"> 483 </TD> <TD align="right"> 471 </TD> </TR>
  <TR> <TD align="right"> FC:DUR </TD> <TD align="right"> 1.6 </TD> <TD align="right"> 1.6 </TD> <TD align="right"> 1.7 </TD> <TD align="right"> 1.7 </TD> <TD align="right"> 1.7 </TD> <TD align="right"> 1.7 </TD> <TD align="right"> 1.7 </TD> <TD align="right"> 1.7 </TD> <TD align="right"> 1.7 </TD> <TD align="right"> 1.6 </TD> </TR>
  <TR> <TD align="right"> FC:Power H0C </TD> <TD align="right"> 12 </TD> <TD align="right"> 24 </TD> <TD align="right"> 41 </TD> <TD align="right"> 60 </TD> <TD align="right"> 75 </TD> <TD align="right"> 87 </TD> <TD align="right"> 93 </TD> <TD align="right"> 97 </TD> <TD align="right"> 99 </TD> <TD align="right"> 99 </TD> </TR>
  <TR> <TD align="right"> FS:SS </TD> <TD align="right"> 434 </TD> <TD align="right"> 433 </TD> <TD align="right"> 433 </TD> <TD align="right"> 433 </TD> <TD align="right"> 433 </TD> <TD align="right"> 433 </TD> <TD align="right"> 434 </TD> <TD align="right"> 433 </TD> <TD align="right"> 434 </TD> <TD align="right"> 434 </TD> </TR>
  <TR> <TD align="right"> FS:DUR </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.5 </TD> </TR>
  <TR> <TD align="right"> FS:Power H01 </TD> <TD align="right"> 73 </TD> <TD align="right"> 73 </TD> <TD align="right"> 73 </TD> <TD align="right"> 73 </TD> <TD align="right"> 73 </TD> <TD align="right"> 72 </TD> <TD align="right"> 75 </TD> <TD align="right"> 73 </TD> <TD align="right"> 74 </TD> <TD align="right"> 73 </TD> </TR>
   </TABLE>





**********


# <a name="Formal Description of the Problem">Formal Description of the Problem</a>

Consider the case where we have two subpopulations, referred to as subpopulation $A$ and subpopulation $B$. Let subpopulation $A$ be the subpopulation where we have prior evidence of a stronger treatment effect. Let $π_A$ and $π_B$ denote the proportion of patients in each of the two subpopulations. 

Both the adaptive and standard designs discussed here consist of ongoing enrollment, and include rules for stopping the trial early based on interim analyses of currently enrolled patients. We discretize each trial into $K$ stages, and say that the $k ^{th}$ stage will be completed once a pre-specified number of additional patients ($n_k$) have been enrolled. In stages when both subpopulations are being recruited, we assume that $π_A n_k$ of the patients recruited in stage $k$ are from subpopulation $A$, and $π_Bn_k$ are from subpopulation $B$. An interim analysis is done at the end of each stage, which may lead us to stop the trial early if there is either strong evidence of treatment efficacy, or strong evidence of treatment futility.

Let $Y_{i,k}$ be the a binary outcome variable for the $i^{th}$ patient recruited in stage $k$, where $Y_{i,k}=1$ indicates a successful outcome. Let $T_{i,k}$ be an indicator of the event that the $i^{th}$ patient recruited in stage $k$ is assigned to the treatment. EAGLE assumes that the probability of being assigned to treatment is .5.

For subpopulation $A$, denote the probability of a success under treatment as $p_{At}$, and the probability of a success under control as $p_{Ac}$. Similarly for population $B$, let $p_{Bt}$ denote the probability of a success under treatment, and $p_{Bc}$ denote the probability of a success under control. We define the average treatment effect for a given population as difference in the probability of a successful outcome between the treatment and control groups.


In the remained of this section we give an overview of the relevant concepts and notation needed to understand and use EAGLE. A more detailed discussion of the theoretical context, and of the parameter calculation procedure, can be found in (Rosenblum et al. 2013 ).
 
## <a name="Hypotheses">Hypotheses</a>

We focus on testing the null hypothesis for a treatment effect in subpopulation $A$, and the null hypothesis for a treatment effect in the combined population. The two hypotheses are defined respectively as


* $H_{0A}$: $p_{At}-p_{Ac}≤0$
* $H_{0C}$: $π_A(p_{At}-p_{Ac}) + π_B(p_{Bt}-p_{Bc}) ≤ 0$ 


EAGLE generates decision rules for an adaptive design that is able to test both of these hypotheses. The properties of this adaptive design are compared to the properties of a standard design testing only $H_{0C}$, and to the properties of a standard design testing only $H_{0A}$. The adaptive design is referred to as $AD$, and the two standard designs are referred to as $SC$ and $SA$ respectively. All three trials contain $K$ stages, and the decision to entirely stop the trial early can be made at the end of any stage. Again, the trials differ in that $SC$ and $SA$ never change their enrollment criteria, while $AD$ may switch to enroll only patients from subpopulation $A$.


Whenever any of the trials $AD$, $SC$ or $SA$ is stopped early, there will be some patients who have been enrolled but who’s outcomes have not yet been measured. These patients are sometimes referred to as “overrunning” or “pipeline” patients.



## <a name="Test Statistics">Test Statistics</a>

We calculate two z-scores at the end of each stage, one for the treatment effect in the combined population $A$nd one for the treatment effect in subpopulation $A$. 

Denote $Z_{C,k}$ as the standardized Z-score for the estimated treatment effect in the combined population, which is based on the data from all patients with outcomes recorded by the end of stage $k$. When we assume an equal probability of being randomized to either treatment or control, the test statistic $Z_{C,k}$ takes the following form:

\[
Z_{C,k}=\left[
\frac{\sum_{k'=1}^k \sum_{i=1}^{n_k'}Y_{i,k'}T_{i,k'} }
{\sum_{k'=1}^k \sum_{i=1}^{n_k'}T_{i,k}} -
\frac{\sum_{k'=1}^k \sum_{i=1}^{n_k'} Y_{i,k'}(1-T_{i,k'})} 
{\sum_{k'=1}^k \sum_{i=1}^{n_k'}(1-T_{i,k})}
\right] se_{C,k}^{-1}
\]

The term in square brackets is the difference in sample means between the treatment and control groups, and $se_{C,k}$ is the standard error of this difference in sample means:

\[
se_{C,k}=
\left(     \frac{2}{  \sum_{k'=1}^{k} n_{k'}  }       \right)
\left(
\sum_{s ∈ \{ A,B\}} π_s[p_{sc}(1-p_{sc}) + p_{st}(1-p_{st})]
\right)
\]


Let $Z_{A,k}$ and $Z_{B,k}$ denote the analogous test statistics for the Z-statistics of the estimated treatment effect in subpopulations $A$ and $B$. The explicit form of $Z_{A,k}$ can be written as follows, where $A_{i,k}$ is an indicator that the $i ^{th}$ subject recruited in stage $k$ is a member of subpopulation $A$:


\[
Z_{A,k}=\left[
\frac{\sum_{k'=1}^k \sum_{i=1}^{n_k'}Y_{i,k'}T_{i,k'}A_{i,k'} }
{\sum_{k'=1}^k \sum_{i=1}^{n_k'}T_{i,k}A_{i,k'}} -
\frac{\sum_{k'=1}^k \sum_{i=1}^{n_k'} Y_{i,k'}(1-T_{i,k'})A_{i,k'}} 
{\sum_{k'=1}^k \sum_{i=1}^{n_k'}(1-T_{i,k})A_{i,k'}}
\right] se_{A,k}^{-1} 
\] 
 
where

 \[
 se_{A,k}=
\left(     \frac{2}{\sum_{k'=1}^k \sum_{i=1}^{n_k'}A_{i,k'}}       \right)
\left(
π_A[p_{Ac}(1-p_{Ac}) + p_{At}(1-p_{At})]
\right)
\]

We can write $Z_{B,k}$ in an analagous form using an indicator of memebership in population $B$.

The decision rules defined later on in this section for testing $H_{0C}$ and $H_{0A}$ will consist of critical boundaries for $(Z_{C,1},Z_{C,2},...Z_{C,K})$, and $(Z_{A,1},Z_{A,2},...Z_{A,K})$. To calculate the family-wise Type I error of any given set of decision rules, we make use of the multivariate distribution of $(Z_{C,1},Z_{C,2},... Z_{C,K}, Z_{A,1},Z_{A,2},...Z_{A,K})$, which can be shown to be normal with a known covariance matrix (Jennison & Turnbull, 1999 ).



## <a name="Family-wise Type I Error">Family-wise Type I Error</a>

In context of our hypotheses, the Family-wise Type I error rate refers to the combined rate of false positives from testing either $H_{0C}$ and $H_{0A}$. We say that the Family-wise Type I error rate is controlled at level $α$ when the probability of rejecting at least one true hypothesis is less than $α$, under all possible true underlying states of the world.

For all three designs, $AD$, $SC$, and $SA$, we require the same family-wise type I error rate, denoted by $α$. Since the two standard designs $SA$ and $SC$ each only test a single hypothesis, their family-wise Type I error rates are simply equal to the type I error rates of their respective hypothesis tests. A multiple hypothesis correction would have to be made in order to analyze a combination of the results of the two standard designs. We discuss the control of the family-wise Type I error rate for the $AD$ design in the next section.






## <a name="Decision Rules for Stopping the Trial Early">Decision Rules for Stopping the Trial Early</a>

In the $SC$ trail, our decision rules consist of efficacy and futility boundaries for $H_{0C}$. At each stage $k$, we calculate the test statistic $Z_{C,k}$. If $Z_{C,k}$ is above the efficacy boundary for stage $k$, we reject $H_{0C}$ and end the trial. If the $Z_{C,k}$ is between the efficacy and futility boundaries for stage $k$, we make no conclusion and continue the trial. If $Z_{C,k}$ is below the futility boundary for stage $k$, we end the trial with the conclusion that we have failed to reject $H_{0C}$.

The efficacy boundaries for $SC$ are set to be proportional to those described by Wang and Tsiatis (1987). This means that the efficacy boundary for the $k^{th}$ stage is set to $e_{S,C}\{(K -  1)/k\}^{-δ}$, where $K$ is the total number of stages, $δ$ is a constant in the range $[-.5,.5]$, and $e_{S,C}$ is the constant that ensures the desired family-wise Type I error rate. In order to calculate $e_{S,C}$, we make use of the fact that the random vector of test statistics ($Z_{C,1},Z_{C,2},…Z_{C,K}$) follows a multivariate normal distribution with a known covariance structure (Jennison & Turnbull, 1999 ).
Under $H_{0C}$ we assume this vector has mean zero. Using the "mvtnorm" package in R to evaluate the multivariate normal distribution function, we find the proportionality constant $e_{S,C}$ such that the null probability of $Z_{C,k}$ exceeding $e_{S,C}\{(K-1)/k\}^{-δ}$ at any stage $k$ is less than or equal to $α$.

In $SC$, as well as in $SA$ and $AD$, we make use of non-binding futility constants that the study administrators can choose to ignore. All three designs are calibrated such that family-wise type I error rate is controlled at level α regardless of whether the futility boundaries are ignored. In calculating power however, we do assume that the futility boundaries are adhered to.

Futility boundaries for the first $K-1$ stages of $SC$ are also proportional to $\{(K -  1)/k\}^{-δ}$, but with a different proportionality constant, denoted by $f_{S,C}$. The constant $f_{S,C}$ is traditionally set to be negative, though this is not required. Since these futility boundaries are nonbinding, $f_{S,C}$ can be changed by the user without affecting the calculated Type I error rate. In the $K ^{th}$ stage of the trial, EAGLE sets the futility bound to be equal to the efficacy bound. This ensures that $Z_{C,K}$ eventually crosses either the efficacy bound or less futility bound, and that we are always able to make some kind of decision regarding $H_{0C}$ by the time the trial has concluded.

The decision boundaries for $Z_{A,k}$ in the $SA$ design are defined by exactly the same form. The efficacy boundary for the $k^{th}$ stage is set equal to $e_{S,a}\{(K-1)/k\}^{-δ}$, where $e_{S,a}$ is the constant that ensures the appropriate type I error rate. The first $K-1$ futility boundaries for $H_{0A}$ are again set equal to $f_{S,a}\{(K-1)/k\}^{-δ}$,  where $f_{S,a}$ is a constant that can be set by the user. The futility boundary in stage $K$ is set equal to the final efficacy boundary in stage $K$.

Decision boundaries for $AD$ vary from those of the standard designs two ways. First, because $AD$ simultaneously tests $H_{0C}$ and $H_{0A}$ it must have two sets of decision boundaries rather than one. For the $k^{th}$ stage of $AD$, let $u_{C,k}$ and $u_{A,k}$ denote the efficacy boundaries for $H_{0C}$ and $H_{0A}$ respectively. The boundaries $u_{C,k}$ and $u_{A,k}$ are set equal to $e_{AD,C}\{(K-1)/k\}^{-δ}$ and $e_{AD,A}\{(K-1)/k\}^{-δ}$ respectively, where $e_{AD,C}$  and $e_{AD,A}$ are constants set such that the probability of rejecting either hypothesis under the global null hypothesis is zero. 

To correctly calibrate $e_{AD,C}$  and $e_{AD,A}$, EAGLE first chooses $e_{AD,C}$ such the probability of falsely rejecting $H_{0C}$ is $a_c α$, where $a_c$ is a fraction between 0 and 1 that can be specified by the user. Then, conditional on $e_{AD,C}$, EAGLE finds the smallest constant $e_{AD,C}$ such that 

\[\begin{split}
P(Z_{C,k}>e_{AD,C}\{(K-1)/k\}^{-δ} \text{  or  } Z_{A,k}> e_{AD,A}\{(K-1)/k\}^{-δ} \text{  for any $k$}) ≤ α 
\end{split}\]

The futility boundaries $l_{A,k}$ and $l_{B,k}$ are defined relative to the test statistics $Z_{A,k}$ and $Z_{B,k}$. These boundaries equal to $f_{AD,C}\{(K-1)/k\}^{-δ}$ and $f_{AD,A}\{(K-1)/k\}^{-δ}$ respectively, where $f_{AD,C}$ and $f_{AD,A}$ can be set by the user.

As described in (Rosenblum et al. 2013 ), our decision rules in $AD$ consist of the following steps for each stage $k$:


* 1. (Assess Efficacy) If $Z_{C,k} > u_{C,k}$, reject $H_{0C}$. If $Z_{A,k}>u_{A,k}$, reject $H_{0A}$. If either, or both null hypothesis are rejected, stop all enrollment and end the trial.
* 2. (Assess Futility of the entire trial) Else, if $Z_{A,k} ≤ l_{A,k}$ or if this is the final stage of the trial, stop all enrollment and end the trial for futility, failing to reject either $H_{0C}$ or $H_{0A}$.
* 3. (Assess Futility for $H_{0C}$) Else, if $Z_{B,k} ≤ l_{B,k}$, stop enrollment from subpopulation $B$ in all future stages. In this case, the following steps must then be done:
	*  a. If $Z_{A,k} > u_{A,k}$, reject $H_{0A}$ and stop all enrollment.
	*  b. If $Z_{A,k} ≤ l_{A,k}$ or if this is the final stage of the trial, conclude that we've fail to reject either $H_{0C}$ or $H_{0A}$, and stop all enrollment.
	*  c. Else, we continue by enrolling $π_An_{k+1}$ patients from subpopulation $A$, and re-evaluate steps (a)-(b) at the end of the next stage. 
*  4. (Continue Enrollment from Combined Population) Else, if this is not the final stage, continue enrolling from both subpopulations and repeat step 1 at the end of the next stage.




The second way that the decision boundaries of $AD$ differ from those of the standard designs is that we allow for more flexibility in the futility boundaries. EAGLE allows the user to specify a final stage, denoted by $k*$, where we test for an effect in the total population. Regardless of the results at stage $k*$, we always stop enrolling from subpopulation $B$ at stage $k*$, if we have not done so already. We represent this in the context of our decision rules defined above by setting the futility boundary $l_{B,k^\star}$ equal infinity, which ensures that $Z_{B,k^\star} < l_{B,k^\star}$. The futility boundaries $l_{B,k}$ are not defined for $k>k*$.

EAGLE allows the user to specify two stage specific sample sizes, one for stages when both populations are enrolled ($k≤k^\star$), and one for stages where only patients in subpopulation $A$ are enrolled ($k>k^\star$). We refer to these two sample sizes as $n_1^\star$ and $n_k^\star$ respectively.






*************






# <a name="Inputs">Inputs</a>

## <a name="Basic Parameters">Basic Parameters</a>

* Subpopulation $A$ proportion ($π_A$): The proportion of the population in subpopulation $A$. This is the subpopulation in which we have prior evidence of a stronger treatment effect. 

* Probability outcome = 1 under control, subpopulation $A$ ($p_{Ac}$): The probability of experiencing a successful outcome for control patients in subpopulation $A$. This is used in estimating power and expected sample size of each design.

* Probability outcome = 1 under control, subpopulation $B$ ($p_{Bc}$): The probability of experiencing a successful outcome for control patients in subpopulation $B$. This is used in estimating power and expected sample size of each design.

* Probability outcome = 1 under treatment for sub-population $A$ ($p_{At}$): The probability of experiencing a successful outcome for treated patients in subpopulation $A$. Note that a specific effect size is not specified for subpopulation $B$. Instead, EAGLE generates the relevant performance metrics for a range of several possible effect sizes in subpopulation $B$. This range can be specified in the Advanced Parameters section.

* Alpha (FWER) Requirement ($α$): The family-wise Type I error rate for all hypotheses in the trial. In $AD$, this is the probability of falsely rejecting either $H_{0C}$ or $H_{0A}$. In $SC$ it is the probability of falsely rejecting $H_{0C}$. In $SA$ it is the probability of falsely rejecting $H_{0A}$.

* Proportion of Alpha allocated to H0C ($a_C$): To control the family-wise Type I error rate in the $AD$ design, first the test of $H_{0C}$ is calibrated to have a Type I error rate equal to $a_Cα$. The decision rules for $H_{0A}$ are then calibrated so that the overall family-wise Type I error rate is equal to $(1-a_C)α$.

* Per stage sample size, combined population ($n_1^\star$): In $SC$, this is the number of patients that must be recruited before we end each stage to do an interim analysis (???). In $AD$ it is the number of patients required for stages 1 through $k^\star$.

* Per stage sample size for stages where only sub-population 2 is enrolled ($n_k^\star$): In $SA$ this is the number of patients that must be recruited before we end each stage to do an interim analysis (???). In $AD$, it is the number of patients required for each stage after $k^\star$.

## <a name="Advanced Parameters">Advanced Parameters</a>

* Delta (δ): This parameter defines the curvature of the efficacy and futility boundaries, which are all proportional to $\{(K -  1)/k\}^{-δ}$.

* Number of Iterations for simulation: Z-statistics are simulated generate the power, expected sample size, expected trial duration, and expected number of overrunning patients. Generally, about 10,000 simulations are needed for reliable results. It is our experience that a simulation with 10,000 iterations takes about 15 seconds on a modern personal computer.

* Time limit for simulation, in seconds: If the simulation time exceeds this threshold, calculations will stop and the user will get an error message saying that the application has “reached CPU time limit”. To remove the error, either the number of iterations can be reduced, or the time limit for simulation can be extended. EAGLE does not allow for this time limit to exceed 90 seconds.

* Total number of stages (K): The total number of stages for all three designs. 

* Recruitment rate in sub-population $A$: The number of patients recruited per year in sub-population $A$. This will affect the expect duration of the trial.

* Recruitment rate in sub-population $B$: The number of patients recruited per year in sub-population $B$. This will affect the expect duration of the trial.

* Lower bound for treatment effect in sub-population $B$: EAGLE simulates performance metrics under a range of treatment effect sizes for subpopulation $B$. This sets the lower bound for this range.

* Upper bound for treatment effect in sub-population $B$: EAGLE simulates performance metrics under a range of treatment effect sizes for subpopulation $B$. This sets the upper bound for this range.

* Last stage sub-population $B$ is enrolled under an adaptive design ($k^\star$): In the adaptive design, we don’t enroll any patients from subpopulation $B$ after stage $k^\star$. 

* H0C futility boundary proportionality constant for the adaptive design ($f_{AD,C}$): This is used to calculate the futility boundary for $H_{0C}$ in the adaptive design, which is set to $f_{AD,C}\{(K -  1)/k\}^{-δ}$ in stage $k$.

* H0S futility boundary proportionality constant for the adaptive design ($f_{AD,A}$):  This is used to calculate the futility boundary for $H_{0A}$ in the adaptive design, which is set to $f_{AD,A}\{(K -  1)/k\}^{-δ}$ in stage $k$.


* H0C futility boundary proportionality constant for the standard design ($f_{S,C}$): This is used to calculate the futility boundary for $H_{0C}$ in $SC$, which is set to $f_{S,C}\{(K -  1)/k\}^{-δ}$ in stage $k$.


* H0S futility boundary proportionality constant for the standard design ($f_{S,a}$):  This is used to calculate the futility boundary for $H_{0C}$ in $SA$, which is set to $f_{S,a}\{(K -  1)/k\}^{-δ}$ in stage $k$.






**********








# <a name="References">References</a>

This report was created using the "knitr" R package (Xie, 2013 ), with citations created using the "knitcitations" R package (Boettiger, 2013 ).



- Christopher Jennison, Bruce Turnbull,   (1999) Group Sequential Methods with Applications to Clinical Trials.
- Carl Boettiger,   (2013) knitcitations: Citations for knitr markdown files.  [http://CRAN.R-project.org/package=knitcitations](http://CRAN.R-project.org/package=knitcitations)
- Yihui Xie,   (2013) knitr: A general-purpose package for dynamic report generation in R.  [http://yihui.name/knitr/](http://yihui.name/knitr/)
- Michael Rosenblum, Richard Thompson, Brandon Luber, Daniel Hanley,   (2013) Adaptive Group Sequential Designs that Balance the Benefits and Risks of Expanding Inclusion Criteria.  *Under Revision*







