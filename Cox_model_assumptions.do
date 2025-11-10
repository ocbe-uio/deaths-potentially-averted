cd "[...]\Deaths Potentially Averted"

local studies ""ABC" "HAI" "NHANES" "REGARDS" "WHS" "NNPAS" "Tromsø study" "UKBB""
local variables ""MVPA" "LPA" "SED" "TotalPA""

local sensitivity = "none"
local putdocx = 1


if `putdocx' == 1 {
	putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
		*/ margin(left, 1.5cm) margin(right, 1.5cm) margin(top, 2.0cm) margin(bottom, 2.0cm)
	putdocx paragraph, toheader(header) halign(center) font(, 11)
	putdocx text ("Model assumptions and model checking")
	putdocx paragraph, tofooter(footer) halign(center) font(, 11)
	putdocx pagenumber
}

local covariates1 ""Age" "Gender" "Weartime""
local covariates2 ""Age" "Gender" "Weartime" "BMI" "Smoke" "Education" "CVD" "Cancer" "Diabetes""


foreach study in `studies' {

	/* Cox-Snell and Schoenfeld residuals are not available after survey estimation with svy */
	if "`study'" == "NHANES" {
		if `putdocx' == 1 {
			putdocx paragraph, halign(center) font(, 12)
			putdocx text ("NHANES uses complex survey design estimation, for which post estimation"), bold linebreak
			putdocx text ("of residuals for assumption and model checking is not available."), bold
		}
		continue
	}

	use "Analysis files\\`study'.dta", clear

	drop if INCLUDE == 0

	/* stset the data */
	if "`study'" == "NHANES" {
		/* INCORPORATING DESIGN AND WEIGHT */
		/* ALWAYS USE svy: TO GET U.S. REPRESENTATIVE ESTIMATES */
		svyset [w=mec4yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
		stset follow_up_years [pweight=mec4yr], id(ID) failure(Death) 
	}
	else stset follow_up_years, id(ID) failure(Death)	

	/* Make sure each of the covariates is centered on the sample mean */
	/* (This is needed for the adjustments to work in the "xblc" command used in calculate_HRs_and_PIFs.ado) */
	local covars1 "Agec Genderc Weartimec"
	if "`sensitivity'" == "Men" | "`sensitivity'" == "Women" local covars1 "Agec Weartimec"
	local covars2 ""
	foreach covariate in `covariates2' {
		quietly sum `covariate'
		quietly gen `covariate'c = `covariate' - r(mean)
		order `covariate'c, after(`covariate')
		if "`study'" ~= "REGARDS" | "`covariate'" ~= "Cancer" local covars2 "`covars2' `covariate'c"
	}

	
	foreach variable in `variables' {
		
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
	
		forvalues model = 1/2 {
			local filename = "Cox_Snell_`study'_`variable'_model`model'"
			
			/* Fit Cox model */
			if "`study'" == "NHANES" svy: stcox `splinevariables' `covars`model''
			else stcox `splinevariables' `covars`model''
			local N = e(N)
			
			/* --------------------------- */
			/* Model and assumption checks */
			/* --------------------------- */

			/* Test of the proportional hazard assumption using Schoenfeld residuals */			
			estat phtest
			if r(p) >= 0.1 local P: disp %4.2f r(p)
			else if r(p) >= 0.01 local P: disp %5.3f r(p)
			else if r(p) >= 0.001 local P: disp %6.4f r(p)
			else local P = "< 0.001"
			
			
			/* Assess overall goodness-of-fit with Cox-Snell residuals */			
			estat gofplot
			graph export "Figures\\`filename'.tif", as(tif) replace
			
			
			/* Report results */
			if `putdocx' == 1 {
				putdocx paragraph
				
				putdocx table table = (1,2), width(100%) width((40, 60)) border(all, nil)

				putdocx table table(1,1) = ("Study: "), valign(center) bold
				putdocx table table(1,1) = ("`study'"), append linebreak

				putdocx table table(1,1) = ("Variable: "), append bold
				putdocx table table(1,1) = ("`variable'"), append linebreak
				
				
				if `model' == 1 local modeltext = "Adjusted for age and sex"
				if `model' == 2 local modeltext = "Fully adjusted"
				putdocx table table(1,1) = ("Model: "), append bold
				putdocx table table(1,1) = ("`modeltext'"), append linebreak

				
				putdocx table table(1,1) = ("Test of proportional hazard assumption"), append bold linebreak
				putdocx table table(1,1) = ("based on Schoenfeld residuals: "), append bold
				putdocx table table(1,1) = ("P = `P'"), append linebreak
				
				putdocx table table(1,1) = ("(Number of observations: `N')"), append

				putdocx table table(1,2) = image("Figures\\`filename'.tif"), width(10cm)
									
			}
		}	
	}
}

if `putdocx' == 1 putdocx save "Reports\Model assumptions and model checking - $S_DATE.docx", replace



