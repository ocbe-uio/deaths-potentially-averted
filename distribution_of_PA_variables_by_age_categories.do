cd "[...]\Deaths Potentially Averted"

local studies ""ABC" "HAI" "NHANES" "REGARDS" "WHS" "NNPAS" "Tromsø study" "UKBB""
local variables ""MVPA" "LPA" "SED" "TotalPA""

local title "Supplementary materials: Distribution of PA variables by age categories"
local logfilename = "Supplementary materials - Distribution of PA variables by age categories - $S_DATE"

local createdocx = 1


if `createdocx' == 1 {
	putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
		*/ margin(left, 2.5cm) margin(right, 2.5cm) margin(top, 2.0cm) margin(bottom, 2.0cm)
	putdocx paragraph, toheader(header) halign(center) font(, 11)
	putdocx text ("`title'")
	putdocx paragraph, tofooter(footer) halign(center) font(, 11)
	putdocx pagenumber	
	putdocx paragraph
}


foreach variable in `variables' {
	disp "Working on: `variable'"

	local studynum = 0
	foreach study in `studies' {
		local studynum = `studynum' + 1
		disp "Study: `study'"
		use "Analysis files\\`study'.dta", clear
		
		quietly count if INCLUDE == 1
		local N = r(N)
		
		/* Create age categories: 40-50, 50-60, 60-70, > 70 */
		quietly gen Agecat = .
		quietly replace Agecat = 1 if Age >= 40 & Age <= 50 & Age ~= . 
		quietly replace Agecat = 2 if Age > 50 & Age <= 60 & Age ~= . 
		quietly replace Agecat = 3 if Age > 60 & Age <= 70 & Age ~= . 
		quietly replace Agecat = 4 if Age > 70 & Age ~= .
		
		forvalues i = 1/4 {
			quietly  sum `variable' if Agecat == `i' & INCLUDE == 1
			if r(mean) < 100 local mean_`studynum'_`variable'_`i': disp %4.1f r(mean)
			if r(mean) >= 100 local mean_`studynum'_`variable'_`i': disp %3.0f r(mean)
			if r(sd) < 100 local std_`studynum'_`variable'_`i': disp %3.1f r(sd)
			if r(sd) >= 100 local std_`studynum'_`variable'_`i': disp %3.0f r(sd)
		}
	}
}


if `createdocx' == 1 {
	foreach variable in `variables' {
		if "`variable'" == "MVPA" local tabletitle = "moderate-to-vigorous intensity physical activity"
		if "`variable'" == "LPA" local tabletitle = "light-intensity physical activity"
		if "`variable'" == "SED" local tabletitle = "sedentary time"
		if "`variable'" == "TotalPA" local tabletitle = "total physical activity"
		
		putdocx paragraph
		putdocx text ("Table of mean (std) of `tabletitle' by age categories")

		putdocx table table = (9,5), width(100%) width((20, 20, 20, 20, 20))
		putdocx table table(1,2) = ("40 ≤ Age ≤ 50"), halign(center) bold
		putdocx table table(1,3) = ("50 < Age ≤ 60"), halign(center) bold
		putdocx table table(1,4) = ("60 < Age ≤ 70"), halign(center) bold
		putdocx table table(1,5) = ("Age > 70"), halign(center) bold

		local row = 1
		local studynum = 0
		foreach study in `studies' {
			local studynum = `studynum' + 1
			local row = `row' + 1
			putdocx table table(`row',1) = ("`study'"), halign(left) bold
			forvalues i = 1/4 {
				local col = `i' + 1
				putdocx table table(`row', `col') = ("`mean_`studynum'_`variable'_`i'' (`std_`studynum'_`variable'_`i'')"), halign(center)
			}
		}	
	}
	
	putdocx save "Reports\\`logfilename'.docx", replace
}


