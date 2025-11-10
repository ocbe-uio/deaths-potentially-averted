program create_report_MA, rclass
	version 17
	
	syntax, variables(string) includeUKBB(string)

	if "`variables'" == "all" local variables ""MVPA" "LPA" "SED" "TotalPA""
	else local variables "`variables'"
	
	local title "Supplementary materials: Results of meta-analyses"
	local logfilename = "Supplementary materials - Results of meta-analysis - $S_DATE"

	putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
		*/ margin(left, 2.5cm) margin(right, 2.5cm) margin(top, 2.0cm) margin(bottom, 2.0cm)
	putdocx paragraph, toheader(header) halign(center) font(, 11)
	putdocx text ("`title'")
	putdocx paragraph, tofooter(footer) halign(center) font(, 11)
	putdocx pagenumber
	putdocx paragraph


	foreach variable in `variables' {
		disp _newline "Working on: `variable'..."
		if "`variable'" == "MVPA" local deltas = "5 10"
		if "`variable'" == "LPA" local deltas = "30 60"
		if "`variable'" == "SED" local deltas = "-30 -60"
		if "`variable'" == "TotalPA" local deltas = "30 60"
		if "`variable'" == "BMI" local deltas = "-1 -2 -5"

		foreach delta in `deltas' {
			forvalues model = 1/2 {
				local filename = "Results_MA_`variable'_model`model'_delta`delta'min"
				putdocx image "Figures\\`filename'_HR.tif", width(15.5cm) linebreak linebreak
				putdocx image "Figures\\`filename'_PIF.tif", width(15.5cm) linebreak
			}		
		}
	}

	putdocx save "Reports\\`logfilename'.docx", replace

end

