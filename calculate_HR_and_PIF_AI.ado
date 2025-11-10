program calculate_HR_and_PIF_AI, rclass
	version 17
	
	syntax varlist, covariates(string) study(string) model(string)
	
	local logresults = "log"
		
	if "`logresults'" ~= "nolog" {
		log using "Results individual cohorts\Log files\Cox_`study'_`varlist'_model`model'_ActiveInactive.log", replace
	}
	
	/* Do the Cox regression */
	if "`study'" == "NHANES" svy: stcox ib0.`varlist'_active `covariates'
	else stcox ib0.`varlist'_active `covariates'

	/* Harvest the estimation results for the PA variable */
	local HR = r(table)[1,2]
	local L = r(table)[5,2]
	local U = r(table)[6,2]	

	/* Find the proportion of inactive participants */
	quietly count if `varlist'_active == 0
	local n = r(N)
	quietly count if `varlist'_active ~= .
	local N = r(N)
	local prop = `n'/`N'

	/* Calculate PIFs with 95% CIs*/
	/* Ref: Mansournia & Altman (2018), who also cite Miettinen (1974) */
	if `HR' >= 1.0 {
		local PIF = -`prop'*(1 - 1/`HR')
		if `L' >= 1 local PIF_L = -`prop'*(1 - 1/`L')
		else local PIF_L = `prop'*(1 - `L')
		if `U'>= 1 local PIF_U = -`prop'*(1 - 1/`U')
		else local PIF_U = `prop'*(1 - `U')
	}
	else if `HR' < 1 & `HR' ~= 0 {
		local PIF = `prop'*(1 - `HR')
		if `L' < 1 local PIF_U = `prop'*(1 - `L')
		else local PIF_U = -`prop'*(1 - 1/`L')
		if `U' < 1 local PIF_L = `prop'*(1 - `U')
		else local PIF_L = -`prop'*(1 - 1/`U')
	}

	/* Print the results */
	disp _newline "HR (95% CI) = `HR' (`L' to `U')"
	disp "Number of inactive: `n'"
	local percent: disp %4.1f 100*`prop'
	disp "Percent inactive: `percent'%"
	disp "Total number of participants: `N'"
	disp "PIF (95% CI): `PIF'(`PIF_L' to `PIF_U')" _newline
	
	if "`logresults'" ~= "nolog" log close

	/* Put results in variables */
	gen TMP_HR = `HR'
	gen TMP_L = `L'
	gen TMP_U = `U'
	gen TMP_n = `n'
	gen TMP_N = `N'
	gen TMP_prop = `prop'
	gen TMP_PIF = `PIF'
	gen TMP_PIF_L = `PIF_L'
	gen TMP_PIF_U = `PIF_U'
	
	/* Create excel file with results */
	local filename = "Results individual cohorts\Results_`study'_`varlist'_model`model'_ActiveInactive"
	if "`logresults'" ~= "nolog" {
		export excel TMP_HR TMP_L TMP_U TMP_n TMP_N TMP_prop TMP_PIF TMP_PIF_L TMP_PIF_U /*
			*/ in 1 using "`filename'.xls", firstrow(variables) keepcellfmt replace
	}
	
	drop TMP*
		
end



