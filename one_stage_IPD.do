cd "[...]\Deaths Potentially Averted"
discard

use "Analysis files\Jointdata.dta", clear

local includeUKBB = 0
local variable = "MVPA"
local sensitivity = "none"
local logresults = "log"

if "`variable'" == "MVPA" {
	local deltas = "5 10"
	local firstref = 1
	local refstep = 2
	local lastref = 49
}


if `includeUKBB' == 0 drop if Studyname == "UKBB"

/* Define the covariate to adjust for in Model 1 and Model 2 */
local covariates1 ""Age" "Gender" "Weartime""
local covariates2 ""Age" "Gender" "Weartime" "BMI" "Smoke" "Education" "CVD" "Cancer" "Diabetes""


/* Make sure each of the covariates is centered on the sample mean */
/* (This is needed for the adjustments to work in the "xblc" command used in calculate_HRs_and_PIFs.ado) */
local covars1 "Agec Genderc Weartimec"
local covars2 ""
foreach covariate in `covariates2' {
	quietly sum `covariate'
	quietly gen `covariate'c = `covariate' - r(mean)
	order `covariate'c, after(`covariate')
	local covars2 "`covars2' `covariate'c"
}


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


stset follow_up_years, id(ID) failure(Death)

forvalues model = 1/2 {
	if "`logresults'" ~= "nolog" {
		log using "Results meta-analysis\Log files\Cox_Joint_`variable'_model`model'`sensitivitytext'.log", replace
	}
	stcox `splinevariables' `covars`model'', shared(Studynum)

	if "`logresults'" ~= "nolog" log close
	foreach delta in `deltas' {
		calculate_HRs_and_PIFs `splinevariables', varname("`variable'") study("Joint") /*
			*/ model("`model'") delta("`delta'") firstref("`firstref'") refstep("`refstep'") /*
			*/ lastref("`lastref'") sensitivity("`sensitivity'") dropvars `logresults'
	}	
}

