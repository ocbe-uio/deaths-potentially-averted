cd "[...]\Deaths Potentially Averted"

local logfilename = "Supplementary figures 1-15 - $S_DATE"
local folder = "Figures final supplementary\"
local widthDistribution = "8.4cm"
local heightHRPIF = "6.3cm"


local studies ""ABC" "HAI" "NHANES" "REGARDS" "WHS" "NNPAS" "Tromsø study" "UKBB""

putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
	*/ margin(left, 2.0cm) margin(right, 2.0cm) margin(top, 1.8cm) margin(bottom, 1.8cm)



/* ============================================ */
/* Supplementary Figure 1: Distribution of MVPA */
/* ============================================ */
putdocx paragraph, halign(left) font(, 11)
putdocx text ("Supplementary Figure 1: Distribution of time in moderate to vigorous physical activity (MVPA) per cohort"), bold linebreak(2)
foreach study in `studies' {
	local filename = "`folder'\Distribution_MVPA_`study'"
	putdocx image "`filename'.tif", width("`widthDistribution'")
	if "`study'" == "HAI" | "`study'" == "REGARDS" | "`study'" == "NNPAS" putdocx text (""), linebreak(3)
}



/* =========================================== */
/* Supplementary Figure 2: Distribution of SED */
/* =========================================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 11)
putdocx text ("Supplementary Figure 2: Distribution of sedentary time (SED) per cohort"), bold linebreak(2)
foreach study in `studies' {
	local filename = "`folder'\Distribution_SED_`study'"
	putdocx image "`filename'.tif", width("`widthDistribution'")
	if "`study'" == "HAI" | "`study'" == "REGARDS" | "`study'" == "NNPAS" putdocx text (""), linebreak(3)
}



/* ================================================ */
/* Supplementary Figure 3: Distribution of Total PA */
/* ================================================ */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 11)
putdocx text ("Supplementary Figure 3: Distribution of total time in physical activity (Total PA) per cohort"), bold linebreak(2)
foreach study in `studies' {
	local filename = "`folder'\Distribution_TotalPA_`study'"
	putdocx image "`filename'.tif", width("`widthDistribution'")
	if "`study'" == "HAI" | "`study'" == "REGARDS" | "`study'" == "NNPAS" putdocx text (""), linebreak(3)
}




/* ============================ */
/* Supplementary figure 4: MVPA */
/* ============================ */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 4: Results for moderate to vigorous physical activity (MVPA). Hazard ratios (left panels) for mortality for 5 minutes (panels a and c) and 10 minutes (panels e and g) increase in MVPA from observed level (x-axis). Percentage PIF (right panels) for 5 minutes (panels b and d) and 10 minutes (panels f and h) increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_MA_MVPA_model1_delta5min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model1_delta5min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model1_delta5min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model1_delta5min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model1_delta10min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model1_delta10min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model1_delta10min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model1_delta10min_PIF.tif", height("`heightHRPIF'")



/* =========================== */
/* Supplementary figure 5: LPA */
/* =========================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 5: Results for light physical activity (LPA). Hazard ratios (left panels) for mortality for 30 minutes (panels a and c) and 60 minutes (panels e and g) increase in LPA from observed level (x-axis). Percentage PIF (right panels) for 30 minutes (panels b and d) and 60 minutes (panels f and h) increase in LPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_MA_LPA_model2_delta30min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_LPA_model2_delta30min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_LPA_model2_delta30min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_LPA_model2_delta30min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_LPA_model2_delta60min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_LPA_model2_delta60min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_LPA_model2_delta60min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_LPA_model2_delta60min_PIF.tif", height("`heightHRPIF'")



/* =========================== */
/* Supplementary figure 6: SED */
/* =========================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 6: Results for sedentary time (SED). Hazard ratios (left panels) for mortality for 30 minutes (panels a and c) and 60 minutes (panels e and g) decrease in SED from observed level (x-axis). Percentage PIF (right panels) for 30 minutes (panels b and d) and 60 minutes (panels f and h) decrease in SED from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_MA_SED_model1_delta-30min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_SED_model1_delta-30min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_SED_model1_delta-30min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_SED_model1_delta-30min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_SED_model1_delta-60min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_SED_model1_delta-60min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_SED_model1_delta-60min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_SED_model1_delta-60min_PIF.tif", height("`heightHRPIF'")



/* ================================ */
/* Supplementary figure 7: Total PA */
/* ================================ */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 7: Results for total physical activity (Total PA). Hazard ratios (left panels) for mortality for 30 minutes (panels a and c) and 60 minutes (panels e and g) increase in Total PA from observed level (x-axis). Percentage PIF (right panels) for 30 minutes (panels b and d) and 60 minutes (panels f and h) increase in Total PA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_MA_TotalPA_model2_delta30min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_TotalPA_model2_delta30min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_TotalPA_model2_delta30min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_TotalPA_model2_delta30min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_TotalPA_model2_delta60min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_TotalPA_model2_delta60min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_TotalPA_model2_delta60min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_TotalPA_model2_delta60min_PIF.tif", height("`heightHRPIF'")




/* ================================================================= */
/* Supplementary figure 8: Sensitivity - women, men, age <> 60 years */
/* ================================================================= */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 8: Results of sensitivity analyses for subgroups of women (panels a and b), men (panels c and d), age above 60 years (panels e and f), and age below 60 years (panels g and h). Hazard ratios (left panels) for mortality for 5 minutes increase in MVPA from observed level (x-axis). Percentage PIF (right panels) for 5 minutes increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_women_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_women_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_men_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_men_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_AgeAbove60_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_AgeAbove60_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_AgeBelow60_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_AgeBelow60_PIF.tif", height("`heightHRPIF'")



/* ===================================================================== */
/* Supplementary figure 9: Sensitivity - BMI, Mobility, Scandinavia, USA */
/* ===================================================================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 9: Results of sensitivity analyses of not adjusting for BMI (panels a and b), excluding participants with mobility problems (panels c and d), Scandinavian cohorts only (panels e and f), and US cohorts only (panels g and h). Hazard ratios (left panels) for mortality for 5 minutes increase in MVPA from observed level (x-axis). Percentage PIF (right panels) for 5 minutes increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_NoAdjForBMI_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_NoAdjForBMI_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_NoMobilityProblems_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_NoMobilityProblems_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_Scandinavia_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_Scandinavia_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_USA_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_USA_PIF.tif", height("`heightHRPIF'")



/* =========================================================== */
/* Supplementary figure 10: Sensitivity MA: No chronic disease */
/* =========================================================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 10: Results of sensitivity analyses of excluding participants with chronic diseases. Hazard ratios (left panel) for mortality for 5 minutes increase in MVPA from observed level (x-axis). Percentage PIF (right panel) for 5 minutes increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_ExcludeChronicDiseases_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_MA_MVPA_model2_delta5min_ExcludeChronicDiseases_PIF.tif", height("`heightHRPIF'")



/* ====================================================================== */
/* Supplementary figure 11: Sensitivity UKBB: women, men, age <> 60 years */
/* ====================================================================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 11: Results of sensitivity analyses for subgroups of women (panels a and b), men (panels c and d), age above 60 years (panels e and f), and age below 60 years (panels g and h) in the UKBB study. Hazard ratios (left panels) for mortality for 5 minutes increase in MVPA from observed level (x-axis). Percentage PIF (right panels) for 5 minutes increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_women_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_women_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_men_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_men_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_AgeAbove60_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_AgeAbove60_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_AgeBelow60_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_AgeBelow60_PIF.tif", height("`heightHRPIF'")



/* ============================================================================= */
/* Supplementary figure 12: Sensitivity UKBB: BMI, Mobility, no chronic diseases */
/* ============================================================================= */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 12: Results of sensitivity analyses of not adjusting for BMI (panels a and b), excluding participants with mobility problems (panels c and d), and excluding participants with chronic diseases (panels e and f) in the UKBB study. Hazard ratios (left panels) for mortality for 5 minutes increase in MVPA from observed level (x-axis). Percentage PIF (right panels) for 5 minutes increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_NoAdjForBMI_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_NoAdjForBMI_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_NoMobilityProblems_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_NoMobilityProblems_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_ExcludeChronicDiseases_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_UKBB_MVPA_model2_delta5min_ExcludeChronicDiseases_PIF.tif", height("`heightHRPIF'")



/* =================================================================================== */
/* Supplementary figure 13: Sensitivity Mobility in individual studies: NHANES, Tromsø */
/* =================================================================================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 13: Sensitivity analyses showing results from those studies (NHANES, Tromsø, UKBB) where information on mobility limitations was available. Left panels show the Hazard ratios for 5- and 10 minutes increase in MVPA from observed level (x-axis) and percentage PIF for 5- and 10 minutes increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants including all participants. Right panels show the results following exclusion of participants reporting mobility limitations."), bold linebreak


local firstpage = 1
local tablefontsize = 6
foreach study in "NHANES" "Tromsø study" "UKBB" {
	foreach delta of numlist 5 10 {
		if `firstpage' ~= 1 putdocx pagebreak
		local firstpage = 0

		putdocx paragraph, halign(center) font(, 11)
		putdocx text ("`study'"), bold linebreak
		putdocx text ("`delta' min increase in MVPA"), bold

		putdocx paragraph
		putdocx image "`folder'\Results_`study'_MVPA_model2_delta`delta'min_HR.tif", height("`heightHRPIF'")
		putdocx image "`folder'\Results_`study'_MVPA_model2_delta`delta'min_NoMobilityProblems_HR.tif", height("`heightHRPIF'")
		putdocx image "`folder'\Results_`study'_MVPA_model2_delta`delta'min_PIF.tif",height("`heightHRPIF'")
		putdocx image "`folder'\Results_`study'_MVPA_model2_delta`delta'min_NoMobilityProblems_PIF.tif", height("`heightHRPIF'")


		/* ---------------------------- */
		/* Table with the hazard ratios */
		/* ---------------------------- */
		putdocx paragraph
		putdocx table table = (5,9), width(100%) width((9, 11, 11, 11, 11, 11, 12, 12, 12))
		putdocx table table(1,1) = ("`study'"), font(, `tablefontsize') bold
		putdocx table table(2,1) = ("Including ML"), font(, `tablefontsize') bold
		putdocx table table(3,1) = ("Excluding ML"), font(, `tablefontsize') bold
		putdocx table table(4,1) = ("Values are hazard ratios (95% CI)"), colspan(9) font(, `tablefontsize')
		putdocx table table(5,1) = ("ML = mobility limitations"), colspan(9) font(, `tablefontsize')
		putdocx table table(4,.), border(bottom, nil) border(left, nil) border(right, nil)
		putdocx table table(5,.), border(bottom, nil) border(left, nil) border(right, nil)

		forvalues i = 1/8 {
			local refvalue = 2*`i' - 1
			local comparison = `refvalue' + `delta'
			local col = `i' + 1
			putdocx table table(1,`col') = ("`refvalue' min vs. `comparison' min"), font(, `tablefontsize') bold halign(center)
		}

		forvalues ML = 0/1 {
			local row = `ML' + 2
			if `ML' == 0 import excel "Results individual cohorts\\Results_`study'_MVPA_model2_delta`delta'min.xls", /*
					*/ sheet("Sheet1") firstrow clear
			else if `ML' == 1 import excel "Results individual cohorts\\Results_`study'_MVPA_model2_delta`delta'min_NoMobilityProblems.xls", /*
					*/ sheet("Sheet1") firstrow clear
			forvalues i = 1/8 {
				local col = `i' + 1
				local HR`i': disp %4.2f HR[`i']
				local L`i': disp %4.2f L[`i']
				local U`i': disp %4.2f U[`i']
				putdocx table table(`row', `col') = ("`HR`i'' (`L`i'' to `U`i'')"), font(, `tablefontsize') 
			}
		}

		/* ----------------------------------------- */
		/* Table with the potential impact fractions */
		/* ----------------------------------------- */
		putdocx paragraph
		putdocx table table = (5,9), width(100%) width((9, 11, 11, 11, 11, 11, 12, 12, 12))
		putdocx table table(1,1) = ("`study'"), font(, `tablefontsize') bold
		putdocx table table(2,1) = ("Including ML"), font(, `tablefontsize') bold
		putdocx table table(3,1) = ("Excluding ML"), font(, `tablefontsize') bold
		putdocx table table(4,1) = ("Values are potential impact fractions in percentage (95% CI)"), /*
				*/ colspan(9) font(, `tablefontsize')
		putdocx table table(5,1) = ("ML = mobility limitations"), colspan(9) font(, `tablefontsize')
		putdocx table table(4,.), border(bottom, nil) border(left, nil) border(right, nil)
		putdocx table table(5,.), border(bottom, nil) border(left, nil) border(right, nil)

		forvalues i = 1/8 {
			local refvalue = 2*`i' - 1
			local comparison = `refvalue' + `delta'
			local col = `i' + 1
			putdocx table table(1,`col') = ("`refvalue' min vs. `comparison' min"), font(, `tablefontsize') bold halign(center)
		}

		forvalues ML = 0/1 {
			local row = `ML' + 2
			if `ML' == 0 import excel "Results individual cohorts\\Results_`study'_MVPA_model2_delta`delta'min.xls", /*
					*/ sheet("Sheet1") firstrow clear
			else if `ML' == 1 import excel "Results individual cohorts\\Results_`study'_MVPA_model2_delta`delta'min_NoMobilityProblems.xls", /*
					*/ sheet("Sheet1") firstrow clear
			forvalues i = 1/8 {
				local col = `i' + 1
				local PIF`i': disp %4.2f PIF[`i']
				local PIF_L`i': disp %4.2f PIF_L[`i']
				local PIF_U`i': disp %4.2f PIF_U[`i']
				putdocx table table(`row', `col') = ("`PIF`i'' (`PIF_L`i'' to `PIF_U`i'')"), font(, `tablefontsize') 
			}
		}
	}
}




/* =================================================== */
/* Supplementary figure 14: Sensitivity - one-stage MA */
/* =================================================== */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10)
putdocx text ("Supplementary Figure 14: Results of sensitivity analyses of one-stage meta-analysis. Hazard ratios (panels a and c) for mortality for 5 minutes and 10 minutes increase in MVPA from observed level (x-axis). Percentage PIF (panels b and d) for 5 minutes and 10 minutes increase in MVPA from observed level (x-axis), with bar chart showing distribution and percentages of participants."), bold linebreak

putdocx image "`folder'\Results_Joint_MVPA_model2_delta5min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_Joint_MVPA_model2_delta5min_PIF.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_Joint_MVPA_model2_delta10min_HR.tif", height("`heightHRPIF'")
putdocx image "`folder'\Results_Joint_MVPA_model2_delta10min_PIF.tif", height("`heightHRPIF'")




/* ========================================================= */
/* Supplementary figure 15: Sensitivity - Inactive -> active */
/* ========================================================= */
putdocx pagebreak
putdocx paragraph, halign(left) font(, 10) spacing(before, 30pt)
putdocx text ("Supplementary Figure 15: Results of sensitivity analyses comparing active participants vs inactive participants, where inactivity is defined as less than 22 min MVPA/day. Model: Fully adjusted."), bold linebreak

putdocx paragraph, halign(center) spacing(before, 0pt)
putdocx image "Figures\Results_MA_MVPA_model2_ActiveInactive.tif", width(14cm) linebreak

quietly import excel "Results meta-analysis\Results_MA_MVPA_model2_ActiveInactive.xls", sheet("Sheet1") firstrow clear
local PAF: disp %4.1f 100*TMP_PIF[1]
local PAF_L: disp %4.1f 100*TMP_PIF_L[1]
local PAF_U: disp %4.1f 100*TMP_PIF_U[1]
local inactive = TMP_n[1]
local percent: disp %4.1f 100*TMP_prop[1]
local total = TMP_N[1]
putdocx text ("Overall PAF (95% CI): `PAF'% (`PAF_L'% to `PAF_U'%)"), font(, 10) bold linebreak
putdocx text ("Number of inactive participants: `inactive'/`total' (`percent'%)"), font(, 10)



putdocx save "Reports\\`logfilename'.docx", replace


