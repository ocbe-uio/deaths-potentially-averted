program create_report_MA_sensitivity, rclass
	version 17
	
	syntax, variables(string) sensitivity(string) includeUKBB(string)

	if "`variables'" == "all" local variables ""MVPA" "LPA" "SED" "TotalPA""
	else local variables "`variables'"

	if "`sensitivity'" == "all" local sensitivityanalyses ""Women" "Men" "AgeAbove60" "AgeBelow60" "NoAdjForBMI" "NoMobilityProblems" "ExcludeChronicDiseases" "Scandinavia" "USA" "Joint" "ActiveInactive""
	else local sensitivityanalyses "`sensitivity'"
	

	local title "Supplementary materials: Results of meta-analysis - sensitivity"
	local logfilename = "Supplementary materials - Results of meta-analysis - Sensitivity - $S_DATE"

	
	putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
		*/ margin(left, 2.5cm) margin(right, 2.5cm) margin(top, 2.0cm) margin(bottom, 2.0cm)
	putdocx paragraph, toheader(header) halign(center) font(, 11)
	putdocx text ("`title'")
	putdocx paragraph, tofooter(footer) halign(center) font(, 11)
	putdocx pagenumber
	putdocx paragraph

	
	foreach sensitivity in `sensitivityanalyses' {
		disp _newline "Working on sensitivity analysis: `sensitivity'..." _newline

		foreach variable in `variables' {

			/* ====================================================================== */
			/* As usual, treat the active vs inactive sensitivity analysis separately */
			/* ====================================================================== */
			if "`sensitivity'" == "ActiveInactive" {
				forvalues model = 1/2 {
					putdocx paragraph, halign(center) spacing(before, 30pt)
					
					local filename = "MA_`variable'_model`model'_ActiveInactive"
					
					putdocx text ("Inactive -> active"), font(, 14) bold linebreak
					putdocx text ("(Inactive: less than 22 min MVPA/day)"), font(, 12) linebreak(2)
				
					if `model' == 1 putdocx text ("`variable': Adjusted for age and sex"), font(, 14) bold
					if `model' == 2 putdocx text ("`variable': Fully adjusted"), font(, 14) bold
					
					putdocx paragraph, halign(center) spacing(before, 20pt)
					putdocx image "Figures\Results_`filename'.tif", width(15.5cm)
					
					quietly import excel "Results meta-analysis\Results_`filename'.xls", sheet("Sheet1") firstrow clear
					local PIF: disp %4.1f 100*TMP_PIF[1]
					local PIF_L: disp %4.1f 100*TMP_PIF_L[1]
					local PIF_U: disp %4.1f 100*TMP_PIF_U[1]
					local inactive = TMP_n[1]
					local percent: disp %4.1f 100*TMP_prop[1]
					local total = TMP_N[1]
					putdocx paragraph, halign(center) spacing(before, 20pt)
					putdocx text ("PIF (95% CI): `PIF'% (`PIF_L'% to `PIF_U'%)"), font(, 12) bold linebreak
					putdocx text ("Number of inactive participants: `inactive'"), font(, 12) linebreak
					putdocx text ("Percent inactive participants: `percent'%"), font(, 12) linebreak
					putdocx text ("Total number of participants: `total'"), font(, 12) linebreak
					
					local UKBBfilename = "Results_UKBB_`variable'_model`model'_ActiveInactive"
					quietly import excel "Results individual cohorts\\`UKBBfilename'.xls", sheet("Sheet1") firstrow clear
					
					local HR: disp %4.2f TMP_HR[1]
					local L: disp %4.2f TMP_L[1]
					local U: disp %4.2f TMP_U[1]
					local PIF: disp %3.1f 100*TMP_PIF[1]
					local PIF_L: disp %3.1f 100*TMP_PIF_L[1]
					local PIF_U: disp %3.1f 100*TMP_PIF_U[1]
					local inactive = TMP_n[1]
					local percent: disp %4.1f 100*TMP_prop[1]
					local total = TMP_N[1]
					putdocx paragraph, halign(center) spacing(before, 40pt)
					putdocx text ("UKBB"), font(, 14) bold linebreak
					putdocx text ("HR (95% CI): `HR' (`L' to `U')"), font(, 12) bold linebreak
					putdocx text ("PIF (95% CI): `PIF'% (`PIF_L'% to `PIF_U'%)"), font(, 12) bold linebreak
					putdocx text ("Number of inactive participants: `inactive'"), font(, 12) linebreak
					putdocx text ("Percent inactive participants: `percent'%"), font(, 12) linebreak
					putdocx text ("Total number of participants: `total'"), font(, 12) linebreak

					if `model' == 1 putdocx pagebreak
				}
				continue
			}

			
			
			/* ============================================================================= */
			/* All analyses except the active vs inactive sensitivity analysis continue here */
			/* ============================================================================= */
			
			if "`variable'" == "MVPA" local deltas = "5 10"
			if "`variable'" == "LPA" local deltas = "30 60"
			if "`variable'" == "SED" local deltas = "-30 -60"
			if "`variable'" == "TotalPA" local deltas = "30 60"
			foreach delta in `deltas' {
				forvalues model = 1/2 {
					local filename = "Results_MA_`variable'_model`model'_delta`delta'min_`sensitivity'"
					if "`sensitivity'" == "Joint" {
						local filename = "Results_Joint_`variable'_model`model'_delta`delta'min"
					}
					putdocx image "Figures\\`filename'_HR.tif", width(15.5cm) linebreak linebreak
					putdocx image "Figures\\`filename'_PIF.tif", width(15.5cm) linebreak
				}		
			}
		}
	}

	putdocx save "Reports\\`logfilename'.docx", replace

end



