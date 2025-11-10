program analyze_cohorts_individually, rclass
	version 17
	
	syntax, study(string) variables(string) sensitivity(string)

	if "`variables'" == "all" local variables ""MVPA" "LPA" "SED" "TotalPA""
	else local variables "`variables'"

	if "`sensitivity'" == "Men" & "`study'" == "WHS" exit
	if "`sensitivity'" == "AgeBelow60" & "`study'" == "HAI" exit	/* Minimum age in HAI: 69 years */
	if "`sensitivity'" == "AgeBelow60" & "`study'" == "WHS" exit	/* Minimum age in WHS: 62 years */
	
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "ABC" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "HAI" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "REGARDS" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "WHS" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "NNPAS" exit
	

	local logresults = "log"
	local model1only = 0
	local delta1only = 0
	
	
	/* If this is a sensitivity analysis, add it to the end of the log filename */
	if "`sensitivity'" == "none" local sensitivitytext = ""
	else local sensitivitytext = "_`sensitivity'"

	/* Define the covariate to adjust for in Model 1 and Model 2 */
	local covariates1 ""Age" "Gender" "Weartime""
	local covariates2 ""Age" "Gender" "Weartime" "BMI" "Smoke" "Education" "CVD" "Cancer" "Diabetes""
	if "`sensitivity'" == "Men" | "`sensitivity'" == "Women" {
		local covariates1 ""Age" "Weartime""
		local covariates2 ""Age" "Weartime" "BMI" "Smoke" "Education" "CVD" "Cancer" "Diabetes""
	}
	if "`sensitivity'" == "NoAdjForBMI" {
		local covariates2 ""Age" "Gender" "Weartime" "Smoke" "Education" "CVD" "Cancer" "Diabetes""
	}
	if "`sensitivity'" == "ExcludeChronicDiseases" {
		local covariates2 ""Age" "Gender" "Weartime" "Smoke" "Education""
	}
	
	use "Analysis files\\`study'.dta", clear
	
	drop if INCLUDE == 0
	if "`sensitivity'" == "Men" drop if Gender == 0
	if "`sensitivity'" == "Women" drop if Gender == 1
	if "`sensitivity'" == "AgeAbove60" drop if AgeAbove60 == 0
	if "`sensitivity'" == "AgeBelow60" drop if AgeAbove60 == 1
	if "`sensitivity'" == "NoMobilityProblems" drop if Mobilityproblems == 1
	if "`sensitivity'" == "ExcludeChronicDiseases" drop if CVD == 1 | Cancer == 1 | Diabetes == 1
	
	/* stset the data */
	if "`logresults'" ~= "nolog" {
		log using "Results individual cohorts\Log files\stset_`study'`sensitivitytext'.log", replace
	}
	if "`study'" == "NHANES" {
		/* INCORPORATING DESIGN AND WEIGHT */
		/* ALWAYS USE svy: TO GET U.S. REPRESENTATIVE ESTIMATES */
		svyset [w=mec4yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
		stset follow_up_years [pweight=mec4yr], id(ID) failure(Death) 
	}
	else stset follow_up_years, id(ID) failure(Death)	
	if "`logresults'" ~= "nolog" log close
	
	
	/* Make sure each of the covariates is centered on the sample mean */
	/* (This is needed for the adjustments to work in the "xblc" command used in calculate_HRs_and_PIFs.ado) */
	local covars1 "Agec Genderc Weartimec"
	if "`sensitivity'" == "Men" | "`sensitivity'" == "Women" local covars1 "Agec Weartimec"
	local covars2 ""
	foreach covariate in `covariates2' {
		quietly sum `covariate'
		quietly gen `covariate'c = `covariate' - r(mean)
		order `covariate'c, after(`covariate')
		if "`study'" ~= "REGARDS" | "`covariate'" ~= "Cancer" local covars2 "`covars2' `covariate'c"
	}
	
	
	foreach variable in `variables' {
		
		/* ----------------------------------------------------- */
		/* Define delta = the effect sizes (increases in PA/SED) */
		/* and refstep = the difference between reference values */         
		/* ----------------------------------------------------- */
		if "`variable'" == "MVPA" {
			local deltas = "5 10"
			local firstref = 1
			local refstep = 2
			local lastref = 49			
		}
		/* Just to test what happens with a 760 cpm cutoff for MVPA */
		if "`variable'" == "MVPA760" {
			local deltas = "10 20"
			local firstref = 2
			local refstep = 4
			local lastref = 98
		}
		if "`variable'" == "LPA" {
			local deltas = "30 60"
			local firstref = 7.5
			local refstep = 15
			local lastref = 412.5
		}
		if "`variable'" == "SED" {
			local deltas = "-30 -60"
			local firstref = 885
			local refstep = -30
			local lastref = 225
		}
		if "`variable'" == "TotalPA" {
			local deltas = "60 120"
			local deltas = "30 60"
			local firstref = 70
			local refstep = 20
			local lastref = 590
		}
		
		if `delta1only' == 1 local deltas = word("`deltas'", 1)
		

		/* Create restricted cubic spline with 4 knots (using Harrell's recommendation) */
		/* If 4 knots are not possible: try 3 knots */
		/* If 3 knots are not possible: use original variable (no spline) */		
		capture mkspline `variable' = `variable', cubic nknots(4) displayknots
		if _rc == 0  local splinevariables "`variable'1 `variable'2 `variable'3"
		if _rc ~= 0 {
			disp "4 Knots not possible. Trying 3 knots."
			capture mkspline `variable' = `variable', cubic nknots(3) displayknots
			if _rc == 0 local splinevariables = "`variable'1 `variable'2"
			if _rc ~= 0 {
				disp "3 knots not possible. Using original variable (no spline)"
				gen `variable'1 = `variable'
				local splinevariables = "`variable'1"
			}
		}

		forvalues model = 1/2 {
			if "`sensitivity'" == "ActiveInactive" {
				calculate_HR_and_PIF_AI `variable', covariates("`covars`model''") study("`study'") model("`model'")
			}
			else {
				if "`logresults'" ~= "nolog" {
					log using "Results individual cohorts\Log files\Cox_`study'_`variable'_model`model'`sensitivitytext'.log", replace
				}
				if "`study'" == "NHANES" svy: stcox `splinevariables' `covars`model''
				else stcox `splinevariables' `covars`model''
				if "`logresults'" ~= "nolog" log close
				foreach delta in `deltas' {
					calculate_HRs_and_PIFs `splinevariables', varname("`variable'") study("`study'") /*
						*/ model("`model'") delta("`delta'") firstref("`firstref'") refstep("`refstep'") /*
						*/ lastref("`lastref'") sensitivity("`sensitivity'") dropvars `logresults'
				}
			}
			
			if `model1only' == 1 continue, break

		}
	}	

end



