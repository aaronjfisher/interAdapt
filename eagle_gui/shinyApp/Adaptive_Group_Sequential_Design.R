## To add: automatic computation of fixed design cutoffs and power
## 			display boundaries for adaptive and fixed designs
##			create table versions of plots, and quick summary comparison
##			make sure everything correctly wired, i.e., current inputs used in last_stage_subpop_2_enrolled_adaptive_design function
## Adaptive, Group Sequential, Enrichment Design
library(mvtnorm)
library(xtable)

## USER CONTROLLED SETTINGS with Sliders:

#data.frame(variable_name=c("p1","p10_user_defined"
#"Subpopulation 1 proportion"),slider_title
## Subpopulation 1 proportion (Range: 0 to 1)
p1_user_defined <- 0.61

## Prob. outcome = 1 under control:
## for Subpop. 1 (Range: 0 to 1)
p10_user_defined <- 0.33
## for Subpop. 2 (Range: 0 to 1)
p20_user_defined <- 0.12

## Prob. outcome = 1 under treatment, at alternative:
## for Subpop. 1 (Range: 0 to 1)
p11_user_defined<- 0.33 + 0.125 
## for Subpop. 2 (Range: 0 to 1)
p21_user_defined<- 0.12 + 0.125

## Alpha allocation
# Desired familywise type I error rate (one-sided) (Range: 0 to 1)
alpha_FWER_user_defined <- 0.025
# Allocation to test of H0C (Range: 0 to 1)
alpha_H0C_proportion_user_defined <- 0.24


## Adaptive Design Per-stage Sample Sizes
per_stage_sample_size_combined_adaptive_design_user_defined <- 150 #(Range: 0 to 1000)
per_stage_sample_size_when_only_subpop_2_enrolled_adaptive_design_user_defined  <- 311 #(Range: 0 to 1000)


## End of list of parameters to put in sliders next to plots 

## Additional Settings to be input using only textboxes (no sliders) under PARAMETERS Tab

## Parameters used in All Designs <please make this a section of input boxes>
# Group Sequential Boundary Parameter (Range: -0.5 to 0.5)
Delta <- (-0.5)
# Number simulated trials
iter <- 7000  # Range: 1 to 500,000
# Time limit for primary function (table_constructor())
time_limit<-45 #(seconds, range from 5 to 60)
# Number stages
total_number_stages <- 5 # Range 1:20
# Enrollment rate for combined population (patients per year)
enrollment_rate_combined_population <- 420

# Delay from enrollment to primary outcome observed in years
delay_from_enrollment_to_primary_outcome <- 1/2 


# Horizontal axis range of treatment effects on risk difference scale:
lower_bound_treatment_effect_subpop_2 <- (-0.2)
upper_bound_treatment_effect_subpop_2 <- (0.2)

## Adaptive Design <please make this a section of input boxes>

last_stage_subpop_2_enrolled_adaptive_design <- 4  #(Range: 1 to total_number_stages, which was defined above; if that's hard to set up, then set max at 20)
## Futility boundary proportionality constant for H0C (z-statistic scale)
H0C_futility_boundary_proportionality_constant_adaptive_design <- 0 #(Range: -10 to 10)
## Futility boundary proportionality constant for H01 (z-statistic scale)
H01_futility_boundary_proportionality_constant_adaptive_design <- 0 #(Range: -10 to 10)

## Fixed design for combined population:<please make this a section of input boxes>
## Futility boundary proportionality constant (z-statistic scale)
H0C_futility_boundary_proportionality_constant_fixed_design <- -0.1 #(Range: -10 to 10)

## Fixed design for subpopulation 1 only:<please make this a section of input boxes>
H01_futility_boundary_proportionality_constant_fixed_design <- -0.1 ##(Range: -10 to 10)



###
###
### List of global variables not accessible by user; I initilize these as functions of above variables, but they are updated everytime table_constructor is called

per_stage_sample_size_combined_fixed_design_H0C <- 90 #(Range: 0 to 1000)
per_stage_sample_size_combined_fixed_design_H01 <- 106 #(Range: 0 to 1000)

H0C_efficacy_boundary_proportionality_constant_fixed_design <- 2.04
H01_efficacy_boundary_proportionality_constant_fixed_design <- 2.04
H0C_efficacy_boundary_proportionality_constant_adaptive_design <- 2.54
H01_efficacy_boundary_proportionality_constant_adaptive_design <- 2.12

risk_difference_list <- seq(lower_bound_treatment_effect_subpop_2,upper_bound_treatment_effect_subpop_2,length=7)


combined_pop_futility_boundaries_adaptive_design <- c(rep(H0C_futility_boundary_proportionality_constant_adaptive_design,last_stage_subpop_2_enrolled_adaptive_design-1),rep(-Inf,total_number_stages-last_stage_subpop_2_enrolled_adaptive_design+1))
subpop_1_futility_boundaries_adaptive_design <-c(H01_futility_boundary_proportionality_constant_adaptive_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),-Inf)

subpop_2_futility_cutoff <- (-Inf)

combined_pop_futility_boundaries_fixed_design_H0C <-c(H0C_futility_boundary_proportionality_constant_fixed_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),-Inf)
subpop_1_futility_boundaries_fixed_design_H0C <-c(rep(Inf,total_number_stages-1),-Inf)

combined_pop_futility_boundaries_fixed_design_H01 <-c(H01_futility_boundary_proportionality_constant_fixed_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),-Inf)
subpop_1_futility_boundaries_fixed_design_H01 <-c(rep(Inf,total_number_stages-1),-Inf)


# function to compute power (or Type I error) for given design vector (n1,n2,b_C,b_S) and data generating distribution;
# the data generating distribution is defined by the coefficient of variation for small IVH patients: cv_subpop_1
# and the coefficient of variation for large IVH patients: cv_subpop_2. 
get_power <- function(p1,total_number_stages=5,k,combined_pop_futility_boundaries,subpop_1_futility_boundaries,n1,n2,b_C,b_S,cv_subpop_1,cv_subpop_2,subpop_2_futility_boundaries=rep(-Inf,total_number_stages),outcome_variance_subpop_1,outcome_variance_subpop_2){
	p2 <- (1-p1)
	#maximum_per_stage_sample_size <- 500
	# Enrollment rate subpop. 1 (patients per year)
	enrollment_rate_subpop_1 <- p1_user_defined*enrollment_rate_combined_population
	# Enrollment rate subpop. 2 (patients per year)
	enrollment_rate_subpop_2 <- (1-p1_user_defined)*enrollment_rate_combined_population #(Range: 0-1000)
	pipeline_boundary_deflation_factor <- (-Inf)
	subpop_2_tradeoff_percentile <- 0
	OBrienFleming_boundaries <- 2.04*sqrt(total_number_stages/(1:total_number_stages))
	## These are sample sizes of number who have final (180 day) outcomes available at each interim analysis; they do not yet include patients in pipeline (handled below)
	mixture_stagewise_sample_sizes <- c(rep(n1,k),rep(n2,total_number_stages-k))
	subpop_1_stagewise_sample_sizes <- c(rep(p1*n1,k),rep(n2,total_number_stages-k))
	subpop_2_stagewise_sample_sizes <- mixture_stagewise_sample_sizes - subpop_1_stagewise_sample_sizes
    # initialize vectors of Z statistics using data restricted to each stage 
	cum_sample_sizes_mixture <- rep(0,total_number_stages)
	cum_sample_sizes_subpop_1 <- rep(0,total_number_stages)
	cum_sample_sizes_subpop_2 <- rep(0,total_number_stages)
	# Build up cumulative sample sizes and assign Z-statistics to each stage (restricted to that stage's data) for 
	for(stage in 1:total_number_stages)
	{
		if(stage==1){cum_sample_sizes_subpop_1[stage] <- subpop_1_stagewise_sample_sizes[1]} else {cum_sample_sizes_subpop_1[stage] <- cum_sample_sizes_subpop_1[stage-1] + subpop_1_stagewise_sample_sizes[stage]}
		if(stage==1){cum_sample_sizes_subpop_2[stage] <- subpop_2_stagewise_sample_sizes[1]} else {cum_sample_sizes_subpop_2[stage] <- cum_sample_sizes_subpop_2[stage-1] + subpop_2_stagewise_sample_sizes[stage]}
	}
	cum_sample_sizes_mixture <- cum_sample_sizes_subpop_2 + cum_sample_sizes_subpop_1
 
    subpop_1_pipeline_stagewise_sample_sizes <- pmin(cum_sample_sizes_subpop_1[total_number_stages]-cum_sample_sizes_subpop_1,enrollment_rate_subpop_1/2)  # number in pipeline if stop enrollment at given stage
    subpop_2_pipeline_stagewise_sample_sizes <- pmin(cum_sample_sizes_subpop_2[total_number_stages]-cum_sample_sizes_subpop_2,((1-p1)/p1)*enrollment_rate_subpop_1/2)  # number in pipeline if stop enrollment at given stage

	cum_sample_sizes_subpop_1_pipeline <- cum_sample_sizes_subpop_1 + subpop_1_pipeline_stagewise_sample_sizes
	cum_sample_sizes_subpop_2_pipeline <- cum_sample_sizes_subpop_2+subpop_2_pipeline_stagewise_sample_sizes
    cum_sample_sizes_mixture_pipeline <- cum_sample_sizes_subpop_1_pipeline+cum_sample_sizes_subpop_2_pipeline 

#	mixture_efficacy_boundaries <- b_C*c(((1:k)/k)^Delta,rep(Inf,total_number_stages-k))
#	subpop_1_efficacy_boundaries <- b_S*(((1:total_number_stages)/total_number_stages)^Delta)
	mixture_efficacy_boundaries <- b_C*c((cum_sample_sizes_mixture[1:k]/cum_sample_sizes_mixture[k])^Delta,rep(Inf,total_number_stages-k))
	subpop_1_efficacy_boundaries <- b_S*(((1:total_number_stages)/total_number_stages)^Delta)
        
	mixture_efficacy_boundaries_pipeline <- b_C*c((cum_sample_sizes_mixture_pipeline[1:k]/cum_sample_sizes_mixture[k])^Delta,rep(Inf,total_number_stages-k))*pipeline_boundary_deflation_factor
# for use in decisions once all pipeline patients finish. Note that denominator: cum_sample_sizes_mixture[k] is correct--this makes boundaries lower at final tests that include pipeline patients compared to tests for deciding when to stop enrollment.

	subpop_1_efficacy_boundaries_pipeline <- b_S*(((1:total_number_stages)/total_number_stages)^Delta)*pipeline_boundary_deflation_factor
                                        #b_S*((cum_sample_sizes_subpop_1_pipeline/cum_sample_sizes_subpop_1[total_number_stages])^Delta)
	# for use in decisions once all pipeline patients finish.

## Get list of sample sizes corresponding to either interim analysis or analysis after stop including all pipeline patients

	all_relevant_subpop_1_sample_sizes <- sort(unique(c(cum_sample_sizes_subpop_1,cum_sample_sizes_subpop_1_pipeline)))
	all_relevant_subpop_2_sample_sizes <- sort(unique(c(cum_sample_sizes_subpop_2,cum_sample_sizes_subpop_2_pipeline)))

## generate z-statistic increments
	Z_subpop_1_increment <- array(0,c(length(all_relevant_subpop_1_sample_sizes),iter)) 
	Z_subpop_1_increment[1,] <- rnorm(iter)+cv_subpop_1*sqrt(all_relevant_subpop_1_sample_sizes[1])
	if(length(all_relevant_subpop_1_sample_sizes)>1)
	{	for(i in 2:length(all_relevant_subpop_1_sample_sizes))
		{
			Z_subpop_1_increment[i,] <- rnorm(iter)+cv_subpop_1*sqrt(all_relevant_subpop_1_sample_sizes[i]-all_relevant_subpop_1_sample_sizes[i-1])
		}
	}
	Z_subpop_2_increment <- array(0,c(length(all_relevant_subpop_2_sample_sizes),iter)) 
	Z_subpop_2_increment[1,] <- rnorm(iter)+cv_subpop_2*sqrt(all_relevant_subpop_2_sample_sizes[1])
	if(length(all_relevant_subpop_2_sample_sizes)>1)
	{
		for(i in 2:length(all_relevant_subpop_2_sample_sizes))
		{
			Z_subpop_2_increment[i,] <- rnorm(iter)+cv_subpop_2*sqrt(all_relevant_subpop_2_sample_sizes[i]-all_relevant_subpop_2_sample_sizes[i-1])
		}
	}
## generate partial sums of increments
## Construct cumulative z-statistics:
	# First for subpop_1 
	Z_subpop_1_partial_weighted_sum_of_increments <- Z_subpop_1_increment
	if(length(all_relevant_subpop_1_sample_sizes)>1)
	{
		for(i in 2:length(all_relevant_subpop_1_sample_sizes))
		{
			Z_subpop_1_partial_weighted_sum_of_increments[i,] <- 
		((sqrt(all_relevant_subpop_1_sample_sizes[i-1]/all_relevant_subpop_1_sample_sizes[i])*Z_subpop_1_partial_weighted_sum_of_increments[i-1,])		
			+ (sqrt((all_relevant_subpop_1_sample_sizes[i]-all_relevant_subpop_1_sample_sizes[i-1])/all_relevant_subpop_1_sample_sizes[i])*Z_subpop_1_increment[i,]))
		}
	}
	Z_subpop_1_cumulative <- array(0,c(total_number_stages,iter))
	for(i in 1:total_number_stages){
		index <- which(all_relevant_subpop_1_sample_sizes==cum_sample_sizes_subpop_1[i])
		Z_subpop_1_cumulative[i,] <- Z_subpop_1_partial_weighted_sum_of_increments[index,]
	}
	Z_subpop_1_cumulative_including_pipeline <- array(0,c(total_number_stages,iter))
	for(i in 1:total_number_stages){
		index <- which(all_relevant_subpop_1_sample_sizes==cum_sample_sizes_subpop_1_pipeline[i])
		Z_subpop_1_cumulative_including_pipeline[i,] <- Z_subpop_1_partial_weighted_sum_of_increments[index,]
	}
	# For Large IVH
	Z_subpop_2_partial_weighted_sum_of_increments <- Z_subpop_2_increment
	if(length(all_relevant_subpop_2_sample_sizes)>1)
	{
		for(i in 2:length(all_relevant_subpop_2_sample_sizes))
		{
			Z_subpop_2_partial_weighted_sum_of_increments[i,] <- 
		((sqrt(all_relevant_subpop_2_sample_sizes[i-1]/all_relevant_subpop_2_sample_sizes[i])*Z_subpop_2_partial_weighted_sum_of_increments[i-1,])		
			+ (sqrt((all_relevant_subpop_2_sample_sizes[i]-all_relevant_subpop_2_sample_sizes[i-1])/all_relevant_subpop_2_sample_sizes[i])*Z_subpop_2_increment[i,]))
		}
	}
	Z_subpop_2_cumulative <- array(0,c(total_number_stages,iter))
	for(i in 1:total_number_stages){
		index <- which(all_relevant_subpop_2_sample_sizes==cum_sample_sizes_subpop_2[i])
		Z_subpop_2_cumulative[i,] <- Z_subpop_2_partial_weighted_sum_of_increments[index,]
	}
	Z_subpop_2_cumulative_including_pipeline <- array(0,c(total_number_stages,iter))
	for(i in 1:total_number_stages){
		index <- which(all_relevant_subpop_2_sample_sizes==cum_sample_sizes_subpop_2_pipeline[i])
		Z_subpop_2_cumulative_including_pipeline[i,] <- Z_subpop_2_partial_weighted_sum_of_increments[index,]
	}

	# Define mixture population z-statistics
	# not including pipeline
	variance_component1 <- (p1^2)*outcome_variance_subpop_1/cum_sample_sizes_subpop_1
	if(p2!=0){variance_component2 <- (p2^2)*outcome_variance_subpop_2/cum_sample_sizes_subpop_2}else{variance_component2 <- 0*variance_component1}
	correlation_Z_subpop_1_with_Z_mixture <- sqrt(variance_component1/(variance_component1+variance_component2)) 
	correlation_Z_subpop_2_with_Z_mixture <- sqrt(variance_component2/(variance_component1+variance_component2))
	Z_mixture_cumulative <- (correlation_Z_subpop_1_with_Z_mixture*Z_subpop_1_cumulative + correlation_Z_subpop_2_with_Z_mixture*Z_subpop_2_cumulative)

	# including pipeline
	variance_component1_including_pipeline <- (p1^2)*outcome_variance_subpop_1/(cum_sample_sizes_subpop_1+subpop_1_pipeline_stagewise_sample_sizes)
	if(p2!=0){variance_component2_including_pipeline <- (p2^2)*outcome_variance_subpop_2/(cum_sample_sizes_subpop_2+subpop_2_pipeline_stagewise_sample_sizes)}else{variance_component2_including_pipeline <- 0*variance_component1_including_pipeline}
	correlation_Z_subpop_1_with_Z_mixture_including_pipeline <- sqrt(variance_component1_including_pipeline/(variance_component1_including_pipeline+variance_component2_including_pipeline))
	correlation_Z_subpop_2_with_Z_mixture_including_pipeline <- sqrt(variance_component2_including_pipeline/(variance_component1_including_pipeline+variance_component2_including_pipeline))
	Z_mixture_cumulative_including_pipeline <- (correlation_Z_subpop_1_with_Z_mixture_including_pipeline*Z_subpop_1_cumulative_including_pipeline + correlation_Z_subpop_2_with_Z_mixture_including_pipeline*Z_subpop_2_cumulative_including_pipeline)
	
## Determine outcomes of each simulated trial
        
	# record if efficacy boundary ever crossed, for each of H0C and H01:
	reversal_at_first_cross_H0C_efficacy_boundary_at_or_before_stage_k <- rep(0,iter)
	reversal_at_first_cross_H01_efficacy_boundary_at_or_after_stage_k <- rep(0,iter)
        ever_cross_H0C_efficacy_boundary_at_or_before_stage_k <- rep(0,iter)
	ever_cross_H01_efficacy_boundary <- rep(0,iter)
	#ever_cross_H0C_futility_boundary <- rep(0,iter)
	#ever_cross_H01_futility_boundary <- rep(0,iter)
	# record stage at which enrollment stopped, for different populations:
	subpop_2_stopped <- rep(0,iter)
	#stopped_subpop_2_previously <- rep(0,iter)
	all_stopped <- rep(0,iter)
	# record stage (if any) at which null hypothesis rejected for efficacy:
	reject_H0C <- rep(0,iter)
        reject_H0C_for_first_time <- rep(0,iter)
	reject_H01_via_step_1 <- rep(0,iter)
        reject_H01_via_step_2 <- rep(0,iter)
	reject_H01_exactly_when_stopped_subpop_2_using_OBrienFleming_boundaries <- rep(0,iter)
	H0C_reversal_due_to_pipeline <- rep(0,iter)
	H01_via_step1_reversal_due_to_pipeline <- rep(0,iter)
	H01_via_step2_reversal_due_to_pipeline <- rep(0,iter)
	# record stage (just) after which trial stops
	#final_stage <- rep(total_number_stages,iter)
	# record stage (just) after which large IVH enrollment stops
	final_stage_C_enrolled_up_through <- rep(total_number_stages,iter)
        final_stage_S_enrolled_up_through <- rep(total_number_stages,iter)
	#final_stage_S <- rep(total_number_stages,iter)

	for(stage in 1:total_number_stages)
	{
          	reversal_at_first_cross_H0C_efficacy_boundary_at_or_before_stage_k <- ifelse((stage <= k) & (!ever_cross_H0C_efficacy_boundary_at_or_before_stage_k) & Z_mixture_cumulative[stage,]>mixture_efficacy_boundaries[stage] & Z_mixture_cumulative_including_pipeline[stage,]<mixture_efficacy_boundaries_pipeline[stage],1,reversal_at_first_cross_H0C_efficacy_boundary_at_or_before_stage_k)
		reversal_at_first_cross_H01_efficacy_boundary_at_or_after_stage_k<- ifelse((stage >= k) & (!ever_cross_H01_efficacy_boundary) & Z_subpop_1_cumulative[stage,]>subpop_1_efficacy_boundaries[stage] & Z_subpop_1_cumulative_including_pipeline[stage,] <subpop_1_efficacy_boundaries_pipeline[stage],1,reversal_at_first_cross_H01_efficacy_boundary_at_or_after_stage_k)
		ever_cross_H0C_efficacy_boundary_at_or_before_stage_k <- ifelse((stage <= k) & Z_mixture_cumulative[stage,]>mixture_efficacy_boundaries[stage] & Z_mixture_cumulative_including_pipeline[stage,]>mixture_efficacy_boundaries_pipeline[stage],1,ever_cross_H0C_efficacy_boundary_at_or_before_stage_k)
		ever_cross_H01_efficacy_boundary <- ifelse(Z_subpop_1_cumulative[stage,]>subpop_1_efficacy_boundaries[stage] & Z_subpop_1_cumulative_including_pipeline[stage,] >subpop_1_efficacy_boundaries_pipeline[stage],1,ever_cross_H01_efficacy_boundary)
		#ever_cross_H0C_futility_boundary <- ifelse(Z_mixture_cumulative[stage,]< (- combined_pop_futility_boundaries[stage]),1,ever_cross_H0C_futility_boundary)
		#ever_cross_H01_futility_boundary <- ifelse(Z_subpop_1_cumulative[stage,]< (-subpop_1_futility_boundaries[stage]),1,ever_cross_H01_efficacy_boundary)

		# Step 1 of algorithm: Determine if any new events where H0C rejected for efficacy:
		reject_H0C_for_first_time <- ifelse((!all_stopped) & (!subpop_2_stopped) & Z_mixture_cumulative[stage,]>mixture_efficacy_boundaries[stage],1,0)
		H0C_reversal_due_to_pipeline <- ifelse(reject_H0C_for_first_time & Z_mixture_cumulative_including_pipeline[stage,]<mixture_efficacy_boundaries_pipeline[stage],1,H0C_reversal_due_to_pipeline)
        reject_H0C <- ifelse(reject_H0C_for_first_time,1,reject_H0C)
        reject_H01_exactly_when_stopped_subpop_2_using_OBrienFleming_boundaries <- ifelse(reject_H0C_for_first_time & Z_subpop_1_cumulative[stage,] > OBrienFleming_boundaries[stage],1,reject_H01_exactly_when_stopped_subpop_2_using_OBrienFleming_boundaries) ## for use in fixed sequence, fixed mixture design only, to conform to Fixed Sequence procedure as in supp materials of Liu and Anderson       
        reject_H01_via_step_1 <- ifelse(reject_H0C_for_first_time & Z_subpop_1_cumulative[stage,] > subpop_1_efficacy_boundaries[stage],1,reject_H01_via_step_1)
        H01_via_step1_reversal_due_to_pipeline <- ifelse(reject_H0C_for_first_time & Z_subpop_1_cumulative[stage,] > subpop_1_efficacy_boundaries[stage] & Z_subpop_1_cumulative_including_pipeline[stage,] < subpop_1_efficacy_boundaries_pipeline[stage],1,H01_via_step1_reversal_due_to_pipeline)

        all_stopped <- ifelse(reject_H0C_for_first_time,1,all_stopped)
        subpop_2_stopped <- ifelse(reject_H0C_for_first_time,1,subpop_2_stopped)
        # Step 2 of algorithm: Determine if stop large IVH for futility
        subpop_2_stopped <- ifelse((!reject_H0C) & Z_mixture_cumulative[stage,] < (-combined_pop_futility_boundaries[stage]),1,subpop_2_stopped)
        ## if only large IVH stopped, but small IVH enrollment went on, then check H01 for efficacy and then futility:
		reject_H01_via_step_2 <- ifelse((!all_stopped) & subpop_2_stopped & Z_subpop_1_cumulative[stage,]>subpop_1_efficacy_boundaries[stage],1,reject_H01_via_step_2)
		H01_via_step2_reversal_due_to_pipeline <- ifelse((!all_stopped) & subpop_2_stopped & Z_subpop_1_cumulative[stage,]>subpop_1_efficacy_boundaries[stage] & Z_subpop_1_cumulative_including_pipeline[stage,]< subpop_1_efficacy_boundaries_pipeline[stage],1,H01_via_step2_reversal_due_to_pipeline)
		
        all_stopped <- ifelse((!all_stopped) & subpop_2_stopped & (reject_H01_via_step_2 | Z_subpop_1_cumulative[stage,]< (-subpop_1_futility_boundaries[stage])),1,all_stopped)

        # record at what stage each subpop. stopped
		final_stage_C_enrolled_up_through <- ifelse(final_stage_C_enrolled_up_through==total_number_stages & subpop_2_stopped==1,stage,final_stage_C_enrolled_up_through)
        final_stage_S_enrolled_up_through <- ifelse(final_stage_S_enrolled_up_through==total_number_stages & all_stopped==1,stage,final_stage_S_enrolled_up_through)

		## Rejected hypotheses factoring in pipeline patient outcomes

		# final_stage <- ifelse(final_stage==total_number_stages & (ever_cross_H0C_efficacy_boundary | ever_cross_H01_efficacy_boundary |  all_stopped),stage,final_stage) # ??		
	}

	# compute each trial's duration:
duration <- cum_sample_sizes_subpop_1[final_stage_S_enrolled_up_through]/enrollment_rate_subpop_1 + 1/2 + 11/12 # add 1/2 year for waiting for 180 day outcomes, plus 11/12 year for assumed ramp up period
	
	# Compute 0.01 quantile of Z_subpop_2_cumulative conditional on rejecting H_0C
	#indexarray <- array(c(final_stage_C_enrolled_up_through,1:length(final_stage_C_enrolled_up_through)),c(length(final_stage_C_enrolled_up_through),2))
	#ZL <- Z_subpop_2_cumulative[indexarray]
	#quantile_Z_subpop_2_cond_on_reject_H_0C <- quantile(ZL[reject_H0C==1],probs=subpop_2_tradeoff_percentile)

#cov_mat_comp <<- cov(cbind(t(Z_mixture_cumulative[1:4,]),t(Z_subpop_1_cumulative)))
#print(max(abs(cov_matrix_full-cov_mat_comp)))

return(c(
#### For adaptive designs
mean(reject_H0C & (!H0C_reversal_due_to_pipeline)), # power to reject H0C
mean((reject_H01_via_step_1 & (!H01_via_step1_reversal_due_to_pipeline)) | (reject_H01_via_step_2 & (!H01_via_step2_reversal_due_to_pipeline))), # power to reject H01
mean((ever_cross_H0C_efficacy_boundary_at_or_before_stage_k & (!reversal_at_first_cross_H0C_efficacy_boundary_at_or_before_stage_k)) | (ever_cross_H01_efficacy_boundary & (!reversal_at_first_cross_H01_efficacy_boundary_at_or_after_stage_k))), # Worst-case Type I error (assuming no futility stopping at all)
mean(cum_sample_sizes_mixture[final_stage_C_enrolled_up_through]-cum_sample_sizes_subpop_1[final_stage_C_enrolled_up_through]+cum_sample_sizes_subpop_1[final_stage_S_enrolled_up_through]), #mean sample size under adaptive design
mean(pmax((cum_sample_sizes_subpop_2[final_stage_C_enrolled_up_through]+pmin(cum_sample_sizes_subpop_2[total_number_stages]-cum_sample_sizes_subpop_2[final_stage_C_enrolled_up_through],enrollment_rate_subpop_2*delay_from_enrollment_to_primary_outcome))/enrollment_rate_subpop_2,(cum_sample_sizes_subpop_1[final_stage_S_enrolled_up_through]+pmin(cum_sample_sizes_subpop_1[total_number_stages]-cum_sample_sizes_subpop_1[final_stage_S_enrolled_up_through],enrollment_rate_subpop_1*delay_from_enrollment_to_primary_outcome))/enrollment_rate_subpop_1))+delay_from_enrollment_to_primary_outcome, ## max of duration corresponding to each subpopulation, including pipeline patients
mean((reject_H0C & (!H0C_reversal_due_to_pipeline)) | (reject_H01_via_step_1 & (!H01_via_step1_reversal_due_to_pipeline)) | (reject_H01_via_step_2 & (!H01_via_step2_reversal_due_to_pipeline))), # reject at least one null hypothesis for efficacy
mean(pmin(cum_sample_sizes_subpop_2[total_number_stages]-cum_sample_sizes_subpop_2[final_stage_C_enrolled_up_through],enrollment_rate_subpop_2*delay_from_enrollment_to_primary_outcome)+
     pmin(cum_sample_sizes_subpop_1[total_number_stages]-cum_sample_sizes_subpop_1[final_stage_S_enrolled_up_through],enrollment_rate_subpop_1*delay_from_enrollment_to_primary_outcome)), # avg. sample size in pipeline in adaptive design
#mean(as.numeric(combined_pop_futility_boundaries[final_stage_C]!=(-Inf))*((1-p1)/p1)*(enrollment_rate_subpop_1*delay_from_enrollment_to_primary_outcome) + as.numeric(subpop_1_futility_boundaries[final_stage_S]!=(-Inf))*enrollment_rate_subpop_1*delay_from_enrollment_to_primary_outcome),# avg. recruited subjects in pipeline in adaptive design

#### For fixed designs that stop when H0C rejected for efficacy or futility:
mean(cum_sample_sizes_mixture[final_stage_C_enrolled_up_through])/enrollment_rate_combined_population + delay_from_enrollment_to_primary_outcome  # avg. trial duration: we add delay_from_enrollment_to_primary_outcome (in years) to account for this extra time
+mean(pmin(cum_sample_sizes_mixture[total_number_stages]-cum_sample_sizes_mixture[final_stage_C_enrolled_up_through],(enrollment_rate_combined_population)*delay_from_enrollment_to_primary_outcome))/(enrollment_rate_combined_population), # extra duration due to pipeline patients completing
mean(cum_sample_sizes_mixture[final_stage_C_enrolled_up_through]), # mean sample size (not including pipeline patients)
mean(pmin(cum_sample_sizes_mixture[total_number_stages]-cum_sample_sizes_mixture[final_stage_C_enrolled_up_through],(enrollment_rate_combined_population)*delay_from_enrollment_to_primary_outcome)), # avg. extra recruited subjects in pipeline
mean(reject_H01_exactly_when_stopped_subpop_2_using_OBrienFleming_boundaries), # only used in fixed sequence, fixed mixture design
0,#quantile_Z_subpop_2_cond_on_reject_H_0C,
### Reversals due to pipeline patients
mean(H0C_reversal_due_to_pipeline),
mean(H01_via_step1_reversal_due_to_pipeline),
mean(H01_via_step2_reversal_due_to_pipeline)
))
}

	
#Search over rejection thresholds to get desired alpha's for adaptive design
get_adaptive_efficacy_boundaries <- function(alpha_FWER,alpha_H0C,outcome_variance_subpop_1,
outcome_variance_subpop_2)
{
	p1 <- p1_user_defined
	p2 <- 1-p1
	k_star <- last_stage_subpop_2_enrolled_adaptive_design
ss<- rep(per_stage_sample_size_combined_adaptive_design_user_defined,k_star)
if(k_star>1)
{
	for(i in 2:k_star){
	ss[i] <- ss[i-1]+per_stage_sample_size_combined_adaptive_design_user_defined
	}
}
	cov_matrix <- diag(k_star)
for(i in 1:k_star){for(j in 1:k_star) cov_matrix[i,j] <- sqrt(min(ss[i],ss[j])/max(ss[i],ss[j]))}

#sqrt_vector <- sqrt(ss[length(ss)]/ss)
sqrt_vector <- ((1:k_star)/k_star)^Delta

OF_prop_constant_upper_bnd <- 10
OF_prop_constant_lower_bnd <- 0
while(OF_prop_constant_upper_bnd-OF_prop_constant_lower_bnd > 0.000001)
{
	OF_prop_constant_midpt <- mean(c(OF_prop_constant_lower_bnd,OF_prop_constant_upper_bnd))
	type_I_error <- 1-(pmvnorm(lower=rep(-Inf,k_star),upper=OF_prop_constant_midpt*sqrt_vector,mean=rep(0,k_star),sigma=cov_matrix))
	if(type_I_error < alpha_H0C) OF_prop_constant_upper_bnd <- OF_prop_constant_midpt else OF_prop_constant_lower_bnd <- OF_prop_constant_midpt
}
H0C_prop_const <- OF_prop_constant_midpt
OF_final_boundaries_H0C <- OF_prop_constant_midpt*sqrt_vector
#print(OF_final_boundaries_H0C)

## Generate boundaries for H01
## construct cumulative sample sizes
cum_sample_sizes_subpop_1 <- c(p1_user_defined*ss,rep(0,total_number_stages-k_star))
if(total_number_stages-k_star >0)
{
	for(i in (k_star+1):total_number_stages){
	cum_sample_sizes_subpop_1[i] <-  cum_sample_sizes_subpop_1[i-1]+ per_stage_sample_size_when_only_subpop_2_enrolled_adaptive_design_user_defined
	}
}

## construct covariance matrix of Z_{C,1},dots,Z_{C,k_star},Z_{S,1},dots,Z_{S,total_number_stages}
cov_matrix_full <- cov_matrix_full_check <- diag(k_star+total_number_stages)
## upper left set to cov_matrix for Z_{C,j}:
cov_matrix_full[1:k_star,1:k_star] <- cov_matrix
## build lower right for Z_{S,j} 
for(i in 1:total_number_stages){for(j in 1:total_number_stages) cov_matrix_full[i+k_star,j+k_star] <- sqrt(min(cum_sample_sizes_subpop_1[i],cum_sample_sizes_subpop_1[j])/max(cum_sample_sizes_subpop_1[i],cum_sample_sizes_subpop_1[j]))}


cum_sample_sizes_subpop_2 <- c(ss*(1-p1_user_defined),rep(ss[k_star]*(1-p1_user_defined),total_number_stages-k_star))

## build upper right and lower left parts of covariance matrix Z_{C,i}Z_{S,j}
for(i in 1:k_star){
	for(j in 1:total_number_stages){
	cov_matrix_full[j+k_star,i] <-cov_matrix_full[i,j+k_star] <- sqrt((min(cum_sample_sizes_subpop_1[i],cum_sample_sizes_subpop_1[j])/max(cum_sample_sizes_subpop_1[i],cum_sample_sizes_subpop_1[j]))*(p1*outcome_variance_subpop_1/(p1*outcome_variance_subpop_1+p2*outcome_variance_subpop_2)))}}
## Do binary search to set threshold for H01.
#print(cov_matrix_full)
#sqrt_vector_subpop_1 <- sqrt(cum_sample_sizes_subpop_1[length(cum_sample_sizes_subpop_1)]/cum_sample_sizes_subpop_1)
sqrt_vector_subpop_1 <- ((1:total_number_stages)/total_number_stages)^Delta

OF_prop_constant_upper_bnd <- 10
OF_prop_constant_lower_bnd <- 0
while(OF_prop_constant_upper_bnd-OF_prop_constant_lower_bnd > 0.000001)
{
	OF_prop_constant_midpt <- mean(c(OF_prop_constant_lower_bnd,OF_prop_constant_upper_bnd))
	type_I_error <- 1-(pmvnorm(lower=rep(-Inf,k_star+total_number_stages),upper=c(OF_final_boundaries_H0C,OF_prop_constant_midpt*sqrt_vector_subpop_1),mean=rep(0,k_star+total_number_stages),sigma=cov_matrix_full))
	#print(pmvnorm(lower=rep(-Inf,k_star+total_number_stages),upper=c(OF_final_boundaries_H0C,OF_prop_constant_midpt*sqrt_vector_subpop_1),mean=rep(0,k_star+total_number_stages),sigma=cov_matrix_full))
	if(type_I_error < alpha_FWER) OF_prop_constant_upper_bnd <- OF_prop_constant_midpt else OF_prop_constant_lower_bnd <- OF_prop_constant_midpt
}
H01_prop_const <- OF_prop_constant_midpt
OF_final_boundaries_H01 <- OF_prop_constant_midpt*sqrt_vector_subpop_1
#print(OF_final_boundaries_H01)
return(c(H0C_prop_const,H01_prop_const))
}




# Construct table of values to display in plots

table_constructor <- function(){

setTimeLimit(time_limit)

### Built in settings (not user controlled)
# Probability randomized to control Arm
# for Subpop. 1 (Range: 0 to 1)
r10 <- 1/2 
# for Subpop. 2 (Range: 0 to 1)
r20 <- 1/2
k <- last_stage_subpop_2_enrolled_adaptive_design



futility_boundaries_fixed_design_H0C <<-c(-H0C_futility_boundary_proportionality_constant_fixed_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),-Inf)

futility_boundaries_fixed_design_H01 <<-c(-H01_futility_boundary_proportionality_constant_fixed_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),-Inf)

#Placeholders only here
subpop_1_futility_boundaries_fixed_design_H0C <- rep(Inf,total_number_stages)
subpop_1_futility_boundaries_fixed_design_H01 <- rep(Inf,total_number_stages)
subpop_2_futility_cutoff <<- (-Inf)

p1 <- p1_user_defined
p2 <- (1-p1)
error_counter <- 0

#if(design_type=="adaptive") {subpop_2_futility_cutoff <- power_vec[12]} else {}
subpop_2_futility_cutoff <- (-Inf)
subpop_2_futility_boundaries <- c(rep(subpop_2_futility_cutoff,last_stage_subpop_2_enrolled_adaptive_design),rep(Inf,total_number_stages-last_stage_subpop_2_enrolled_adaptive_design))

#per_stage_sample_size_combined_fixed_design_H0C <<- 90 #(Range: 0 to 1000)
#per_stage_sample_size_combined_fixed_design_H01 <<- 106 #(Range: 0 to 1000)


p11 <- p11_user_defined
p10 <- p10_user_defined
p21 <- p21_user_defined
p20 <- p20_user_defined
	
	
## Fixed Design for Total Pop., Per-stage Sample Size
outcome_variance_subpop_1_under_null <- p10*(1-p10)/r10+p10*(1-p10)/(1-r10)
outcome_variance_subpop_2_under_null <- p20*(1-p20)/r20+p20*(1-p20)/(1-r20)
prop_consts <- get_adaptive_efficacy_boundaries(alpha_FWER_user_defined,alpha_H0C_proportion_user_defined*alpha_FWER_user_defined,outcome_variance_subpop_1_under_null,outcome_variance_subpop_2_under_null)
#print(prop_consts)
H0C_efficacy_boundary_proportionality_constant_adaptive_design <<- prop_consts[1] 
#(Range: 0 to 10)
H01_efficacy_boundary_proportionality_constant_adaptive_design <<- prop_consts[2] 
#(Range: 0 to 10)

## Get efficacy boundary for fixed design H0C, and required sample size to achieve desired_power_H0C_fixed_design
ss <- 1:total_number_stages
cov_matrix <- diag(total_number_stages)
for(i in 1:total_number_stages){for(j in 1:total_number_stages) cov_matrix[i,j] <- sqrt(min(ss[i],ss[j])/max(ss[i],ss[j]))}
sqrt_vector <- ((1:total_number_stages)/total_number_stages)^Delta
OF_prop_constant_upper_bnd <- 10
OF_prop_constant_lower_bnd <- 0
while(OF_prop_constant_upper_bnd-OF_prop_constant_lower_bnd > 0.000001)
{
	OF_prop_constant_midpt <- mean(c(OF_prop_constant_lower_bnd,OF_prop_constant_upper_bnd))
	type_I_error <- 1-(pmvnorm(lower=rep(-Inf,total_number_stages),upper=c(OF_prop_constant_midpt*sqrt_vector),mean=rep(0,total_number_stages),sigma=cov_matrix))
	#print(pmvnorm(lower=rep(-Inf,k_star+total_number_stages),upper=c(OF_final_boundaries_H0C,OF_prop_constant_midpt*sqrt_vector_subpop_1),mean=rep(0,k_star+total_number_stages),sigma=cov_matrix_full))
	if(type_I_error < alpha_FWER_user_defined) OF_prop_constant_upper_bnd <- OF_prop_constant_midpt else OF_prop_constant_lower_bnd <- OF_prop_constant_midpt
}
H0C_efficacy_boundary_proportionality_constant_fixed_design <<- OF_prop_constant_midpt
H01_efficacy_boundary_proportionality_constant_fixed_design <<- OF_prop_constant_midpt

H0C_efficacy_boundaries <- H0C_efficacy_boundary_proportionality_constant_adaptive_design*c(((1:k)/k)^Delta,rep(Inf,total_number_stages-k))

subpop_1_efficacy_boundaries <- H01_efficacy_boundary_proportionality_constant_adaptive_design*(((1:total_number_stages)/total_number_stages)^Delta)

combined_pop_futility_boundaries_adaptive_design <<- c(rep(-H0C_futility_boundary_proportionality_constant_adaptive_design,last_stage_subpop_2_enrolled_adaptive_design-1),-H0C_efficacy_boundaries[k],rep(-Inf,total_number_stages-last_stage_subpop_2_enrolled_adaptive_design))

subpop_1_futility_boundaries_adaptive_design <<- c(-H01_futility_boundary_proportionality_constant_adaptive_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),-subpop_1_efficacy_boundaries[total_number_stages])


print_ss_and_boundaries_flag <- 1
cv_small <- (p11-p10)/sqrt(p11*(1-p11)/r10+p10*(1-p10)/(1-r10))
outcome_variance_subpop_1 <- p11*(1-p11)/r10+p10*(1-p10)/(1-r10)

risk_difference_list <<- sort(unique(c(seq(max(c(min(c(lower_bound_treatment_effect_subpop_2,upper_bound_treatment_effect_subpop_2,0)),-p20)),min(c(max(c(lower_bound_treatment_effect_subpop_2,upper_bound_treatment_effect_subpop_2,p21_user_defined-p20_user_defined,0)),1-p20)),length=10))))



fixed_mixture_df <- array(0,c(length(risk_difference_list),4))
fixed_small_only_df <- array(0,c(length(risk_difference_list),3))
adaptive_df <- array(0,c(length(risk_difference_list),5))
overrun_df <- array(0,c(length(risk_difference_list),3))
counter_mixture <- 1
counter_small <- 1
counter_adaptive <- 1
 
for(percent_benefit_subpop_2 in rev(risk_difference_list))
{
	## Compute ss., duration, power at fixed design
	p21 <- p20 + percent_benefit_subpop_2 #need to max sure min & max are .001 & .999, see next two lines
	p21<-max(p21,.001)
	p21<-min(p21,.999)
	cv_large <- (p21-p20)/sqrt(p21*(1-p21)/r20+p20*(1-p20)/(1-r20)) 
	#print(c(percent_benefit_subpop_2,cv_large,cv_small))
    outcome_variance_subpop_2 <- p21*(1-p21)/r20+p20*(1-p20)/(1-r20)

power_vec <- get_power(p1=p1_user_defined,total_number_stages,k=last_stage_subpop_2_enrolled_adaptive_design,combined_pop_futility_boundaries_adaptive_design,subpop_1_futility_boundaries_adaptive_design,n1=per_stage_sample_size_combined_adaptive_design_user_defined,n2=per_stage_sample_size_when_only_subpop_2_enrolled_adaptive_design_user_defined,b_C=H0C_efficacy_boundary_proportionality_constant_adaptive_design,b_S=H01_efficacy_boundary_proportionality_constant_adaptive_design,cv_subpop_1=cv_small,cv_subpop_2=cv_large,subpop_2_futility_boundaries=c(rep(subpop_2_futility_cutoff,k),rep(Inf,total_number_stages-k)),outcome_variance_subpop_1,outcome_variance_subpop_2)

adaptive_df[counter_adaptive,] <- c(power_vec[4]+power_vec[7],power_vec[c(5,1,2,6)])
overrun_df[counter_adaptive,1] <- power_vec[7]
counter_adaptive <- counter_adaptive + 1

power_vec <- get_power(p1=p1_user_defined,total_number_stages=total_number_stages,k=total_number_stages,futility_boundaries_fixed_design_H0C,subpop_1_futility_boundaries=subpop_1_futility_boundaries_fixed_design_H0C,n1=per_stage_sample_size_combined_fixed_design_H0C,n2=0,b_C=H0C_efficacy_boundary_proportionality_constant_fixed_design,b_S=Inf,cv_subpop_1=cv_small,cv_subpop_2=cv_large,subpop_2_futility_boundaries=c(rep(subpop_2_futility_cutoff,k),rep(Inf,total_number_stages-k)),outcome_variance_subpop_1,outcome_variance_subpop_2)
fixed_mixture_df[counter_mixture,] <- c(power_vec[9] + power_vec[10],power_vec[c(8,1)],power_vec[11])
overrun_df[counter_mixture,2] <- power_vec[10]
counter_mixture <- counter_mixture +1


#load("min_sum_ss_configuration_small_IVH_only.rdata")


power_vec <- get_power(p1=1,total_number_stages=total_number_stages,k=total_number_stages,futility_boundaries_fixed_design_H01,subpop_1_futility_boundaries=subpop_1_futility_boundaries_fixed_design_H01,n1=per_stage_sample_size_combined_fixed_design_H01,n2=0,b_C=H01_efficacy_boundary_proportionality_constant_fixed_design,b_S=Inf,cv_subpop_1=cv_small,cv_subpop_2=cv_large,subpop_2_futility_boundaries=c(rep(subpop_2_futility_cutoff,k),rep(Inf,total_number_stages-k)),outcome_variance_subpop_1,outcome_variance_subpop_2)
fixed_small_only_df[counter_small,] <- c(power_vec[9] + power_vec[10],power_vec[c(8,1)])
overrun_df[counter_small,3] <- power_vec[10]

counter_small <- counter_small +1

}
return(data.frame(cbind(rev(risk_difference_list),adaptive_df,fixed_mixture_df,fixed_small_only_df,overrun_df)))
}


power_curve_plot <- function()
{
## Power Curve Plot:
plot(0,type="n",xlim=c(min(risk_difference_list),max(risk_difference_list)),ylim=c(0,1),main="Power versus Average Treatment Effect",xlab="Avg. Treatment Effect on Risk Difference Scale in Subpopulation 2",ylab="Power")

lines(x=rev(risk_difference_list),y=table1[,6],lty=1,col=1,lwd=3)
# H0C adaptive
lines(x=rev(risk_difference_list),y=table1[,4],lty=2,col=1,lwd=3)
# H01 adaptive
lines(x=rev(risk_difference_list),y=table1[,5],lty=3,col=1,lwd=3)

# H0C fixed
lines(x=rev(risk_difference_list),y=table1[,9],lty=4,col=3,lwd=3)

# H01 fixed
lines(x=rev(risk_difference_list),y=table1[,13],lty=5,col=4,lwd=3)
ltext<-rep(NA,5)
ltext[1]<-expression(paste("Adaptive, Power H"[0][C]," or H"[0][1]))
ltext[2]<-expression(paste("Adaptive, Power H"[0][C]))
ltext[3]<-expression(paste("Adaptive, Power H"[0][1]))
ltext[4]<-expression(paste("Fixed Design Total Pop. (H"[0][C],")"))
ltext[5]<-expression(paste("Fixed Design Subpop. 1 Only (H"[0][1],")"))
legend("bottomright",legend=ltext,lty=c(1,2,3,4,5),col=c(1,1,1,3,4),lwd=c(3,3,3,3,3))
}

expected_sample_size_plot <- function()
{
## Expected Sample Size Plot
min_ess <- 0
max_ess <- max(c(table1[,2],table1[,7],table1[,11]))
plot(0,type="n",xlim=c(min(risk_difference_list),max(risk_difference_list)),ylim=c(min_ess,max_ess),main="Expected Sample Size versus Average Treatment Effect",xlab="Avg. Treatment Effect on Risk Difference Scale in Subpopulation 2",ylab="Expected Sample Size")

# adaptive
lines(x=rev(risk_difference_list),y=table1[,2],lty=1,col=1,lwd=3)

# H0C fixed
lines(x=rev(risk_difference_list),y=table1[,7],lty=2,col=3,lwd=3)

# H01 fixed
lines(x=rev(risk_difference_list),y=table1[,11],lty=3,col=4,lwd=3)
legend("bottomright",legend=c("Adaptive Design","Fixed Design Total Pop.","Fixed Design Subpop. 1 Only"),lty=c(1,2,3),col=c(1,3,4),lwd=c(3,3,3))

}

expected_duration_plot <- function()
{
## Expected Duration Plot
min_dur <- 0
max_dur <- max(c(table1[,3],table1[,8],table1[,12]))
plot(0,type="n",xlim=c(min(risk_difference_list),max(risk_difference_list)),ylim=c(min_dur,max_dur),main="Expected Duration versus Average Treatment Effect",xlab="Avg. Treatment Effect on Risk Difference Scale in Subpopulation 2",ylab="Expected Duration in Years")

# adaptive
lines(x=rev(risk_difference_list),y=table1[,3],lty=1,col=1,lwd=3)

# H0C fixed
lines(x=rev(risk_difference_list),y=table1[,8],lty=2,col=3,lwd=3)

# H01 fixed
lines(x=rev(risk_difference_list),y=table1[,12],lty=3,col=4,lwd=3)
legend("bottomright",legend=c("Adaptive Design","Fixed Design Total Pop.","Fixed Design Subpop. 1 Only"),lty=c(1,2,3),col=c(1,3,4),lwd=c(3,3,3))

}

overrun_plot <- function()
{
## Avg. Overrunning Patients
min_ess <- 0
max_ess <- max(c(table1[,14],table1[,15],table1[,16]))
plot(0,type="n",xlim=c(min(risk_difference_list),max(risk_difference_list)),ylim=c(min_ess,max_ess),main="Expected Number of Overrunning (Pipeline) Patients at End of Trial \n versus Average Treatment Effect",xlab="Avg. Treatment Effect on Risk Difference Scale in Subpopulation 2",ylab="Expected # Overruning Patients")

# adaptive
lines(x=rev(risk_difference_list),y=table1[,14],lty=1,col=1,lwd=3)

# H0C fixed
lines(x=rev(risk_difference_list),y=table1[,15],lty=2,col=3,lwd=3)

# H01 fixed
lines(x=rev(risk_difference_list),y=table1[,16],lty=3,col=4,lwd=3)
legend("bottomright",legend=c("Adaptive Design","Fixed Design Total Pop.","Fixed Design Subpop. 1 Only"),lty=c(1,2,3),col=c(1,3,4),lwd=c(3,3,3))

}

boundary_adapt_plot <-function()
{
adapt_boundary_mat<- t(adaptive_design_sample_sizes_and_boundaries_table()[[1]][c("H0C Efficacy Boundary", "H0C Futility Boundary", "H01 Efficacy Boundary", "H01 Futility Boundary"), ])
fancyTitle<-expression(atop('Decision Boundaries for Sequential Test of Combined Population','Null Hypothesis ( H'[0][C]~') and Subpopulation 1 Null Hypothesis ( H'[0][1]~')'))
matplot(adapt_boundary_mat,type='o',main=fancyTitle,pch=c(19,15,19,15),col=c('black','black','blue','blue'),lty=2,, xlab='Stage',ylab='Boundaries on Z-score scale')
ltext<-rep(NA,4)
ltext[1]<-expression(paste("H"[0][C]," Efficacy Boundary"))
ltext[2]<-expression(paste('H'[0][C],' Futility Boundary'))
ltext[3]<-expression(paste('H'[0][1],' Efficacy Boundary'))
ltext[4]<-expression(paste('H'[0][1],' Futility Boundary'))
legend('topright',ltext,pch=c(19,15,19,15),col=c('black','black','blue','blue'),lty=2) 

#print(adapt_boundary_mat)
}


boundary_fixed_H01_plot <-function()
{

H01_boundary_mat<- t(fixed_H01_design_sample_sizes_and_boundaries_table()[[1]][c("H01 Efficacy Boundary", "H01 Futility Boundary"), ])
fancyTitle<-expression(atop('Decision Boundaries for Sequential Test of', 'Combined Population Null Hypothesis ( H'[0][1]~')'))
matplot(H01_boundary_mat,type='o',main=fancyTitle,lty=2,pch=c(19,15),col='blue', xlab='Stage',ylab='Boundaries on Z-score scale')
ltext<-rep(NA,2)
ltext[1]<-expression(paste('H'[0][1],' Efficacy Boundary'))
ltext[2]<-expression(paste('H'[0][1],' Futility Boundary'))
legend('topright',ltext,lty=2,pch=c(19,15),col='blue')

#print(H01_boundary_mat)
}


boundary_fixed_H0C_plot <-function()
{
H0C_boundary_mat<- t(fixed_H0C_design_sample_sizes_and_boundaries_table()[[1]][c("H0C Efficacy Boundary", "H0C Futility Boundary"), ])
fancyTitle<-expression(atop('Decision Boundaries for Sequential Test of', 'Combined Population Null Hypothesis ( H'[0][C]~')'))
matplot(H0C_boundary_mat,type='o',main=fancyTitle,lty=2,pch=c(19,15),col='black', xlab='Stage',ylab='Boundaries on Z-score scale')
ltext<-rep(NA,2)
ltext[1]<-expression(paste('H'[0][C],' Efficacy Boundary'))
ltext[2]<-expression(paste('H'[0][C],' Futility Boundary'))
legend('topright',ltext,lty=2,pch=c(19,15),col='black')

#print(H0C_boundary_mat)
}



performance_table <- function()
{
output_df <- cbind(as.matrix(table1))
output_df_formatted <- cbind(output_df[,1],output_df[,2],output_df[,3],100*output_df[,4],100*output_df[,5],100*output_df[,6],output_df[,7],output_df[,8],100*output_df[,9],
#100*output_df[,10],
output_df[,11],output_df[,12],100*output_df[,13])
colnames(output_df_formatted) <- c("Subpop.2 Tx. Effect","AD:SS","AD:DUR","AD:Power H0C","AD:Power H01","AD:Power H0C or H01","FC:SS","FC:DUR","FC:Power H0C","FS:SS","FS:DUR","FS:Power H01")
return(list(output_df_formatted,digits=c(0,2,0,1,0,0,0,0,1,0,0,1,0),caption="Comparison of avg sample size (SS), avg duration (DUR), and power (as a percent), for the following designs: the Adaptive Design (AD), the Fixed Design Enrolling Combined Population (FC), and the Fixed Design Enrolling Subpop. 1 Only (FS). All designs strongly control the familywise Type I error rate at level FWER set using slider onleft."))
}

transpose_performance_table<-function(ptable){
	#make a matrix of digit values for each cell
	#take off the 1st entry (=0) from the digits vector (for the head col names)
	#and add a zero column for the new row names
	dpt<-dim(ptable[[1]])
	digitMatPre<-matrix(ptable$digits[-1],nrow=dpt[2],ncol=dpt[1],byrow=FALSE)
	digitMat<-cbind(0,digitMatPre) #add a column of zeros for the row names
	orderedTab<-t(ptable[[1]])[,(dpt[1]:1)] #reverse the col order
	outTab<-data.frame(orderedTab)
	#We need to say include.colnames=FALSE in our custom renderTable function
	return(list( outTab, digits=digitMat, caption=ptable$caption ) )
}

adaptive_design_sample_sizes_and_boundaries_table <- function()
{
	
k <- last_stage_subpop_2_enrolled_adaptive_design
p1 <- p1_user_defined
p2 <- 1-p1

H0C_efficacy_boundaries <- H0C_efficacy_boundary_proportionality_constant_adaptive_design*c(((1:k)/k)^Delta,rep(NA,total_number_stages-k))

subpop_1_efficacy_boundaries <- H01_efficacy_boundary_proportionality_constant_adaptive_design*(((1:total_number_stages)/total_number_stages)^Delta)

combined_pop_futility_boundaries_adaptive_design <<- c(rep(H0C_futility_boundary_proportionality_constant_adaptive_design,last_stage_subpop_2_enrolled_adaptive_design-1),H0C_efficacy_boundaries[k],rep(NA,total_number_stages-last_stage_subpop_2_enrolled_adaptive_design))

subpop_1_futility_boundaries_adaptive_design <<-c(H01_futility_boundary_proportionality_constant_adaptive_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),subpop_1_efficacy_boundaries[total_number_stages])

if(k<total_number_stages){
row1 <- c(p1*per_stage_sample_size_combined_adaptive_design_user_defined*(1:k),p1*per_stage_sample_size_combined_adaptive_design_user_defined*k+per_stage_sample_size_when_only_subpop_2_enrolled_adaptive_design_user_defined*(1:(total_number_stages-k)))

row2 <- c(p2*per_stage_sample_size_combined_adaptive_design_user_defined*(1:k),rep(p2*per_stage_sample_size_combined_adaptive_design_user_defined*k,total_number_stages-k))

row3 <- c(per_stage_sample_size_combined_adaptive_design_user_defined*(1:k),per_stage_sample_size_combined_adaptive_design_user_defined*k+per_stage_sample_size_when_only_subpop_2_enrolled_adaptive_design_user_defined*(1:(total_number_stages-k)))
}else{
row1 <- c(p1*per_stage_sample_size_combined_adaptive_design_user_defined*(1:k))

row2 <- c(p2*per_stage_sample_size_combined_adaptive_design_user_defined*(1:k))

row3 <- c(per_stage_sample_size_combined_adaptive_design_user_defined*(1:k))
}

H0C_efficacy <-  H0C_efficacy_boundaries
#H0C_efficacy[H0C_efficacy==Inf] <- rep(0,5-k)
H0C_futility <- combined_pop_futility_boundaries_adaptive_design
H01_efficacy <- subpop_1_efficacy_boundaries
H01_futility <- subpop_1_futility_boundaries_adaptive_design

output_df <- rbind(row1,row2,row3,H0C_efficacy,H0C_futility,H01_efficacy,H01_futility)
row.names(output_df) <- c("Cum. Sample Size Subpop. 1","Cum. Sample Size: Subpop. 2","Cum. Sample Size Combined Pop.","H0C Efficacy Boundary","H0C Futility Boundary","H01 Efficacy Boundary","H01 Futility Boundary")
colnames(output_df) <- 1:total_number_stages
dig_array <- array(0,c(7,(total_number_stages+1)))
#dig_array[4:7,] <- array(2,c(4,(total_number_stages+1)))
dig_array[4:7,2:(total_number_stages+1)] <- ifelse(is.na(output_df[4:7,]),0,ifelse(output_df[4:7,]==0,0,2))
return(list(output_df,digits=dig_array,caption="Cumulative Sample Sizes and Decision Boundaries for Adaptive Design. Each column corresponds to a stage. All thresholds are given on the z-statistic scale."))
#print(xtable(output_df,digits=dig_array,caption="Cumulative Sample Sizes and Decision Boundaries for Adaptive Design. Each column corresponds to a stage. All thresholds are given on the z-statistic scale."))
}

fixed_H0C_design_sample_sizes_and_boundaries_table <- function()
{
k<-total_number_stages
p1 <- p1_user_defined
p2 <- 1-p1

H0C_efficacy_boundaries <- H0C_efficacy_boundary_proportionality_constant_fixed_design*c(((1:k)/k)^Delta)

futility_boundaries_fixed_design_H0C <<-c(H0C_futility_boundary_proportionality_constant_fixed_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),H0C_efficacy_boundaries[total_number_stages])

row1 <- c(p1*per_stage_sample_size_combined_fixed_design_H0C*(1:k))

row2 <- c(p2*per_stage_sample_size_combined_fixed_design_H0C*(1:k))

row3 <- c(per_stage_sample_size_combined_fixed_design_H0C*(1:k))

H0C_efficacy <-  H0C_efficacy_boundaries
#H0C_efficacy[H0C_efficacy==Inf] <- rep(0,5-k)
H0C_futility <- futility_boundaries_fixed_design_H0C


output_df <- rbind(row1,row2,row3,H0C_efficacy,H0C_futility)
row.names(output_df) <- c("Cum. Sample Size Subpop. 1","Cum. Sample Size: Subpop. 2","Cum. Sample Size Combined Pop.","H0C Efficacy Boundary","H0C Futility Boundary")
colnames(output_df) <- 1:total_number_stages
dig_array <- array(0,c(5,(total_number_stages+1)))
#dig_array[4:7,] <- array(2,c(4,(total_number_stages+1)))
dig_array[4:5,2:(total_number_stages+1)] <- ifelse(is.na(output_df[4:5,]),0,ifelse(output_df[4:5,]==0,0,2))
return(list(output_df,digits=dig_array,caption="Cumulative Sample Sizes and Decision Boundaries for Fixed Design Enrolling Combined Population. Each column corresponds to a stage. All thresholds are given on the z-statistic scale."))


}

fixed_H01_design_sample_sizes_and_boundaries_table <- function()
{
k<-total_number_stages
p1 <- p1_user_defined
p2 <- 1-p1

H01_efficacy_boundaries <- H01_efficacy_boundary_proportionality_constant_fixed_design*c(((1:k)/k)^Delta)

futility_boundaries_fixed_design_H01 <<-c(H01_futility_boundary_proportionality_constant_fixed_design*(((1:(total_number_stages-1))/(total_number_stages-1))^Delta),H01_efficacy_boundaries[total_number_stages])


row1 <- c(per_stage_sample_size_combined_fixed_design_H01*(1:k))

H01_efficacy <-  H01_efficacy_boundaries
#H0C_efficacy[H0C_efficacy==Inf] <- rep(0,5-k)
H01_futility <- futility_boundaries_fixed_design_H01

output_df <- rbind(row1,H01_efficacy,H01_futility)
row.names(output_df) <- c("Cum. Sample Size","H01 Efficacy Boundary","H01 Futility Boundary")
colnames(output_df) <- 1:total_number_stages
dig_array <- array(0,c(3,(total_number_stages+1)))
#dig_array[4:7,] <- array(2,c(4,(total_number_stages+1)))
dig_array[2:3,2:(total_number_stages+1)] <- ifelse(is.na(output_df[2:3,]),0,ifelse(output_df[2:3,]==0,0,2))
return(list(output_df,digits=dig_array,caption="Cumulative Sample Sizes and Decision Boundaries for Fixed Design enrolling only Subpopulation 1. Each column corresponds to a stage. All thresholds are given on the z-statistic scale."))


}


# construct table
#table1 <- table_constructor()