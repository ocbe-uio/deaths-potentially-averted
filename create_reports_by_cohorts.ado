program create_reports_by_cohorts, rclass
	version 17
	
	syntax, studies(string) variables(string) sensitivity(string)

	if "`variables'" == "all" local variables ""MVPA" "LPA" "SED" "TotalPA""
	else local variables "`variables'"
	
	if "`studies'" == "all" local studies ""ABC" "HAI" "NHANES" "REGARDS" "WHS" "NNPAS" "Tromsø study" "UKBB""
	else local studies "`studies'"

	local sensitivitytext = "_`sensitivity'"
	if "`sensitivity'" == "none" local sensitivitytext = ""

	foreach variable in `variables' {
		local variabletext = "`variable'"
		if "`variable'" == "TotalPA" local variabletext = "Total PA"

		local title "Supplementary materials: `variabletext' in each cohort"
		local logfilename = "Supplementary materials - `variabletext' in each cohort - $S_DATE"'

		if "`sensitivity'" == "Women" {
			local title "Supplementary materials: `variabletext' in each cohort (women only)"
			local logfilename = "Supplementary materials - `variabletext' in each cohort - women only - $S_DATE"
		}
		if "`sensitivity'" == "Men" {
			local title "Supplementary materials: `variabletext' in each cohort (men only)"
			local logfilename = "Supplementary materials - `variabletext' in each cohort - men only - $S_DATE"
		}
		if "`sensitivity'" == "AgeAbove60" {
			local title "Supplementary materials: `variabletext' in each cohort (age above 60 only)"
			local logfilename = "Supplementary materials - `variabletext' in each cohort - age above 60 only - $S_DATE"
		}
		if "`sensitivity'" == "AgeBelow60" {
			local title "Supplementary materials: `variabletext' in each cohort (age below 60 only)"
			local logfilename = "Supplementary materials - `variabletext' in each cohort - age below 60 only - $S_DATE"
		}
		if "`sensitivity'" == "NoAdjForBMI" {
			local title "Supplementary materials: `variabletext' in each cohort (without adj. for BMI)"
			local logfilename = "Supplementary materials - `variabletext' in each cohort - no adj. for BMI - $S_DATE"
		}
		if "`sensitivity'" == "NoMobilityProblems" {
			local title "Supplementary materials: `variabletext' in each cohort (excluding mobility problems)"
			local logfilename = "Supplementary materials - `variabletext' in each cohort - without mobility problems - $S_DATE"
		}
		if "`sensitivity'" == "ExcludeChronicDiseases" {
			local title "Supplementary materials: `variabletext' in each cohort (excluding chronic diseases)"
			local logfilename = "Supplementary materials - `variabletext' in each cohort - excluding chronic diseases - $S_DATE"
		}

		disp _newline "Working on `title'..." _newline

		putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
			*/ margin(left, 2.5cm) margin(right, 2.5cm) margin(top, 2.0cm) margin(bottom, 2.0cm)
		putdocx paragraph, toheader(header) halign(center) font(, 11)
		putdocx text ("`title'")
		putdocx paragraph, tofooter(footer) halign(center) font(, 11)
		putdocx pagenumber
		putdocx paragraph


		if "`variable'" == "MVPA" local deltas = "5 10"
		if "`variable'" == "LPA" local deltas = "30 60"
		if "`variable'" == "SED" local deltas = "-30 -60"
		if "`variable'" == "TotalPA" local deltas = "30 60"
		if "`variable'" == "BMI" local deltas = "-1 -2 -5"
				
		foreach study in `studies' {
			if "`sensitivity'" == "Men" & "`study'" == "WHS" continue
			if "`sensitivity'" == "AgeBelow60" & "`study'" == "HAI" continue	/* Minimum age in HAI: 69 years */
			if "`sensitivity'" == "AgeBelow60" & "`study'" == "WHS" continue	/* Minimum age in WHS: 62 years */
			
			if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "ABC" continue
			if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "HAI" continue
			if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "REGARDS" continue
			if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "WHS" continue
			if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "NNPAS" continue

			foreach delta in `deltas' {
				forvalues model = 1/2 {
					local filename = "Results_`study'_`variable'_model`model'_delta`delta'min`sensitivitytext'"
					putdocx image "Figures\\`filename'_HR.tif", width(15.5cm) linebreak linebreak
					putdocx image "Figures\\`filename'_PIF.tif", width(15.5cm) linebreak
				}
			}
		}
		putdocx save "Reports\\`logfilename'.docx", replace
	}

end

