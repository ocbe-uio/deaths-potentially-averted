program create_meta_analysis_files, rclass
	version 17
	
	syntax, variables(string) sensitivity(string) includeUKBB(string)

	if "`variables'" == "all" local variables ""MVPA" "LPA" "SED" "TotalPA""
	else local variables "`variables'"

	local models = "1 2"

	if "`sensitivity'" == "none" local sensitivitytext = ""
	else local sensitivitytext = "_`sensitivity'"

	foreach variable in `variables' {
		if "`sensitivity'" == "none" local studies ""ABC" "HAI" "NHANES" "WHS" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "Women" local studies ""ABC" "HAI" "NHANES" "WHS" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "Men" local studies ""ABC" "HAI" "NHANES" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "AgeAbove60" local studies ""ABC" "HAI" "NHANES" "WHS" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "AgeBelow60" local studies ""ABC" "NHANES" "NNPAS" "Tromsø study"" /* No participants < 60 in HAI & WHS */
		if "`sensitivity'" == "NoAdjForBMI" local studies ""ABC" "HAI" "NHANES" "WHS" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "NoMobilityProblems" local studies ""ABC" "HAI" "NHANES" "WHS" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "ExcludeChronicDiseases" local studies ""ABC" "HAI" "NHANES" "WHS" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "Scandinavia" local studies ""ABC" "HAI" "NNPAS" "Tromsø study""
		if "`sensitivity'" == "USA"	local studies ""NHANES" "WHS""
		if "`sensitivity'" == "ActiveInactive" local studies ""ABC" "HAI" "NHANES" "WHS" "NNPAS" "Tromsø study""

		/* Only include REGARDS in the meta-analyses with MVPA */
		if "`variable'" == "MVPA" & "`sensitivity'" ~= "Scandinavia" local studies "`studies' REGARDS"

		if "`includeUKBB'" == "yes" & "`sensitivity'" ~= "Scandinavia" & "`sensitivity'" ~= "USA" local studies "`studies' UKBB"

		local numstudies: word count `studies'		
		
		/* =============================================================================================== */
		/* If we're doing the active vs inactive sensitivity analysis, we don't need to do the whole thing */
		/* =============================================================================================== */
		if "`sensitivity'" == "ActiveInactive" {
			foreach model in `models' {
				matrix Studynum = J(`numstudies', 1, .)
				matrix HR = J(`numstudies', 1, .)
				matrix L = J(`numstudies', 1, .)
				matrix U = J(`numstudies', 1, .)
				matrix Numobs = J(`numstudies', 1, .)
				matrix Studysize = J(`numstudies', 1, .)
				matrix Proportion = J(`numstudies', 1, .)
				matrix PIF = J(`numstudies', 1, .)
				matrix PIF_L = J(`numstudies', 1, .)
				matrix PIF_U = J(`numstudies', 1, .)

				local index = 0
				foreach study in `studies' {
					local index = `index' + 1
					local filename = "Results_`study'_`variable'_model`model'_ActiveInactive"
					quietly import excel "Results individual cohorts\\`filename'.xls", sheet("Sheet1") firstrow clear
					matrix Studynum[`index',1] = `index'
					matrix HR[`index',1] = TMP_HR[1]
					matrix L[`index',1] = TMP_L[1]
					matrix U[`index',1] = TMP_U[1]
					matrix Numobs[`index',1] = TMP_n[1]
					matrix Studysize[`index',1] = TMP_N[1]
					matrix Proportion[`index',1] = TMP_prop[1]
					matrix PIF[`index',1] = TMP_PIF[1]
					matrix PIF_L[`index',1] = TMP_PIF_L[1]
					matrix PIF_U[`index',1] = TMP_PIF_U[1]
				}
				quietly {
					svmat Studynum
					svmat HR
					svmat L
					svmat U
					svmat Numobs
					svmat Studysize
					svmat Proportion
					svmat PIF
					svmat PIF_L
					svmat PIF_U
				}
				rename Studynum1 Studynum
				rename HR1 HR
				rename L1 L
				rename U1 U
				rename Numobs1 Numobs
				rename Studysize1 Studysize
				rename Proportion1 Proportion
				rename PIF1 PIF
				rename PIF_L1 PIF_L
				rename PIF_U1 PIF_U
				
				quietly gen Study = ""
				order Study, after(Studynum)
				forvalues s = 1/`numstudies' {
					local studyname: disp "`: word `s' of `studies''"
					quietly replace Study = "`studyname'" if Studynum == `s'
				}
				drop TMP*
				
				local filename = "For_MA_`variable'_model`model'_ActiveInactive"
				if "`includeUKBB'" == "yes" local filename = "`filename'_includingUKBB"
				export excel "Excel files for meta-analysis\\`filename'.xls", firstrow(variables) keepcellfmt replace			
			}			
			exit
		}
		

		/* ============================================================================= */
		/* All analyses except the active vs inactive sensitivity analysis continue here */
		/* ============================================================================= */
		
		if "`variable'" == "MVPA" {
			local deltas = "5 10"
			local numrefs = 25
		}
		if "`variable'" == "LPA" {
			local deltas = "30 60"
			local numrefs = 28
		}
		if "`variable'" == "SED" {
			local deltas = "-30 -60"
			local numrefs = 23
		}
		if "`variable'" == "TotalPA" {
			local deltas = "30 60"
			local numrefs = 27
		}
		
		foreach delta in `deltas' {
			foreach model in `models' {
				local numrows = `numstudies'*`numrefs'
				matrix Refnumber = J(`numrows', 1, .)
				matrix Refvalue = J(`numrows', 1, .)
				matrix Comparison = J(`numrows', 1, .)
				matrix Studynum = J(`numrows', 1, .)
				matrix HR = J(`numrows', 1, .)
				matrix L = J(`numrows', 1, .)
				matrix U = J(`numrows', 1, .)
				matrix Numobs = J(`numrows', 1, .)
				matrix Studysize = J(`numrows', 1, .)
				matrix Proportion = J(`numrows', 1, .)
				matrix PIF = J(`numrows', 1, .)
				matrix PIF_L = J(`numrows', 1, .)
				matrix PIF_U = J(`numrows', 1, .)
				
				local s = 0
				foreach study in `studies' {
					local s = `s' + 1
					
					if "`sensitivity'" == "Scandinavia" | "`sensitivity'" == "USA" {
						local filename = "Results_`study'_`variable'_model`model'_delta`delta'min"
					}
					/* We only have information in mobility limitations from NHANES, Tromsø, and UKBB */
					else if "`sensitivity'" == "NoMobilityProblems" & ("`study'" == "ABC" | "`study'" == "HAI" | /*
							*/ "`study'" == "REGARDS" |  "`study'" == "WHS" | "`study'" == "NNPAS") {
						local filename = "Results_`study'_`variable'_model`model'_delta`delta'min"
					}
					else {
						local filename = "Results_`study'_`variable'_model`model'_delta`delta'min`sensitivitytext'"
					}
					quietly import excel "Results individual cohorts\\`filename'.xls", sheet("Sheet1") firstrow clear

					/* Get options */
					local firstref = Options[2]
					local refstep = Options[3]
					local lastref = Options[4]
					local PIFsumstart = Options[5]
					local PIFsumend = Options[6]
					
					matrix define Options = (`numrefs' \ `firstref' \ `refstep' \ `lastref' \ `PIFsumstart' \ `PIFsumend')
					
					forvalues k = 1/`numrefs' {
						local index = (`k'-1)*`numstudies' + `s'
						matrix Refnumber[`index',1] = `k'
						matrix Refvalue[`index',1] = Refvalue[`k']
						matrix Comparison[`index',1] = Comparison[`k']
						matrix Studynum[`index',1] = `s'
						matrix HR[`index',1] = HR[`k']
						matrix L[`index',1] = L[`k']
						matrix U[`index',1] = U[`k']
						matrix Numobs[`index',1] = Numobs[`k']
						matrix Studysize[`index',1] = Studysize[`k']
						matrix Proportion[`index',1] = Proportion[`k']
						matrix PIF[`index',1] = PIF[`k']
						matrix PIF_L[`index',1] = PIF_L[`k']
						matrix PIF_U[`index',1] = PIF_U[`k']
					}			
				}
				
				clear
				quietly {
					svmat Refnumber
					svmat Refvalue
					svmat Comparison
					svmat Studynum
					svmat HR
					svmat L
					svmat U
					svmat Numobs
					svmat Studysize
					svmat Proportion
					svmat PIF
					svmat PIF_L
					svmat PIF_U
					svmat Options
				}
				
				rename Refnumber1 Refnumber
				rename Refvalue1 Refvalue
				rename Comparison1 Comparison
				rename Studynum1 Studynum
				rename HR1 HR
				rename L1 L
				rename U1 U
				rename Numobs1 Numobs
				rename Studysize1 Studysize
				rename Proportion1 Proportion
				rename PIF1 PIF
				rename PIF_L1 PIF_L
				rename PIF_U1 PIF_U
				rename Options1 Options
				
				quietly gen Study = ""
				order Study, after(Studynum)
				forvalues s = 1/`numstudies' {
					local studyname: disp "`: word `s' of `studies''"
					quietly replace Study = "`studyname'" if Studynum == `s'
				}
				
				local filename = "For_MA_`variable'_model`model'_delta`delta'min`sensitivitytext'"
				if "`includeUKBB'" == "yes" & "`sensitivity'" ~= "Scandinavia" & "`sensitivity'" ~= "USA" {
					local filename = "`filename'_includingUKBB"
				}
				export excel "Excel files for meta-analysis\\`filename'.xls", firstrow(variables) keepcellfmt replace			
			}
		}
	}

end


