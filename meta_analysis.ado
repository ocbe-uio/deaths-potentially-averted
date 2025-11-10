program meta_analysis, rclass
	version 17
	
	syntax, variables(string) sensitivity(string) includeUKBB(string)

	if "`variables'" == "all" local variables ""MVPA" "LPA" "SED" "TotalPA""
	else local variables "`variables'"

	local models = "1 2"
	local logresults = 1
	local savefigures = 1	/* Only used by the active vs inactive sensitivity analysis */

	
	if "`sensitivity'" == "none" local sensitivitytext = ""
	else local sensitivitytext = "_`sensitivity'"

	foreach variable in `variables' {

		/* =============================================================================================== */
		/* If we're doing the active vs inactive sensitivity analysis, we don't need to do the whole thing */
		/* =============================================================================================== */
		if "`sensitivity'" == "ActiveInactive" {
			foreach model in `models' {
				local filename = "For_MA_`variable'_model`model'_ActiveInactive"
				if "`includeUKBB'" == "yes" local filename = "`filename'_includingUKBB"
				local logfilename = "MA_`variable'_model`model'_ActiveInactive"
				if "`includeUKBB'" == "yes" local logfilename = "`logfilename'_includingUKBB"

				import excel "Excel files for meta-analysis\\`filename'.xls", sheet("Sheet1") firstrow clear

				quietly gen logHR = log(HR)
				quietly gen logL = log(L)
				quietly gen logU = log(U)
				meta set logHR logL logU, studylabel(Study)

				/* Do the meta-analysis */
				if `logresults' == 1 log using "Results meta-analysis\Log files\\`logfilename'.log", replace
				capture noisily meta summarize, random(reml) eform(HR)
				
				if _rc ~= 0 disp "COULD NOT DO META-ANALYSIS"
				if _rc == 0 {
					local HR = exp(r(theta))
					local L = exp(r(ci_lb))
					local U = exp(r(ci_ub))
					local I2: disp %4.2f r(I2)
				}
				
				/* Calculate PIFs based on combined proportion of observations across studies */
				/* Ref: Mansournia & Altman (2018), who also cite Miettinen (1974) */
				quietly egen SumNumobs = total(Numobs)
				local sumobs = r(sum)
				quietly egen SumStudysize = total(Studysize)
				local sumsize = r(sum)
				local prop = `sumobs'/`sumsize'
				
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
				disp "Number of inactive: `sumobs'"
				local percent: disp %4.1f 100*`prop'
				disp "Percent inactive: `percent'%"
				disp "Total number of participants: `sumsize'"
				disp "PIF (95% CI): `PIF' (`PIF_L' to `PIF_U')" _newline
				
				if `logresults' == 1 log close
				
				/* Create forest plot */
				meta forestplot, random(reml) eform(HR) cibind(parentheses) xlabel(0.5 1 2.0) /*
					*/ noohomtest noosigtest nonotes ohetstatstext("Heterogeneity: I{sup:2} = `I2'%")
				if `savefigures' == 1 graph export "Figures\Results_`logfilename'.tif", as(tif) replace
				
				/* Save results to excel file */
				if `logresults' == 1 {
					gen TMP_HR = `HR'
					gen TMP_L = `L'
					gen TMP_U = `U'
					gen TMP_n = `sumobs'
					gen TMP_N = `sumsize'
					gen TMP_prop = `prop'
					gen TMP_PIF = `PIF'
					gen TMP_PIF_L = `PIF_L'
					gen TMP_PIF_U = `PIF_U'
					export excel TMP_HR TMP_L TMP_U TMP_n TMP_N TMP_prop TMP_PIF TMP_PIF_L TMP_PIF_U /*
						*/ in 1 using "Results meta-analysis\Results_`logfilename'.xls", firstrow(variables) keepcellfmt replace
					drop TMP*
				}
			}
			
		exit

		}
	

		/* ============================================================================= */
		/* All analyses except the active vs inactive sensitivity analysis continue here */
		/* ============================================================================= */
	
		if "`variable'" == "MVPA" local deltas = "5 10"
		if "`variable'" == "LPA" local deltas = "30 60"
		if "`variable'" == "SED" local deltas = "-30 -60"
		if "`variable'" == "TotalPA" local deltas = "30 60"
		
		foreach delta in `deltas' {
			foreach model in `models' {
				local filename = "For_MA_`variable'_model`model'_delta`delta'min`sensitivitytext'"
				if "`includeUKBB'" == "yes" & "`sensitivity'" ~= "Scandinavia" & "`sensitivity'" ~= "USA" {
					local filename = "`filename'_includingUKBB"
				}
				import excel "Excel files for meta-analysis\\`filename'.xls", sheet("Sheet1") firstrow clear

				/* Get options */
				local numrefs = Options[1]
				local firstref = Options[2]
				local refstep = Options[3]
				local lastref = Options[4]

				quietly gen logHR = log(HR)
				quietly gen logL = log(L)
				quietly gen logU = log(U)

				matrix Refvalue = J(`numrefs', 1, .)
				matrix HR = J(`numrefs', 1, .)
				matrix L = J(`numrefs', 1, .)
				matrix U = J(`numrefs', 1, .)
				matrix Numstudies = J(`numrefs', 1, .)
				matrix I2 = J(`numrefs', 1, .)
				matrix Numobs = J(`numrefs', 1, .)
				matrix Totalsize = J(`numrefs', 1, .)
				matrix Proportion = J(`numrefs', 1, .)
				matrix PIF = J(`numrefs', 1, .)
				matrix PIF_L = J(`numrefs', 1, .)
				matrix PIF_U = J(`numrefs', 1, .)

				local PIFsum = 1
				local PIF_Lsum = 1
				local PIF_Usum = 1
				local PIFsumstart = `firstref'
				local PIFsumend = `lastref'
				local PIFsumprop = 0
				local PIFsumstop = 0
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
		

				forvalues refnumber = 1/`numrefs' {
					local refvalue = `firstref' + (`refnumber'-1)*`refstep'
					if `refstep' < 0 {
						local start = `refvalue' + `refstep'/2
						local end = `refvalue' - `refstep'/2
					}
					else {
						local start = `refvalue' - `refstep'/2
						local end = `refvalue' + `refstep'/2
					}
					
					local logfilename = "MA_`variable'_model`model'_delta`delta'min_refvalue`refvalue'`sensitivitytext'"
					if "`includeUKBB'" == "yes" & "`sensitivity'" ~= "Scandinavia" & "`sensitivity'" ~= "USA" {
						local logfilename = "`logfilename'_includingUKBB"
					}
					
					/* Do the meta-analysis */
					meta set logHR logL logU if Refnumber == `refnumber', studylabel(Study)
					if `logresults' == 1 log using "Results meta-analysis\Log files\\`logfilename'.log", replace
					capture noisily meta summarize if Refnumber == `refnumber', random(reml) eform(HR)

					if _rc ~= 0 disp "COULD NOT DO META-ANALYSIS"
					if _rc == 0 {
						local HR = exp(r(theta))
						local L = exp(r(ci_lb))
						local U = exp(r(ci_ub))
						local Numstudies = r(N)
						local I2 = r(I2)
					}
					
					if `logresults' == 1 log close

					matrix Refvalue[`refnumber', 1] = `refvalue'
					matrix HR[`refnumber', 1] = `HR'
					matrix L[`refnumber', 1] = `L'
					matrix U[`refnumber', 1] = `U'
					matrix Numstudies[`refnumber', 1] = `Numstudies'
					matrix I2[`refnumber', 1] = `I2'
					
					/* Calculate PIFs based on combined proportion of observations across studies */
					/* Ref: Mansournia & Altman (2018), who also cite Miettinen (1974) */
					quietly egen SumNumobs`refnumber' = total(Numobs) if Refnumber == `refnumber'
					local sumobs = r(sum)
					quietly egen SumStudysize`refnumber' = total(Studysize) if Refnumber == `refnumber'
					local sumsize = r(sum)
					local prop = `sumobs'/`sumsize'
					
					matrix Numobs[`refnumber', 1] = `sumobs'
					matrix Totalsize[`refnumber', 1] = `sumsize'
					matrix Proportion[`refnumber', 1] = `prop'										
					
					if `HR' >= 1.0 {
						matrix PIF[`refnumber', 1] = -`prop'*(1 - 1/`HR')
						matrix PIF_L[`refnumber', 1] = -`prop'*(1 - 1/`L')
						matrix PIF_U[`refnumber', 1] = -`prop'*(1 - 1/`U')
					}
					else if `HR' ~= 0 {
						matrix PIF[`refnumber', 1] = `prop'*(1 - `HR')
						matrix PIF_L[`refnumber', 1] = `prop'*(1 - `U')
						matrix PIF_U[`refnumber', 1] = `prop'*(1 - `L')
					}
					

					/* If no information on PIF: don't calculate cumulative PIF */
					if PIF[`refnumber', 1] == 0 & PIF_L[`refnumber', 1] == 0 & PIF_U[`refnumber', 1] == 0 continue
					if PIF_L[`refnumber', 1] == . continue

					/* Calculate cumulative PIF over all consecutive PIFs with lower 95% CI bound > 0 */
					if PIF_L[`refnumber', 1] > 0 & `PIFsumstop' == 0 {
						local PIFsum = `PIFsum'*(1 - PIF[`refnumber', 1])
						local PIF_Lsum = `PIF_Lsum'*(1 - PIF_L[`refnumber', 1])
						local PIF_Usum = `PIF_Usum'*(1 - PIF_U[`refnumber', 1])
						local PIFsumprop = `PIFsumprop' + `prop'
						if `PIFsumstart' == `firstref' & `refstep' > 0 local PIFsumstart = `start'
						if `PIFsumstart' == `firstref' & `refstep' < 0 local PIFsumend = `end'
						if `refstep' > 0 local PIFsumend = `end'
						if `refstep' < 0 local PIFsumstart = `start'
					}
					else if `PIFsumstart' ~= `firstref' | `PIFsumend' ~= `lastref' local PIFsumstop = 1
					
					/* Calculate cumulative PIF for all participants except the 20% most active (population approach) */
					if `PIFsumpropAll' < 0.80 {
						local PIFsumAll = `PIFsumAll'*(1 - PIF[`refnumber', 1])
						local PIF_LsumAll = `PIF_LsumAll'*(1 - PIF_L[`refnumber', 1])
						local PIF_UsumAll = `PIF_UsumAll'*(1 - PIF_U[`refnumber', 1])
						local PIFsumpropAll = `PIFsumpropAll' + `prop'
						if `refstep' > 0 local PIFsumPAmaxAll = `end'
						if `refstep' < 0 local PIFsumPAmaxAll = `start'
					}
					
					/* Calculate cumulative PIF for the 20% least active participants (high-risk approach) */
					if `PIFsumpropHighRisk' < 0.20 {
						local PIFsumHighRisk = `PIFsumHighRisk'*(1 - PIF[`refnumber', 1])
						local PIF_LsumHighRisk = `PIF_LsumHighRisk'*(1 - PIF_L[`refnumber', 1])
						local PIF_UsumHighRisk = `PIF_UsumHighRisk'*(1 - PIF_U[`refnumber', 1])
						local PIFsumpropHighRisk = `PIFsumpropHighRisk' + `prop'
						if `refstep' > 0 local PIFsumPAmaxHighRisk = `end'
						if `refstep' < 0 local PIFsumPAmaxHighRisk = `start'
					}

				}
				
				/* Number and proportion of participants in the cumulative PIFs */
				local PIFsumN = `PIFsumprop'*`sumsize'
				local PIFsumNAll = `PIFsumpropAll'*`sumsize'
				local PIFsumNHighRisk = `PIFsumpropHighRisk'*`sumsize'
				
				/* PIF in percent */
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
				matrix define Options = (`numrefs' \ `firstref' \ `refstep' \ `lastref' \ `PIFsumstart' \ `PIFsumend' \ `PIFsumprop')

				/* Create data set with meta-analysis results */
				clear
				svmat Refvalue
				svmat HR
				svmat L
				svmat U
				svmat Numstudies
				svmat I2
				svmat Numobs
				svmat Totalsize
				svmat Proportion
				svmat PIF
				svmat PIF_L
				svmat PIF_U
				svmat PIFsum
				svmat PIFsumAll
				svmat PIFsumHighRisk
				svmat Options

				rename Refvalue1 Refvalue
				rename HR1 HR
				rename L1 L
				rename U1 U
				rename Numstudies1 Numstudies
				rename I21 I2
				rename Numobs1 Numobs
				rename Totalsize1 Totalsize
				rename Proportion1 Proportion
				rename PIF1 PIF
				rename PIF_L1 PIF_L
				rename PIF_U1 PIF_U
				rename PIFsum1 PIFsum
				rename PIFsumAll1 PIFsumAll
				rename PIFsumHighRisk1 PIFsumHighRisk
				rename Options1 Options

				/* PIF in percent also for each of the Refvalues */
				quietly replace PIF = 100*PIF
				quietly replace PIF_L = 100*PIF_L
				quietly replace PIF_U = 100*PIF_U

				local filename = "Results_MA_`variable'_model`model'_delta`delta'min`sensitivitytext'"
				if "`includeUKBB'" == "yes" & "`sensitivity'" ~= "Scandinavia" & "`sensitivity'" ~= "USA" {
					local filename = "`filename'_includingUKBB"
				}
				if `logresults' == 1 export excel "Results meta-analysis\\`filename'.xls", firstrow(variables) keepcellfmt replace
			}
		}
	}

end
	



