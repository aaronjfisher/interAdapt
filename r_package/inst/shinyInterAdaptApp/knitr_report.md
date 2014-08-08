# About This Report














This report was created using the *interAdapt* software for generating and analyzing trial designs with adaptive enrollment criteria. *interAdapt* can be accessed online at

http://spark.rstudio.com/mrosenblum/interAdapt

Additional documentation for the *interAdapt*, including instructions on how to download the application for offline use, can be found at

https://rawgithub.com/aaronjfisher/interAdapt/master/About_interAdapt.pdf

### Table of Contents:
* <a href="#Introduction"> Introduction </a>
* <a href="#Full List of Inputs"> Full List of Inputs </a>
* <a href="#Decision Boundaries"> Decision Boundaries </a>
* <a href="#Performance Comparison Plots"> Performance Comparsion Plots </a>
* <a href="#Performance Comparison Table"> Performance Comparison Table </a>
* <a href="#Problem Description"> Problem Description </a>
	* <a href="#Hypotheses"> Hypotheses </a>
	* <a href="#Test Statistics"> Test Statistics </a>
	* <a href="#Type I Error Control"> Type I Error Control </a>
	* <a href="#Decision rules for stopping the trial early and for modifying enrollment criteria"> Decision rules for stopping the trial early and for modifying enrollment criteria </a>
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

<!-- html table generated in R 3.1.0 by xtable 1.7-3 package -->
<!-- Thu Jun 12 18:51:16 2014 -->
<TABLE border=1>
  <TR> <TD align="right"> Subpopulation 1 proportion </TD> <TD align="right"> 0.33 </TD> </TR>
  <TR> <TD align="right"> Prob. outcome = 1 under control, subpopulation 1 </TD> <TD align="right"> 0.25 </TD> </TR>
  <TR> <TD align="right"> Prob. outcome = 1 under control, subpopulation 2 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> Prob. outcome = 1 under treatment for subpopulation 1 </TD> <TD align="right"> 0.37 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size, combined population, for adaptive design </TD> <TD align="right"> 280.00 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size for stages where only subpopulation 1 is enrolled, for adaptive design </TD> <TD align="right"> 148.00 </TD> </TR>
  <TR> <TD align="right"> Alpha (FWER) requirement for all designs  </TD> <TD align="right"> 0.03 </TD> </TR>
  <TR> <TD align="right"> Proportion of Alpha allocated to H0C for adaptive design </TD> <TD align="right"> 0.09 </TD> </TR>
  <TR> <TD align="right"> Delta </TD> <TD align="right"> -0.50 </TD> </TR>
  <TR> <TD align="right"> # of Iterations for simulation </TD> <TD align="right"> 10000.00 </TD> </TR>
  <TR> <TD align="right"> Time limit for simulation, in seconds </TD> <TD align="right"> 45.00 </TD> </TR>
  <TR> <TD align="right"> Total number of stages </TD> <TD align="right"> 5.00 </TD> </TR>
  <TR> <TD align="right"> Last stage subpopulation 2 is enrolled under adaptive design </TD> <TD align="right"> 3.00 </TD> </TR>
  <TR> <TD align="right"> Participants enrolled per year from combined population </TD> <TD align="right"> 420.00 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size for standard group sequential design (SC) enrolling combined pop. </TD> <TD align="right"> 106.00 </TD> </TR>
  <TR> <TD align="right"> Per stage sample size for standard group sequential design (SS) enrolling only subpop. 1 </TD> <TD align="right"> 100.00 </TD> </TR>
  <TR> <TD align="right"> Stopping boundary proportionality constant for subpopulation 2 enrollment for adaptive design </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> H01 futility boundary proportionality constant for adaptive design </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> H0C futility boundary proportionality constant for standard design </TD> <TD align="right"> -0.10 </TD> </TR>
  <TR> <TD align="right"> H01 futility boundary proportionality constant for standard design </TD> <TD align="right"> -0.10 </TD> </TR>
  <TR> <TD align="right"> Lowest value to plot for treatment effect in subpopulation 2 </TD> <TD align="right"> -0.20 </TD> </TR>
  <TR> <TD align="right"> Greatest value to plot for treatment effect in subpopulation 2 </TD> <TD align="right"> 0.20 </TD> </TR>
   </TABLE>


*******
# <a name="Decision Boundaries">Decision Boundaries</a>


![plot of chunk unnamed-chunk-4](tempFiguresForKnitrReport/unnamed-chunk-4.png) 

<!-- html table generated in R 3.1.0 by xtable 1.7-3 package -->
<!-- Thu Jun 12 18:51:16 2014 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Cumulative Sample Sizes and Decision Boundaries for Adaptive Design. Each column corresponds to a stage. All thresholds are given on the z-statistic scale. </CAPTION>
<TR> <TH>  </TH> <TH> 1 </TH> <TH> 2 </TH> <TH> 3 </TH> <TH> 4 </TH> <TH> 5 </TH>  </TR>
  <TR> <TD align="right"> Cumulative Sample Size Subpop. 1 </TD> <TD align="right"> 92 </TD> <TD align="right"> 185 </TD> <TD align="right"> 277 </TD> <TD align="right"> 425 </TD> <TD align="right"> 573 </TD> </TR>
  <TR> <TD align="right"> Cumulative Sample Size Subpop. 2 </TD> <TD align="right"> 188 </TD> <TD align="right"> 375 </TD> <TD align="right"> 563 </TD> <TD align="right"> 563 </TD> <TD align="right"> 563 </TD> </TR>
  <TR> <TD align="right"> Cumulative Sample Size Combined Pop. </TD> <TD align="right"> 280 </TD> <TD align="right"> 560 </TD> <TD align="right"> 840 </TD> <TD align="right"> 988 </TD> <TD align="right"> 1136 </TD> </TR>
  <TR> <TD align="right"> H0C Efficacy Boundaries u(C,k) for z-statistics Z(C,k) </TD> <TD align="right"> 4.95 </TD> <TD align="right"> 3.50 </TD> <TD align="right"> 2.86 </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> Boundaries l(2,k) for Z(2,k) to Stop Subpop. 2 Enrollment </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> Inf </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> H01 Efficacy Boundaries u(1,k) for Z(1,k) </TD> <TD align="right"> 5.10 </TD> <TD align="right"> 3.61 </TD> <TD align="right"> 2.95 </TD> <TD align="right"> 2.38 </TD> <TD align="right"> 2.05 </TD> </TR>
  <TR> <TD align="right"> Boundaries l(1,k) for Z(1,k) to Stop All Enrollment </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 2.05 </TD> </TR>
   </TABLE>

*******
![plot of chunk unnamed-chunk-6](tempFiguresForKnitrReport/unnamed-chunk-6.png) 

<!-- html table generated in R 3.1.0 by xtable 1.7-3 package -->
<!-- Thu Jun 12 18:51:16 2014 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Cumulative Sample Sizes and Decision Boundaries for Standard Design Enrolling Combined Population. Each column corresponds to a stage. All thresholds are given on the z-statistic scale. </CAPTION>
<TR> <TH>  </TH> <TH> 1 </TH> <TH> 2 </TH> <TH> 3 </TH> <TH> 4 </TH> <TH> 5 </TH>  </TR>
  <TR> <TD align="right"> Cumulative Sample Size Subpop. 1 </TD> <TD align="right"> 35 </TD> <TD align="right"> 70 </TD> <TD align="right"> 105 </TD> <TD align="right"> 140 </TD> <TD align="right"> 175 </TD> </TR>
  <TR> <TD align="right"> Cumulative Sample Size Subpop. 2 </TD> <TD align="right"> 71 </TD> <TD align="right"> 142 </TD> <TD align="right"> 213 </TD> <TD align="right"> 284 </TD> <TD align="right"> 355 </TD> </TR>
  <TR> <TD align="right"> Cumulative Sample Size Combined Pop. </TD> <TD align="right"> 106 </TD> <TD align="right"> 212 </TD> <TD align="right"> 318 </TD> <TD align="right"> 424 </TD> <TD align="right"> 530 </TD> </TR>
  <TR> <TD align="right"> H0C Efficacy Boundaries for z-statistics Z(C,k) </TD> <TD align="right"> 4.56 </TD> <TD align="right"> 3.23 </TD> <TD align="right"> 2.63 </TD> <TD align="right"> 2.28 </TD> <TD align="right"> 2.04 </TD> </TR>
  <TR> <TD align="right"> H0C Futility Boundaries for z-statistics Z(C,k) </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -0.14 </TD> <TD align="right"> -0.12 </TD> <TD align="right"> -0.10 </TD> <TD align="right"> 2.04 </TD> </TR>
   </TABLE>

*******
![plot of chunk unnamed-chunk-8](tempFiguresForKnitrReport/unnamed-chunk-8.png) 

<!-- html table generated in R 3.1.0 by xtable 1.7-3 package -->
<!-- Thu Jun 12 18:51:17 2014 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Cumulative Sample Sizes and Decision Boundaries for Standard Design enrolling only Subpopulation 1. Each column corresponds to a stage. All thresholds are given on the z-statistic scale. </CAPTION>
<TR> <TH>  </TH> <TH> 1 </TH> <TH> 2 </TH> <TH> 3 </TH> <TH> 4 </TH> <TH> 5 </TH>  </TR>
  <TR> <TD align="right"> Cumulative Sample Size </TD> <TD align="right"> 100 </TD> <TD align="right"> 200 </TD> <TD align="right"> 300 </TD> <TD align="right"> 400 </TD> <TD align="right"> 500 </TD> </TR>
  <TR> <TD align="right"> H01 Efficacy Boundaries for z-statistics Z(1,k) </TD> <TD align="right"> 4.56 </TD> <TD align="right"> 3.23 </TD> <TD align="right"> 2.63 </TD> <TD align="right"> 2.28 </TD> <TD align="right"> 2.04 </TD> </TR>
  <TR> <TD align="right"> H01 Futility Boundaries for z-statistics Z(1,k) </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -0.14 </TD> <TD align="right"> -0.12 </TD> <TD align="right"> -0.10 </TD> <TD align="right"> 2.04 </TD> </TR>
   </TABLE>

*******


# <a name="Performance Comparison Plots">Performance Comparison Plots</a>

![plot of chunk unnamed-chunk-10](tempFiguresForKnitrReport/unnamed-chunk-10.png) 

*******
![plot of chunk unnamed-chunk-11](tempFiguresForKnitrReport/unnamed-chunk-11.png) 

*******
![plot of chunk unnamed-chunk-12](tempFiguresForKnitrReport/unnamed-chunk-12.png) 

*******


# <a name="Performance Comparison Table">Performance Comparison Table</a>
<!-- html table generated in R 3.1.0 by xtable 1.7-3 package -->
<!-- Thu Jun 12 18:51:17 2014 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> </br> Comparison of avg sample size, avg duration (DUR), and power (as a percent), for the following designs: the Adaptive Design (AD), the Standard Design Enrolling Combined Population (SC), and the Standard Design Enrolling Subpop. 1 Only (SS). All designs strongly control the familywise Type I error rate at 0.025. </CAPTION>
  <TR> <TD align="right"> Subpop.2 Tx. Effect </TD> <TD align="right"> -0.20 </TD> <TD align="right"> -0.16 </TD> <TD align="right"> -0.11 </TD> <TD align="right"> -0.07 </TD> <TD align="right"> -0.02 </TD> <TD align="right"> 0.02 </TD> <TD align="right"> 0.07 </TD> <TD align="right"> 0.11 </TD> <TD align="right"> 0.16 </TD> <TD align="right"> 0.20 </TD> </TR>
  <TR> <TD align="right"> AD:Sample Size </TD> <TD align="right"> 583 </TD> <TD align="right"> 581 </TD> <TD align="right"> 582 </TD> <TD align="right"> 600 </TD> <TD align="right"> 671 </TD> <TD align="right"> 763 </TD> <TD align="right"> 778 </TD> <TD align="right"> 707 </TD> <TD align="right"> 612 </TD> <TD align="right"> 545 </TD> </TR>
  <TR> <TD align="right"> AD:DUR </TD> <TD align="right"> 2.9 </TD> <TD align="right"> 2.8 </TD> <TD align="right"> 2.8 </TD> <TD align="right"> 2.8 </TD> <TD align="right"> 2.8 </TD> <TD align="right"> 2.7 </TD> <TD align="right"> 2.4 </TD> <TD align="right"> 1.9 </TD> <TD align="right"> 1.5 </TD> <TD align="right"> 1.3 </TD> </TR>
  <TR> <TD align="right"> AD:Power H0C </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 1 </TD> <TD align="right"> 13 </TD> <TD align="right"> 43 </TD> <TD align="right"> 72 </TD> <TD align="right"> 86 </TD> <TD align="right"> 88 </TD> </TR>
  <TR> <TD align="right"> AD:Power H01 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 73 </TD> <TD align="right"> 51 </TD> <TD align="right"> 24 </TD> <TD align="right"> 8 </TD> <TD align="right"> 3 </TD> </TR>
  <TR> <TD align="right"> AD:Power H0C or H01 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 80 </TD> <TD align="right"> 82 </TD> <TD align="right"> 85 </TD> <TD align="right"> 88 </TD> <TD align="right"> 89 </TD> </TR>
  <TR> <TD align="right"> SC:Sample Size </TD> <TD align="right"> 123 </TD> <TD align="right"> 149 </TD> <TD align="right"> 199 </TD> <TD align="right"> 272 </TD> <TD align="right"> 345 </TD> <TD align="right"> 402 </TD> <TD align="right"> 406 </TD> <TD align="right"> 384 </TD> <TD align="right"> 346 </TD> <TD align="right"> 304 </TD> </TR>
  <TR> <TD align="right"> SC:DUR </TD> <TD align="right"> 0.3 </TD> <TD align="right"> 0.4 </TD> <TD align="right"> 0.5 </TD> <TD align="right"> 0.6 </TD> <TD align="right"> 0.8 </TD> <TD align="right"> 1.0 </TD> <TD align="right"> 1.0 </TD> <TD align="right"> 0.9 </TD> <TD align="right"> 0.8 </TD> <TD align="right"> 0.7 </TD> </TR>
  <TR> <TD align="right"> SC:Power H0C </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 0 </TD> <TD align="right"> 1 </TD> <TD align="right"> 9 </TD> <TD align="right"> 28 </TD> <TD align="right"> 56 </TD> <TD align="right"> 80 </TD> <TD align="right"> 93 </TD> <TD align="right"> 98 </TD> </TR>
  <TR> <TD align="right"> SS:Sample Size </TD> <TD align="right"> 362 </TD> <TD align="right"> 365 </TD> <TD align="right"> 364 </TD> <TD align="right"> 363 </TD> <TD align="right"> 364 </TD> <TD align="right"> 363 </TD> <TD align="right"> 366 </TD> <TD align="right"> 363 </TD> <TD align="right"> 362 </TD> <TD align="right"> 364 </TD> </TR>
  <TR> <TD align="right"> SS:DUR </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> <TD align="right"> 2.6 </TD> </TR>
  <TR> <TD align="right"> SS:Power H01 </TD> <TD align="right"> 79 </TD> <TD align="right"> 78 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 78 </TD> <TD align="right"> 78 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> <TD align="right"> 79 </TD> </TR>
   </TABLE>





**********


# <a name="Problem Description">Problem Description</a>


We consider the problem of designing a randomized trial to test whether a new treatment is superior to control, for a given population (e.g., those with intracerebral hemorrhage in  the MISTIE example).
Consider the case where we have two subpopulations, referred to as subpopulation $1$ and subpopulation $2$, which partition the overall population of interest. These must be specified before the trial starts, and be defined in terms of participant attributes measured at baseline (e.g., having a high initial severity of disease or a certain biomarker value). 
We focus on situations where  there is suggestive, prior evidence that the treatment may be more likely to benefit subpopulation $1$.
In the MISTIE trial example, subpopulation 1 refers to small IVH participants, and subpopulation 2 refers to large IVH participants. 
Let $π_1$ and $π_2$ denote the proportion of the population in subpopulations 1 and 2, respectively.

Both the adaptive and standard designs discussed here involve enrollment over time, and include predetermined rules for stopping the trial early based on interim analyses. Each trial consists of $K$ stages, indexed by $k$. 
In stages where both subpopulations are enrolled, we assume that the proportion of newly recruited participants  in each subpopulation $s \in \{1,2\}$ is equal to the corresponding population proportion $\pi_s$.

For a given design, let $n_k$ denote the maximum number of participants to be enrolled during stage $k$. The number enrolled during stage $k$ will be less than $n_k$ if the trial is entirely stopped before stage $k$ (so that no participants are enrolled in stage $k$) or if in the adaptive design enrollment is restricted to only subpopulation 1 before stage $k$ (as described in the <a href="#Decision rules for stopping the trial early and for modifying enrollment criteria">Decision Rules section</a>). For each subpopulation $s \in \{1,2\}$ and stage $k$, let $N_{s,k}$ denote the maximum cumulative number of subpopulation $s$ participants who have enrolled by the end of stage $k$. Let $N_{C,k}$ denote the maximum cumulative number of enrolled participants from the combined population by the end of stage $k$, i.e.,  $N_{C,k}=N_{1,k}+N_{2,k}$.
The sample sizes will generally differ for different designs.

Let $Y_{i,k}$ be a binary outcome variable for the $i^{th}$ participant recruited in stage $k$, where $Y_{i,k}=1$ indicates a successful outcome. Let $T_{i,k}$ be an indicator of   the $i^{th}$ participant recruited in stage $k$ being assigned to the treatment. We assume for each participant that there is an equal probability of being assigned to  treatment ($T_{i,k}=1$) or control $(T_{i,k}=0$), independent of the participant's subpopulation. We also assume outcomes are observed very soon after enrollment, so that all outcome data is available from currently enrolled participants at each interim analysis.

For subpopulation $1$, denote the probability of a successful outcome under treatment as $p_{1t}$, and the probability of a successful outcome under control as $p_{1c}$. Similarly, for subpopulation $2$, let $p_{2t}$ denote the probability of a success under treatment, and $p_{2c}$ denote the probability of a success under control. 
We assume each of $p_{1c},p_{1t},p_{2c},p_{2t}$ is in the interval $(0,1)$.
We define the true average treatment effect for a given population to be the difference in the probability of a successful outcome comparing treatment versus control.


In the remainder of this section we give an overview of the relevant concepts needed to understand and use *interAdapt*. A more detailed discussion of the theoretical context, and of the efficacy boundary calculation procedure, is provided by (Rosenblum et al. 2013).
 
 
 
## <a name="Hypotheses">Hypotheses</a>

We focus on testing the null hypothesis that, on average, the treatment is no better than control for subpopulation $1$, and the analogous null hypothesis for the combined population. Simultaneous testing of null hypotheses for these two populations was also the goal for the two-stage, adaptive enrichment designs of (Wang et al. 2007).
We define our two null hypotheses, respectively, as


* $H_{01}$: $p_{1t}-p_{1c}≤0$;
* $H_{0C}$: $π_1(p_{1t}-p_{1c}) + π_2(p_{2t}-p_{2c}) ≤ 0$. 




*interAdapt* compares different designs for testing these null hypotheses. 
An adaptive design testing both null hypotheses (denoted $AD$) is compared to two standard designs. The first standard design, denoted $SC$, enrolls the combined population and only tests $H_{0C}$. The second standard design, denoted $SS$, only enrolls subpopulation 1 and tests $H_{01}$.
All three trial designs consist of $K$ stages; the decision to entirely stop the trial early can be made at the end of any stage, based on a preplanned rule. The trials differ in that $SC$ and $SS$ never change their enrollment criteria, while $AD$ may switch from enrolling the combined population  to enrolling only participants from subpopulation $1$.

The standard designs discussed here are not identical to those discussed in section 6.1 of (Rosenblum et al. 2013), which test both hypotheses simultaneously. Implementing standard designs such as those discussed in (Rosenblum et al. 2013) into the *interAdapt* software is an area of future research.

Though it is not of primary interest, we occasionally refer below to the global null hypothesis, defined  to be that $p_{1t}-p_{1c}=p_{2t}-p_{2c}=0$, i.e., zero mean treatment effect in both subpopulations.


## <a name="Test Statistics">Test Statistics</a>

Three (cumulative) z-statistics are computed at the end of each stage $k$. The first is based on all enrolled participants in the combined population, the second is based on all enrolled participants in subpopulation 1, and the third is based on all enrolled participants in subpopulation 2.  Each z-statistic is a standardized difference in sample means, comparing outcomes in the treatment arm versus the control arm.
Let $Z_{C,k}$ denote the z-statistic for the combined population at the end of stage $k$, which  takes the following form:


\[
Z_{C,k}=\left[
\frac{\sum_{k'=1}^k \sum_{i=1}^{n_{k'}}Y_{i,k'}T_{i,k'} }
{\sum_{k'=1}^k \sum_{i=1}^{n_{k'}}T_{i,k'}} -
\frac{\sum_{k'=1}^k \sum_{i=1}^{n_{k'}} Y_{i,k'}(1-T_{i,k'})} 
{\sum_{k'=1}^k \sum_{i=1}^{n_{k'}}(1-T_{i,k'})}
\right]
V_{C,k}^{-1/2}
\]


The term in square brackets is the difference in sample means between the treatment and control groups, and $V_{C,k}$ is the variance of this difference in sample means:

\[
V_{C,k}=
\left(     \frac{2}{  N_{C,k}  }       \right)
\left(
\sum_{s ∈ \{ 1,2\}} π_s[p_{sc}(1-p_{sc}) + p_{st}(1-p_{st})]
\right)
\]

The term in square brackets is the difference in sample means between the treatment and control groups. The term in curly braces is the variance of this difference in sample means. $Z_{C,k}$ is only computed at stage $k$ if the combined population has been enrolled up through the end of stage $k$ (otherwise it is undefined). Our designs never use $Z_{C,k}$ after stages where the combined population has stopped being enrolled.
Let $Z_{1,k}$ and $Z_{2,k}$ denote analogous z-statistics restricted to participants in subpopulation $1$ and subpopulation $2$, respectively. These are formally defined in
(Rosenblum et al. 2013).

## <a name="Type I Error Control">Type I Error Control</a>

The familywise (also called study-wide) Type I error rate is the probability of rejecting one or more true null hypotheses.
For a given design, we say that the familywise Type I error rate is strongly controlled at level $α$ if 
for any values of  $p_{1c},p_{1t},p_{2c},p_{2t}$ (assuming each is in the interval $(0,1)$), 
the probability of rejecting at least one true null hypothesis (among $H_{0C}, H_{01}$) is at most $α$. To be precise, we mean such strong control holds asymptotically, as sample sizes in all stages go to infinity, as formally defined by (Rosenblum et al. 2013).
For all three designs, $AD$, $SC$, and $SS$, we require the familywise Type I error rate to be strongly controlled at level $α$. 
Since the two standard designs $SS$ and $SC$ each only test a single null hypothesis, the familywise Type I error rate for each design is equal to the  Type I error rate for the corresponding, single hypothesis test.



## <a name="Decision rules for stopping the trial early and for modifying enrollment criteria">Decision rules for stopping the trial early and for modifying enrollment criteria</a>

The decision rules for the standard design $SC$ consist of efficacy and futility boundaries for $H_{0C}$, based on the statistics $Z_{C,k}$. At the end of each stage $k$,  the test statistic $Z_{C,k}$ is calculated. If $Z_{C,k}$ is above the efficacy boundary for stage $k$, the design $SC$ rejects $H_{0C}$ and stops the trial. If $Z_{C,k}$ is between the efficacy and futility boundaries for stage $k$, the trial is continued through the next stage (unless the last stage $k=K$ has been completed). If $Z_{C,k}$ is below the futility boundary for stage $k$, the design $SC$ stops the trial and fails to reject $H_{0C}$. *interAdapt* makes the simplification that the number of participants $n_k$ enrolled in each stage of $SC$ is a constant, denoted  $n_{SC}$, that the user can set.

The efficacy boundaries for $SC$ are set to be proportional to those described by Wang and Tsiatis (1987). Specifically, the efficacy boundary for the $k^{th}$ stage is set to $e_{SC}(N_{C,k}/N_{C,K})^{\delta}$, where $K$ is the total number of stages, $δ$ is a constant in the range $[-.5,.5]$, and $e_{SC}$ is the constant computed by  *interAdapt*  to ensure the familywise Type I error rate is at most $\alpha$. Since $n_{k}$ is set equal to $n_{SC}$ for all values of $k$, the maximum cumulative sample size $N_{C,k}$ reduces to $\sum_{k'=1}^k n_{SC}=k n_{SC}$, and the boundary at stage $k$ reduces to the simpler form $e_{SC}(k/K)^\delta$. By default, *interAdapt* sets $\delta$ to be $-0.5$, which corresponds to the efficacy boundaries of (O'Brien & Fleming, 1979).

In order to calculate $e_{SC}$, *interAdapt* makes use of the fact that the random vector of test statistics ($Z_{C,1},Z_{C,2},…Z_{C,K}$) converges asymptotically to a multivariate normal distribution with a known covariance structure (Jennison & Turnbull, 1999).
Using the \pkg{mvtnorm} package (Genz et al. 2013) in *R* to evaluate the multivariate normal distribution function, *interAdapt* computes the proportionality constant $e_{SC}$ to ensure the probability of $Z_{C,k}$ exceeding $e_{SC}(N_{C,k}/N_{C,K})^{\delta}$ at one or more stages $k$ is less than or equal to $α$ at the global null hypothesis defined in the <a href="#Hypotheses">Hypotheses section</a>.

In $SC$, as well as in $SS$ and $AD$, *interAdapt* uses non-binding futility boundaries. That is, the familywise Type I error rate is controlled at level α regardless of whether the futility boundaries are adhered to or ignored. The motivation  is that regulatory agencies may prefer non-binding futility boundaries to ensure Type I error control even if a decision is made to continue the trial despite a futility boundary being crossed.

In calculations of power, expected sample size, and expected trial duration, *interAdapt* assumes futility boundaries are adhered to. 

Futility boundaries for the first $K-1$ stages of $SC$ are set equal to $f_{SC}(N_{C,k}/N_{C,K})^{\delta}$, where $f_{SC}$ is a proportionality constant set by the user. By default, the constant $f_{SC}$ is set to be negative (so the trial  is only stopped for futility  if the z-statistic is below the corresponding negative threshold), although this is not required. In the $K ^{th}$ stage of the trial, *interAdapt* sets the futility boundary to be equal to the efficacy boundary. This ensures that the final z-statistic $Z_{C,K}$ crosses either the efficacy boundary or the futility boundary.

The decision boundaries for the design $SS$  are defined analogously as for the design $SC$, except using z-statistics $Z_{1,k}$. *interAdapt* makes the simplification that the number of participants $n_k$ enrolled in each stage $k$ of $SS$ is constant, denoted by $n_{SS}$, and set by the user.
The efficacy boundary for the $k^{th}$ stage is set equal to $e_{SS}(N_{1,k}/N_{1,K})^{\delta}$, where $e_{SS}$ is the constant computed by  *interAdapt*  to ensure  the  Type I error rate is at most $\alpha$. The first $K-1$ futility boundaries for $H_{01}$ are set equal to $f_{SS}(N_{1,k}/N_{1,K})^{\delta}$,  where $f_{SS}$ is a constant that can be set by the user. The futility boundary in stage $K$ is set equal to the final efficacy boundary in stage $K$.

Consider the adaptive design $AD$.
*interAdapt* allows the user to a priori specify a final stage  at which there will be a test of  the null hypothesis for the combined population, denoted by stage $k^\star$. Regardless of the results at stage $k^\star$, $AD$ always stops enrolling from subpopulation $2$ at the end stage $k^\star$. This reduces the maximum sample size of $AD$ compared to allowing enrollment from both subpopulations through the end of the trial.
The futility boundaries $l_{2,k}$ are not defined for $k>k^\star$, since subpopulation 2 is not enrolled after stage $k^\star$. 
The user may effectively turn off the option described in this paragraph by setting $k^\star=K$, the total number of stages; then the combined population may be enrolled throughout the trial.

For the $AD$ design, the user can specify the following two types of per-stage sample sizes: one for stages where both subpopulations are enrolled $(k \leq k^\star)$, and one for stages where only participants in subpopulation 1 are enrolled $(k > k^\star)$. We refer to these two sample sizes as $n^{(1)}$ and $n^{(2)}$, respectively.


Because $AD$ simultaneously tests $H_{0C}$ and $H_{01}$ it has two sets of decision boundaries. For the $k^{th}$ stage of $AD$, let $u_{C,k}$ and $u_{1,k}$ denote the efficacy boundaries for $H_{0C}$ and $H_{01}$, respectively. The boundaries $u_{C,k}$ 
 are set equal to $e_{AD,C}(N_{C,k}/N_{C,K})^{\delta}$ for each $k\leq k^\star$; 
the boundaries $u_{1,k}$ are set equal to  $e_{AD,1}(N_{1,k}/N_{1,K})^{\delta}$ for each $k \leq K$. 
The constants $e_{AD,C}$  and $e_{AD,1}$ are set such that the probability of rejecting one or more null hypotheses under the global null hypothesis is $\alpha$ (ignoring futility boundaries). It is proved by (Rosenblum et al. 2013) that this strongly controls the familywise Type I error rate at level $\alpha$. The algorithm for computing the proportionality constants $e_{AD,C}, e_{AD,1}$ is described later in this section.



The boundaries for futility stopping of enrollment from certain population in the $AD$ design, at the end of stage $k$, are denoted by $l_{1,k}$ and $l_{2,k}$. These stopping boundaries are defined relative to the test statistics $Z_{1,k}$ and $Z_{2,k}$, respectively. The boundaries $l_{1,k}$ and $l_{2,k}$ are set equal to $f_{AD,1}(N_{1,k}/N_{1,K})^{\delta}$ (for $k\leq K$) and $f_{AD,2}(N_{2,k}/N_{2,K})^{\delta}$ (for $k < k^\star$), respectively, where $f_{AD,1}$ and $f_{AD,2}$ can be set by the user.  In stage $k^\star$, the futility boundary $l_{2,k^\star}$ is set to ''Inf'' (indicating $\infty$), to reflect that we stop enrollment in subpopulation 2. At the end of each stage, $AD$ may decide to continue enrolling from the combined population, enroll only from subpopulation 1 for the remainder of the trial, or stop the trial entirely.  Specific decision rules based on these boundaries for the z-statistics are described below.


As described in (Rosenblum et al. 2013), the decision rule in $AD$ consists of the following steps carried out at the end of each stage $k$:

* 1. (Assess Efficacy) 
 If $Z_{1,k}>u_{1,k}$, reject $H_{01}$.
   If $k\leq k^\star$ and  $Z_{C,k} > u_{C,k}$, reject $H_{0C}$. 
 If $H_{01}$, $H_{0C}$, or both  are rejected, stop all enrollment and end the trial.
* 2. (Assess Futility of Entire Trial) Else, if $Z_{1,k} ≤ l_{1,k}$ or if this is the final stage of the trial, stop all enrollment and end the trial for futility, failing to reject  any null hypothesis.
* 3. (Assess Futility for $H_{0C}$) Else, if $Z_{2,k} ≤ l_{2,k}$, or if $k\geq k^\star$, stop enrollment from subpopulation $2$ in all future stages. In this case, the following steps are iterated at each future stage:
  * 3a. If $Z_{1,k} > u_{1,k}$, reject $H_{01}$ and stop all enrollment.
  * 3b. If $Z_{1,k} ≤ l_{1,k}$ or if this is the final stage of the trial, fail to reject any null hypothesis  and stop all enrollment.
  * 3c. Else, continue enrolling from only subpopulation $1$. If $k < k^\star$ then $π_1n^{(1)}$ participants from subpopulation 1 should be enrolled in the next stage. If $k \geq k^\star$, then $n^{(2)}$ participants from subpopulation 1 should be enrolled in the next stage. In all future stages, ignore steps 1, 2, 4, and use steps 3a--3c.
*  4. (Continue Enrollment from Combined Population) Else, continue by enrolling $\pi_1 n^{(1)}$ participants from subpopulation 1 and $\pi_2 n^{(1)}$ participants from subpopulation 2 for the next stage.


The motivation for Step 2 is that there is assumed to be prior evidence that if the treatment works, it will work for subpopulation 1. Therefore, if subpopulation 1 is stopped for futility, the whole trial is stopped. It is an area of future research to consider modifications to this rule, and to incorporate testing of a null hypothesis for only subpopulation 2.

A consequence of the rule in Step 3 is that Steps 1, 2, and 4 are only carried out for stages $k\leq k^\star$.  This occurs since 
 Step 3 restricts enrollment to subpopulation 1 if $Z_{2,k} ≤ l_{2,k}$ or  $k\geq k^\star$, and if so runs Steps 3a--3c through the remainder of the trial.

We next describe the algorithm used by  *interAdapt* to compute the proportionality constants $e_{AD,C}, e_{AD,1}$ that define the efficacy boundaries $u_{C,k},u_{1,k}$. These are selected to ensure the familywise Type I error rate is strongly controlled at level $\alpha$. By Theorem~5.1 of  (Rosenblum et al. 2013), to guarantee such strong control of the familywise Type I error rate, it suffices to set $u_{C,k},u_{1,k}$ such that the familywise Type I error rate is at most $\alpha$ at the global null hypothesis defined in the <a href="#Hypotheses">Hypotheses section</a>.
The algorithm takes as input the following, which are set by the user as described in the <a href="#Basic Parameters">Basic Parameters section</a>: the per-stage sample sizes $n^{(1)},n^{(2)}$, the study-wide (i.e., familywise) Type I error rate $\alpha$, and a value $a_c$ in the interval $[0,1]$. 
Roughly speaking, $a_c$ represents the fraction of the study-wide Type I error $\alpha$ initially allocated to testing $H_{0C}$, as described next.

The algorithm temporarily sets $e_{AD,1}= \infty$ (effectively ruling out rejection of $H_{01}$)
and computes (via binary search) the smallest value $e_{AD,C}$ such the probability of rejecting $H_{0C}$ is $a_c α$ under the global null hypothesis defined in the <a href="#Hypotheses">Hypotheses section</a>. This defines $e_{AD,C}$. 
Next,  *interAdapt* computes the smallest constant $e_{AD,1}$ such that the probability of rejecting at least one null hypothesis under the global null hypothesis  is at most $\alpha$. 
All of the above computations use the approximation, based on the multivariate central limit theorem, that the joint distribution of the  z-statistics is multivariate normal  with covariance matrix as given, e.g., by (Jennison & Turnbull, 1999; Rosenblum et al. 2013).




*************






# <a name="Inputs">Inputs</a>

## <a name="Basic Parameters">Basic Parameters</a>

* Subpopulation $1$ proportion ($π_1$): The proportion of the population in subpopulation $1$. This is the subpopulation in which we have prior evidence of a stronger treatment effect. 

* Probability outcome = 1 under control, subpopulation $1$ ($p_{1c}$): The probability of a successful outcome for subpopulation $1$ under assignment to the control arm. This is used in estimating power and expected sample size of each design.

* Probability outcome = 1 under control, subpopulation $2$ ($p_{2c}$): The probability of a successful outcome  for subpopulation $2$ under assignment to the control arm. This is used in estimating power and expected sample size of each design.

* Probability outcome = 1 under treatment for subpopulation $1$ ($p_{1t}$): The probability of a successful outcome for  subpopulation $1$ under assignment to the treatment arm. Note that the user does not specify $p_{2t}$; instead, *interAdapt* considers a range of possible values of $p_{2t}$ that can be set through the Advanced Parameters described below.

* Per stage sample size, combined population, for adaptive design ($n^{(1)}$): Number of participants enrolled per stage in $AD$, whenever both subpopulations are being enrolled.

* Per stage sample size for stages where only subpopulation 1 is enrolled, for adaptive design ($n^{(2)}$): The number of participants required for each stage in AD after stage $k^\star$ (only used if $k^\star < K$). For stages up to and including stage $k^\star$, the number of participants enrolled from subpopulation 1 is equal to $\pi_1 n^{(1)}$.


* Alpha (FWER) requirement for all designs ($α$): The familywise Type I error rate defined in the <a href="#Type I Error Control">Type I Error Control section</a>. 


* Proportion of Alpha allocated to H0C for adaptive design ($a_C$): This is used in the algorithm in the <a href="#Decision rules for stopping the trial early and for modifying enrollment criteria">Decision Rules section</a> to construct efficacy boundaries for the design AD.


## <a name="Advanced Parameters">Advanced Parameters</a>

* Delta (δ): This parameter is used as the exponent in defining the efficacy and futility boundaries as described in the <a href="#Decision rules for stopping the trial early and for modifying enrollment criteria">Decision Rules Section</a>.

* \# of Iterations for simulation: This is the number of simulated trials used to 
 approximate the power, expected sample size, and expected trial duration. In each simulated trial,
 z-statistics are simulated from a multivariate normal distribution (determined by the input parameters).
The greater the number of iterations, the more accurate the simulation results will be.
It is our experience that a simulation with 10,000 iterations takes about 7-15 seconds on a commercial laptop.

* Time limit for simulation, in seconds: If the simulation time exceeds this threshold, calculations will stop and the user will get an error message saying that the application has ''reached CPU time limit''. To avoid this, either the number of iterations can be reduced, or the time limit for the simulation can be extended. *interAdapt* does not allow for the time limit to exceed 90 seconds in the online version; there is no such restriction on the local version.

* Total number of stages ($K$): The total number of stages, which is used in each type of design. The maximum allowed number of stages is 20.

* Last stage subpopulation $2$ is enrolled under adaptive design ($k^\star$): In the adaptive design, no participants from subpopulation $2$ are enrolled after stage $k^\star$. 

* Participants enrolled per year from combined population: This is the assumed enrollment rate (per year) for the combined population. It impacts the expected duration of the different trial designs. The enrollment rates for  subpopulations $1$ and $2$ are assumed to equal the combined population enrollment rate multiplied by $π_1$ and $π_2$, respectively. I.e., enrollment rates are proportional to the relative sizes of the subpopulations. This reflects the reality that enrollment will likely be slower for smaller subpopulations.
Active enrollment from one subpopulation is assumed to have no effect on the enrollment rate in the other subpopulation. This implies that each stage of the $AD$ design up to and including stage $k^\star$ takes the same amount of time to complete, regardless of whether enrollment stops for subpopulation 2. Also, each stage after $k^\star$ takes the same amount of time to complete. 


* Per stage sample size for standard group sequential design ($SC$) enrolling combined pop. ($n_{SC}$): The number of participants enrolled in each stage for $SC$.

* Per stage sample size for standard group sequential design ($SS$) enrolling only subpop. 1 ($n_{SS}$): The number of participants enrolled in each stage for $SS$.

* Stopping boundary proportionality constant for subpopulation 2 enrollment for adaptive design ($f_{AD,2}$): This is used to calculate the futility boundaries ($l_{2,k})$ for the z-statistics calculated in subpopulation 2 ($Z_{2,k}$) as defined in the <a href="#Decision rules for stopping the trial early and for modifying enrollment critria">Decision Rules section</a>).

* $H_{01}$ futility boundary proportionality constant for the adaptive design ($f_{AD,1}$):  This is used to calculate the futility boundaries ($l_{1,k}$) for the z-statistics calculated in subpopulation 1 ($Z_{1,k}$) as defined in the <a href="#Decision rules for stopping the trial early and for modifying enrollment criteria"> Decision Rules section<a>).


* $H_{0C}$ futility boundary proportionality constant for the standard design ($f_{SC}$): This is used to calculate the futility boundaries for $H_{0C}$ in $SC$ as defined in the <a href="#Decision rules for stopping the trial early and for modifying enrollment critria">Decision Rules section</a>. 

* $H_{01}$ futility boundary proportionality constant for the standard design ($f_{SS}$):  This is used to calculate the futility boundaries for $H_{01}$ in $SS$ as defined in the <a href="#Decision rules for stopping the trial early and for modifying enrollment critria">Decision Rules section</a>. 

* Lowest value to plot for treatment effect in subpopulation 2: *interAdapt* does simulations under a range of treatment effect sizes $p_{2t}-p_{2c}$ for subpopulation $2$. This sets the lower bound for this range. This effectively sets the lower bound for $p_{2t}$, since $p_{2c}$ is set by the user as a Basic parameter.

* Greatest value to plot for treatment effect in subpopulation 2: *interAdapt* does simulations under a range of treatment effect sizes $p_{2t}-p_{2c}$ for subpopulation $2$. This sets the upper bound for this range.



**********








# <a name="References">References</a>

This report was created using the *knitr* R package (Xie, 2013), with citations created using the *knitcitations* R package (Boettiger, 2013).



- Christopher Jennison, Bruce Turnbull,   (1999) Group Sequential Methods with Applications to Clinical Trials.
- Carl Boettiger,   (2013) knitcitations: Citations for knitr Markdown Files.  [http://CRAN.R-project.org/package=knitcitations](http://CRAN.R-project.org/package=knitcitations)
- Yihui Xie,   (2013) knitr: A General-Purpose Package for Dynamic Report Generation in R.  [http://yihui.name/knitr/](http://yihui.name/knitr/)
- Alan Genz, Frank Bretz, Tetsuhisa Miwa, Xuefei Mi, Friedrich Leisch, Fabian Scheipl, Torsten Hothorn,   (2013) mvtnorm: Multivariate Normal and t Distributions.  [http://CRAN.R-project.org/package=mvtnorm](http://CRAN.R-project.org/package=mvtnorm)
- P.C. O'Brien, T.R. Fleming,   (1979) A Multiple Testing Procedure for Clinical Trials.  *Biometrics*  **35**  549-556-NA
- M Rosenblum, R Thompson, B Luber, D Hanley,   (2013) Adaptive Group Sequential Designs that Balance the Benefits and Risks of Expanding Inclusion Criteria.  *Johns
Hopkins University, Dept. of Biostatistics Working Papers. Working
Paper 250.*  [http://biostats.bepress.com/jhubiostat/paper250](http://biostats.bepress.com/jhubiostat/paper250)
- S. Wang, R. O'Neill, H. Hung,   (2007) Approaches to evaluation of treatment effect in randomized clinical
  trials with genomic subsets.  *Pharmaceut. Statist.*  **6**  227-244-NA







