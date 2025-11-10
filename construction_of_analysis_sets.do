cd "[...]\Deaths Potentially Averted"
discard

local title = "Supplementary materials: Construction of analysis sets"
local logfilename = "Supplementary materials - Construction of analysis sets - $S_DATE"

putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
	*/ margin(left, 2.5cm) margin(right, 2.5cm) margin(top, 2.0cm) margin(bottom, 2.0cm)
putdocx paragraph, toheader(header) halign(center) font(, 11)
putdocx text ("`title'")
putdocx paragraph, tofooter(footer) halign(center) font(, 11)
putdocx pagenumber


local description = "Table showing the evolution of the analysis set for each cohort"
putdocx paragraph, spacing(before, 15pt)
putdocx text ("`description'"), font(, 11) bold


local total_sample_size = 0
local total_sample_size_without_UKBB = 0
local total_number_deaths = 0
local total_number_deaths_no_UKBB = 0

forvalues t = 1/2 {
	if `t' == 1 {
		putdocx table table1 = (17,5), width(100%) title(" ", bold)
		local studies ""ABC" "HAI" "NHANES" "REGARDS""
	}
	if `t' == 2 {
		putdocx table table2 = (16,5), width(100%) title(" ", bold)
		local studies ""WHS" "NNPAS" "Tromsø study" "UKBB""
	}

	putdocx table table`t'(2,1) = ("Cohort"), halign(left) bold
	putdocx table table`t'(3,1) = ("Participants with valid accelerometer data and age > 40"), halign(left)
	putdocx table table`t'(4,1) = ("Excluding deaths within 2 years follow up"), halign(left)
	putdocx table table`t'(5,1) = ("Sample size including missing data"), halign(left)
	putdocx table table`t'(6,1) = ("Missing data in outcomes/covariates"), halign(left)
	putdocx table table`t'(7,1) = ("   Gender"), halign(left)
	putdocx table table`t'(8,1) = ("   Deaths"), halign(left)
	putdocx table table`t'(9,1) = ("   Follow up time"), halign(left)
	putdocx table table`t'(10,1) = ("   Age"), halign(left)
	putdocx table table`t'(11,1) = ("   BMI"), halign(left)
	putdocx table table`t'(12,1) = ("   Smoking"), halign(left)
	putdocx table table`t'(13,1) = ("   Education"), halign(left)
	putdocx table table`t'(14,1) = ("   History of CVD"), halign(left)
	putdocx table table`t'(15,1) = ("   History of cancer"), halign(left)
	putdocx table table`t'(16,1) = ("   Diabetes"), halign(left)
	putdocx table table`t'(17,1) = ("Sample size analysis set"), halign(left) bold

	putdocx table table`t'(.,1), width(240pt)

	local col = 1
	foreach study in `studies' {
		local col = `col' + 1
		putdocx table table`t'(2,`col') = ("`study'"), halign(center) bold
		
		disp _newline "Loading file: `study'_with_missing.dta"
		use "Analysis files\\`study'_with_missing.dta", clear	

		/* Number of participants with valid accelerometer data & age >= 40 years */
		replace INCLUDE = 0 if Age < 40 & Age ~= .
		quietly count if INCLUDE == 1	
		putdocx table table`t'(3, `col') = (r(N)), halign(center) valign(center)
		
		/* Exclude participants who die during the first two years of follow up */
		replace INCLUDE = 0 if Death == 1 & follow_up_years < 2 & follow_up_years ~= .
		quietly count if Death == 1 & follow_up_years < 2 & follow_up_years ~= .
		putdocx table table`t'(4, `col') = (r(N)), halign(center)
		
		/* Sample size including missing data */
		quietly count if INCLUDE == 1
		local N = r(N)
		putdocx table table`t'(5, `col') = ("`N'"), halign(center)

		/* Missing data in the covariates */
		local vars ""Gender" "Death" "follow_up_years" "Age" "BMI" "Smoke" "Education" "CVD" "Cancer" "Diabetes""
		local row = 6
		foreach var in `vars' {
			local row = `row' + 1
			if "`var'" == "follow_up_years" {
				replace follow_up_years = . if follow_up_years < 0
			}
			if "`var'" ~= "Cancer" | "`study'" ~= "REGARDS" replace INCLUDE = 0 if `var' == .
			quietly count if `var' == .
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`N' "%)"
			if "`var'" == "Cancer" & "`study'" == "REGARDS" local celltext = "`celltext'*"			
			putdocx table table`t'(`row', `col') = ("`celltext'"), halign(center)
		}

		/* Sample size analysis set (also: add to total sample size) */
		quietly count if INCLUDE == 1
		local total_sample_size = `total_sample_size' + r(N)
		if "`study'" ~= "UKBB" local total_sample_size_without_UKBB = `total_sample_size_without_UKBB' + r(N)
		local n_analysis_set: disp r(N) " (" %3.1f 100*r(N)/`N' "%)"
		if "`study'" == "REGARDS" local n_analysis_set = "`n_analysis_set'*"
		putdocx table table`t'(17, `col') = ("`n_analysis_set'"), halign(center) bold
		disp "Saving file: `study'.dta"
		save "Analysis files\\`study'.dta", replace
		
		/* Count and add the number of deaths */
		quietly count if Death == 1 & INCLUDE == 1
		local total_number_deaths = `total_number_deaths' + r(N)
		if "`study'" ~= "UKBB" local total_number_deaths_no_UKBB = `total_number_deaths_no_UKBB' + r(N)
				
	}

}

putdocx table table1(18, 1) = ("*History of cancer is not included as a covariate in the analysis of REGARDS due to high levels of missing data"), halign(left) colspan(5) font(Calibri, 7) border(bottom, nil) border(left, nil) border(right, nil)

putdocx paragraph, spacing(before, 10pt)
putdocx text ("Combined sample size for meta-analysis: `total_sample_size' (`total_number_deaths' deaths)"), bold linebreak
putdocx text ("Combined sample size for meta-analysis without UKBB: `total_sample_size_without_UKBB' (`total_number_deaths_no_UKBB' deaths)"), bold

putdocx save "Reports\\`logfilename'.docx", replace



