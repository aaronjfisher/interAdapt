\name{compute_design_performance}
\alias{compute_design_performance}
\title{Compute Design Performance}
\usage{
compute_design_performance(p_1 = 0.33, p_10 = 0.25, p_20 = 0.2,
  p_11 = p_10 + 0.125, per_stage_sample_size_combined_AD = 150,
  per_stage_sample_size_subpop_1_AD = 311, FWER = 0.025,
  FWER_H0C_proportion = 0.09, Delta = -0.5, iter = 7000,
  time_limit = 45, total_number_stages = 5,
  last_stage_subpop_2_enrolled_AD = 3,
  enrollment_rate_combined_population = 420,
  per_stage_sample_size_combined_SC = 90,
  per_stage_sample_size_combined_SS = 106,
  subpop_2_stop_boundary_constant_AD = 0,
  H01_futility_boundary_constant_AD = 0,
  H0C_futility_boundary_constant_SC = -0.1,
  H01_futility_boundary_constant_SS = -0.1,
  lower_bound_treatment_effect_subpop_2 = -0.2,
  upper_bound_treatment_effect_subpop_2 = 0.2, CSV)
}
\arguments{
  \item{p_1}{The proportion of the population in
  subpopulation 1, which is the subpopulation having prior
  evidence of a stronger treatment effect.}

  \item{p_10}{The probability of a successful outcome for
  subpopulation 1 under assignment to the control arm. This
  is used in estimating power and expected sample size.}

  \item{p_20}{The probability of a successful outcome for
  subpopulation 2 under assignment to the control arm. This
  is used in estimating power and expected sample size.}

  \item{p_11}{The probability of a successful outcome for
  subpopulation 1 under assignment to the treatment arm.
  Note that the user does not specify the probability of
  success under treatment for subpopulation 2 (\eqn{p_2t}).
  Instead, \code{compute_design_performance} considers a
  range of possible values of \eqn{p_2t} (see
  the\code{lower_bound_treatment_effect_subpop_2} and
  \code{upper_bound_treatment_effect_subpop_2} arguments).}

  \item{per_stage_sample_size_combined_AD}{The number of
  participants enrolled per stage in adaptive design while
  both subpopulations are being enrolled.}

  \item{per_stage_sample_size_subpop_1_AD}{The number of
  participants required for each stage in adaptive design
  after enrollment for subpopulation 2 has been stopped.}

  \item{FWER}{The familywise Type I error rate
  (\eqn{\alpha}) for all designs (see Fisher et al. 2014).}

  \item{FWER_H0C_proportion}{Proportion of \eqn{\alpha}
  allocated to \eqn{H_{0C}} for adaptive design. This is
  used to construct efficacy boundaries for the adaptive
  design.}

  \item{Delta}{this parameter is used as the exponent in
  defining the efficacy and futility boundaries as
  described (Fisher et al. 2014).}

  \item{iter}{The number of simulated trials used to
  estimate the power, expected sample size, and expected
  trial duration. In each simulated trial, z-statistics are
  simulated from a multivariate normal distribution
  constructed from the input parameters. The more
  iterations, the more accurate the simulation results will
  be.}

  \item{time_limit}{Time limit for simulation in seconds.
  If the simulation exceeds the time limit, calculations
  will stop and the user will get an error message
  ("reached CPU time limit"). See
  \code{\link[base]{setTimeLimit}}. To avoid this, the
  number of iterations (\code{iter}) can be reduced or the
  time limit increased.}

  \item{total_number_stages}{Total number of stages
  (\eqn{K}): The total number of stages, which is used in
  each design.  The maximum allowable number of stages is
  20.}

  \item{last_stage_subpop_2_enrolled_AD}{The last stage
  subpopulation 2 is enrolled, under the adaptive design
  (\eqn{k*}).}

  \item{enrollment_rate_combined_population}{The assumed
  enrollment rate per year for the combined population.
  This impacts the expected duration of the respective
  trial designs. Active enrollments from the two
  subpopulations are assumed to be independent.  The
  enrollment rates for subpopulations 1 and 2 are assumed
  proportional to their initial (and, hypothetically,
  subsequent) relative sizes, reflecting the reality that
  enrollment is likely to be slower for smaller
  subpopulations. This implies that each stage of the
  adaptive design up to and including stage \code{k*} takes
  the same amount of time to complete, regardless of
  whether or not enrollment stops for subpopulation 2.
  Also, each stage after \code{k*} takes the same amount of
  time to complete.}

  \item{per_stage_sample_size_combined_SC}{The number of
  participants enrolled in each stage of the standard group
  sequential design enrolling combined population
  (\code{SC}).}

  \item{per_stage_sample_size_combined_SS}{The number of
  participants enrolled in each stage for standard group
  sequential design enrolling only subpopulation 1
  (\code{SS}).}

  \item{subpop_2_stop_boundary_constant_AD}{Stopping
  boundary proportionality constant for subpopulation 2
  enrollment for adaptive design.}

  \item{H01_futility_boundary_constant_AD}{\eqn{H_{01}}
  futility boundary proportionality constant for the
  adaptive design. This is used to calculate the futility
  boundaries (\eqn{l_{1,k}}) for the z-statistics
  calculated in subpopulation 1 (\eqn{Z_{1,k}}) as defined
  in Section 1.4 (Fisher et al. 2014).}

  \item{H0C_futility_boundary_constant_SC}{\code{H_0C}
  futility boundary proportionality constant for the
  standard design.}

  \item{H01_futility_boundary_constant_SS}{\code{H_01}
  futility boundary proportionality constant for the
  standard design.}

  \item{lower_bound_treatment_effect_subpop_2}{Lowest value
  to plot for treatment effect in subpopulation 2:
  Simulations are performed under a range of treatment
  effect sizes for subpopulation 2.  This parameter sets
  the lower bound for this range. This effectively sets the
  lower bound for the probability of success under
  treatment for subpopulation 2 (\code{p_21}), since
  \code{p_20} is set by the user.}

  \item{upper_bound_treatment_effect_subpop_2}{Simulations
  are performed under a range of treatment effect sizes for
  subpopulation 2 (\code{p_{2t}-p_{2c}}). This parameter
  sets the upper bound for this range.}

  \item{CSV}{A tabular csv-based alternative to the
  numerical parameters above.  The value can be a character
  vector or list of csv filenames with header.  The table
  must minimally include the columns "inputId" and "value"
  (as in the
  \code{\link[interAdapt]{default_parameter_table}}).}
}
\value{
A list with 5 components:

\item{performance_comparison}{Performance table}
\item{AD_design}{efficacy and futility boundaries for the
adaptive design} \item{SC_design}{efficacy and futility
boundaries for the standard design}
\item{SS_design}{efficacy and futility boundaries for the
standard design, enrolling subpopulation 1 only}
\item{input_parameters}{list of parameters values}
}
\description{
Generates decision rules for group sequential trial designs
with adaptive enrollment criteria. Tables are also
generated which compare the performance of these designs to
the performance of standard group sequential designs.
}
\details{
This function is meant to be applied when there is prior
evidence that a treatment might work better in a one
subpopulation than in another. In this context, a trial
with an adaptive enrollment criteria would determine
whether or not to continue enrolling patients from each
subpopulation based on interim analyses of whether each
subpopulation is benefiting. In order for the type I error
and the power of the trial to be calculable, the decision
rules for changing enrollment must be set before the trial
starts. The function generates decision rules for group
sequential trial designs with adaptive enrollment criteria,
and compares the performance of these designs against
standard group sequential designs. Performance is compared
in terms of power, expected sample size, and expected trial
duration.
}
\examples{
#Store function output
o<-compute_design_performance()

names(o)

#Decision rules for trial designs
print(o$SS[[1]])
print(o$SC[[1]])
print(o$AD[[1]])

#Plot decision rules
par(mfrow=c(3,1))
matplot(t(o$SS[[1]][2:3,]),type='o',pch=1,main='Standard trial - subpop 1',xlab='stage',ylab='Z-statistic')
matplot(t(o$SC[[1]][4:5,]),type='o',pch=1,main='Standard trial - combined pop',xlab='stage',ylab='Z-statistic')
matplot(t(o$AD[[1]][4:7,]),type='o',pch=1,main='Adaptive Enrollment',xlab='stage',ylab='Z-statistic')

#Check performance
o$performance[[1]]

#Compare expected sample sizes over a range of treatment effects for subpop2
par(mfrow=c(1,1))
matplot(x=t(o$performance[[1]][1,]),t(o$performance[[1]][c(2,7,10),]),type='l',lty=1,col=1:3,xlab='Subpop.2 Tx. Effect',ylab='Expected Sample Size')
legend('topright',rownames(o$performance[[1]])[c(2,7,10)],col=1:3,lty=1)
}
\references{
interAdapt -- An Interactive Tool for Designing and
Evaluating Randomized Trials with Adaptive Enrollment
Criteria. Working Paper, 2014.
http://arxiv.org/abs/1404.0734
}
\keyword{Adaptive}
\keyword{Group}
\keyword{clinical}
\keyword{designs}
\keyword{enrollment,}
\keyword{sequential}
\keyword{trial,}

