program calculate_HRs_and_PIFs, rclass
	version 17
	
	syntax varlist, varname(string) study(string) model(string) delta(string) firstref(string) refstep(string) /*
		*/ lastref(string) sensitivity(string) [dropvars nolog]
	
	gen Included = e(sample)
	local N = e(N)
	
	/* If this is a sensitivity analysis, add it to the end of the log filename */
	if "`sensitivity'" == "none" local sensitivitytext = ""
	else local sensitivitytext = "_`sensitivity'"

	/* The number of comparisons for HR and PIF calculations */
	local numrefs = 1 + (`lastref' - `firstref')/`refstep'
	
	quietly gen Refvalue = .
	quietly gen Comparison = .
	quietly gen HR = .
	quietly gen L = .
	quietly gen U = .

	quietly gen Start = .
	quietly gen End = .
	quietly gen Numobs = .
	quietly gen Studysize = .
	quietly gen Proportion = .
	quietly gen PIF = .
	quietly gen PIF_L = .
	quietly gen PIF_U = .
	order Refvalue Comparison HR L U Start End Numobs Studysize Proportion PIF PIF_L PIF_U

	local PIFsum = 1
	local PIF_Lsum = 1
	local PIF_Usum = 1
	local PIFsumstart = `firstref'
	local PIFsumend = `lastref'
	local PIFsumprop = 0
	local PIFsumstop = 0
	local atleastonePIFadded = 0
	local PIFsumAll = 1
	local PIF_LsumAll = 1
	local PIF_UsumAll = 1
	local PIFsumpropAll = 0
	local PIFsumPAmaxAll = 0
	local PIFsumHighRisk = 1
	local PIF_LsumHighRisk = 1
	local PIF_UsumHighRisk = 1
	local PIFsumpropHighRisk = 0
	local PIFsumPAmaxHighRisk = 0
	
	
	/* Need a copy of the original variable for later counting of observations within ranges og values */
	/* The original variable may be changed so that actual observations are available for the xblc command */
	gen `varname'_original = `varname'
	
	forvalues i = 1/`numrefs' {
		local refvalue = `firstref' + (`i'-1)*`refstep'
		local comparison = `refvalue' + `delta'	
		
		quietly replace Refvalue = `refvalue' if _n == `i'
		quietly replace Comparison = `comparison' if _n == `i'		

		/* Calculate proportions within ranges of PA values */
		/* Use the unchanged original variable to count the number of observations */
		if `refstep' < 0 {
			local start = `refvalue' + `refstep'/2
			local end = `refvalue' - `refstep'/2
		}
		else {
			local start = `refvalue' - `refstep'/2
			local end = `refvalue' + `refstep'/2
		}		
		quietly count if `varname'_original >= `start' & `varname'_original < `end' & Included == 1
		local n = r(N)
		local prop = `n'/`N'
		quietly replace Start = `start' if _n == `i'
		quietly replace End = `end' if _n == `i'
		quietly replace Numobs = `n' if _n == `i'
		quietly replace Studysize = `N' if _n == `i'
		quietly replace Proportion = `prop' if _n == `i'

	
		/* Make sure that the values given to the "at" and "reference" options in xblc are actual observations */
		quietly count if `varname' == `comparison'
		if r(N) == 0  {
			disp "Did not find `varname' = `comparison' in dataset"
			disp "Replacing with nearby values"
			quietly replace `varname' = `comparison' if abs(`varname' - `comparison') < 0.5*abs(`refstep')
		}
		quietly count if `varname' == `refvalue'
		if r(N) == 0  {
			disp "Did not find `varname' = `refvalue' in dataset"
			disp "Replacing with nearby values"
			quietly replace `varname' = `refvalue' if abs(`varname' - `refvalue') < 0.5*abs(`refstep')
		}
		
		/* Calculate HRs with 95% CIs for different reference values (command by Orsini & Greenland, 2011) */
		capture: xblc `varlist', covname(`varname') at(`comparison') reference(`refvalue') eform generate(tmp1 tmp2 tmp3 tmp4)
		if _rc ~= 0 continue

		/* Fix some uninformative results */
		quietly replace tmp2 = . if tmp2 == 0
		
		quietly replace HR = tmp2[1] if _n == `i'
		quietly replace L = tmp3[1] if _n == `i'
		quietly replace U = tmp4[1] if _n == `i'
		drop tmp*

		
		/* Calculate PIFs with 95% CIs*/
		/* Ref: Mansournia & Altman (2018), who also cite Miettinen (1974) */
		if HR[`i'] >= 1.0 {
			quietly replace PIF = -`prop'*(1 - 1/HR) if _n == `i'

			if L[`i'] >= 1 quietly replace PIF_L = -`prop'*(1 - 1/L) if _n == `i'
			else quietly replace PIF_L = `prop'*(1 - L) if _n == `i'

			if U[`i'] >= 1 quietly replace PIF_U = -`prop'*(1 - 1/U) if _n == `i'
			else quietly replace PIF_U = `prop'*(1 - U) if _n == `i'
		}
		else if HR[`i'] < 1 & HR[`i'] ~= 0 {
			quietly replace PIF = `prop'*(1 - HR) if _n == `i'
			
			if L[`i'] < 1 quietly replace PIF_U = `prop'*(1 - L) if _n == `i'
			else quietly replace PIF_U = -`prop'*(1 - 1/L) if _n == `i'
			
			if U[`i'] < 1 quietly replace PIF_L = `prop'*(1 - U) if _n == `i'
			else quietly replace PIF_L = -`prop'*(1 - 1/U) if _n == `i'
		}

		/* Swap lower and upper PIF confidence bounds if needed */
		if PIF_L[`i'] > PIF_U[`i'] {
			local tmp = PIF_U[`i']
			quietly replace PIF_U = PIF_L[`i'] if _n == `i'
			quietly replace PIF_L = `tmp' if _n == `i'
		}

		/* If no information on PIF: don't calculate cumulative PIF */
		if PIF[`i'] == 0 & PIF_L[`i'] == 0 & PIF_U[`i'] == 0 continue
		if PIF_L[`i'] == . continue
		
		/* Calculate cumulative PIF over all consecutive PIFs with lower 95% CI bound > 0 */
		if PIF_L[`i'] > 0 & `PIFsumstop' == 0 {
			local atleastonePIFadded = 1
			local PIFsum = `PIFsum'*(1 - PIF[`i'])
			local PIF_Lsum = `PIF_Lsum'*(1 - PIF_L[`i'])
			local PIF_Usum = `PIF_Usum'*(1 - PIF_U[`i'])
			local PIFsumprop = `PIFsumprop' + `prop'
			if `PIFsumstart' == `firstref' & `refstep' > 0 local PIFsumstart = `start'
			if `PIFsumstart' == `firstref' & `refstep' < 0 local PIFsumend = `end'
			if `refstep' > 0 local PIFsumend = `end'
			if `refstep' < 0 local PIFsumstart = `start'
		}
		else if `PIFsumstart' ~= `firstref' | `PIFsumend' ~= `lastref' local PIFsumstop = 1

		/* Calculate cumulative PIF for all participants except the 20% most active (population approach) */
		if `PIFsumpropAll' < 0.80 {
			local PIFsumAll = `PIFsumAll'*(1 - PIF[`i'])
			local PIF_LsumAll = `PIF_LsumAll'*(1 - PIF_L[`i'])
			local PIF_UsumAll = `PIF_UsumAll'*(1 - PIF_U[`i'])
			local PIFsumpropAll = `PIFsumpropAll' + `prop'
			if `refstep' > 0 local PIFsumPAmaxAll = `end'
			if `refstep' < 0 local PIFsumPAmaxAll = `start'
		}
		
		/* Calculate cumulative PIF for the 20% least active participants (high-risk approach) */
		if `PIFsumpropHighRisk' < 0.20 {
			local PIFsumHighRisk = `PIFsumHighRisk'*(1 - PIF[`i'])
			local PIF_LsumHighRisk = `PIF_LsumHighRisk'*(1 - PIF_L[`i'])
			local PIF_UsumHighRisk = `PIF_UsumHighRisk'*(1 - PIF_U[`i'])
			local PIFsumpropHighRisk = `PIFsumpropHighRisk' + `prop'
			if `refstep' > 0 local PIFsumPAmaxHighRisk = `end'
			if `refstep' < 0 local PIFsumPAmaxHighRisk = `start'
		}
	}
	
	if `atleastonePIFadded' == 0 {
		local PIFsumstart = 0
		local PIFsumend = 0
	}

	
	/* Number and proportion of participants in the cumulative PIFs */
	local PIFsumN = `PIFsumprop'*`N'
	local PIFsumNAll = `PIFsumpropAll'*`N'
	local PIFsumNHighRisk = `PIFsumpropHighRisk'*`N'

	/* PIF in percent */
	quietly replace PIF = 100*PIF
	quietly replace PIF_L = 100*PIF_L
	quietly replace PIF_U = 100*PIF_U
	local PIFsum = 100*(1 - `PIFsum')
	local PIF_Lsum = 100*(1 - `PIF_Lsum')
	local PIF_Usum = 100*(1 - `PIF_Usum')
	local PIFsumAll = 100*(1 - `PIFsumAll')
	local PIF_LsumAll = 100*(1 - `PIF_LsumAll')
	local PIF_UsumAll = 100*(1 - `PIF_UsumAll')
	local PIFsumHighRisk = 100*(1 - `PIFsumHighRisk')
	local PIF_LsumHighRisk = 100*(1 - `PIF_LsumHighRisk')
	local PIF_UsumHighRisk = 100*(1 - `PIF_UsumHighRisk')

	
	matrix define PIFsum = (`PIFsum' \ `PIF_Lsum' \ `PIF_Usum' \ `PIFsumprop' \ `PIFsumN' \ `PIFsumend')
	matrix define PIFsumAll = (`PIFsumAll' \ `PIF_LsumAll' \ `PIF_UsumAll' \ `PIFsumpropAll' \ `PIFsumNAll' \ `PIFsumPAmaxAll')
	matrix define PIFsumHighRisk = (`PIFsumHighRisk' \ `PIF_LsumHighRisk' \ `PIF_UsumHighRisk' \ `PIFsumpropHighRisk' \ `PIFsumNHighRisk' \ `PIFsumPAmaxHighRisk')
	svmat PIFsum
	svmat PIFsumAll
	svmat PIFsumHighRisk
	rename PIFsum1 PIFsum
	rename PIFsumAll1 PIFsumAll
	rename PIFsumHighRisk1 PIFsumHighRisk

	/* Save options in the excel file */
	matrix define Options = (`numrefs' \ `firstref' \ `refstep' \ `lastref' \ `PIFsumstart' \ `PIFsumend' \ `PIFsumprop')
	svmat Options
	rename Options1 Options

	/* Reset the PA variable, which may have been changed so that actual observations are available for the xblc command */
	quietly replace `varname' = `varname'_original
	
	/* Create excel file to use for plotting the results */
	local filename = "Results individual cohorts\Results_`study'_`varname'_model`model'_delta`delta'min`sensitivitytext'"
	if "`study'" == "Joint" {
		local filename = "Results meta-analysis\Results_`study'_`varname'_model`model'_delta`delta'min`sensitivitytext'"
	}
	if "`log'" ~= "nolog" {
		export excel Refvalue Comparison HR L U Start End Numobs Studysize Proportion /*
				*/ PIF PIF_L PIF_U PIFsum PIFsumAll PIFsumHighRisk Options /*
				*/ using "`filename'.xls" in 1/`numrefs', firstrow(variables) keepcellfmt replace
	}
	if "`dropvars'" == "dropvars" {
		drop Included Refvalue Comparison HR L U Start End Numobs Studysize Proportion /*
			*/ PIF PIF_L PIF_U PIFsum PIFsumAll PIFsumHighRisk Options `varname'_original
	}

end


