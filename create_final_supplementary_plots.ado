program create_final_supplementary_plots, rclass
	version 17
	
	syntax, study(string) variable(string) sensitivity(string) models(string) delta(string) panelHR(string) panelPIF(string)

	local savefigures = 1
	
	/* General options common for all cases */
	local yzize = "9.9cm"
	local xsize = "15.5cm"
	local color = "black"
	local barcolor = "180 230 255"
	local baroutlinecolor = "`barcolor'"
	local barwidth = 0.8
	local graphregionmarginHR = "b-2 l-2"
	local graphregionmarginPIF = "b-2 l-2"
	local ticklabelsize = "11pt"
	local axistitlesize = "15pt"
	local variablename = "`variable'"
	local msize = "4pt"
	if "`study'" == "UKBB" local msize = "2pt"

	if "`sensitivity'" == "none" local sensitivitytext = ""
	else local sensitivitytext = "_`sensitivity'"
	if "`sensitivity'" == "Scandinavia" | "`sensitivity'" == "USA" local sensitivitylabel = "(`sensitivity' only)"
	else local sensitivitylabel = strlower("(`sensitivity' only)")
	if "`sensitivity'" == "AgeAbove60" local sensitivitylabel = "(age {&ge} 60 only)"
	if "`sensitivity'" == "AgeBelow60" local sensitivitylabel = "(age < 60 only)"
	if "`sensitivity'" == "NoAdjForBMI" local sensitivitylabel = "(without adj. for BMI)"
	if "`sensitivity'" == "NoMobilityProblems" local sensitivitylabel = "(no mobility limitations)"
	if "`sensitivity'" == "ExcludeChronicDiseases" local sensitivitylabel = "(no chronic diseases)"
	
	
	/* Theses options are optimzed for the meta-analysis plots */
	local yscaleHR = "0.3 1.5"
	local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5"
	local yscalePIF = "-2 6.3"
	local yticksPIF = "-2(1)6"
	local maxproportionyaxis = 0.4

	local textboxyHR = 0.44
	local textboxyPIF1 = 6.0
	local textboxyPIF2 = 4.0
	local textboxyPIF3 = 2.6
	local textboxHRjustification = "right"
	local textboxHRplacement = "sw"
	local textboxPIFjustification = "right"
	local textboxPIFplacement = "sw"		
	local panelyHR = 2.05
	local panelyPIF = 8.75
	
	
	if "`variable'" == "MVPA" {
		local xscale = "0 50"
		local xticks = "0(5)50"
		local textboxxHR = 50
		local textboxxPIF = 50
		local panelx = 50.6
		if "`study'" == "MA" & "`delta'" == "10" local panelyPIF = 9.15
	}
	if "`variable'" == "LPA" {
		local xscale = "0 420"
		local xticks = "0(30)420"
		local textboxxHR = 420
		local textboxxPIF = 420
		local panelx = 425
	}
	if "`variable'" == "SED" {
		local xscale = "210 900"
		local xticks = "240(60)900"
		local textboxxHR = 900
		local textboxxPIF = 900
		local panelx = 910
		if "`study'" == "MA" & "`delta'" == "-60" & "`models'" == "1" {
			local textboxyPIF1 = 6.3
			local textboxyPIF2 = 4.3
			local textboxyPIF3 = 2.9
		}
		if "`study'" == "UKBB" & "`delta'" == "-60" & "`models'" == "1" {
			local textboxyPIF1 = 6.2
			local textboxyPIF2 = 4.4
			local textboxyPIF3 = 3.1
		}
	}
	if "`variable'" == "TotalPA" {
		local xscale = "60 600"
		local xticks = "60(60)600"
		local textboxxHR = 600
		local textboxxPIF = 600
		local variablename = "Total PA"
		local panelx = 606
	}
	
	local deltaword = abs(`delta')
	foreach model in `models' {
		local unit = "min" 
			
		/* Figure titles */
		if `delta' < 0 local changeword = "decrease"
		else local changeword = "increase"
		
		local titleHR1 = "Hazard ratio for mortality for `deltaword' `unit' `changeword'"
		local titleHR2 = "in `variablename' from observed level (x-axis)"

		local titlePIF1 = "PIF (%) for `deltaword' `unit' `changeword' in `variablename'"
		local titlePIF2 = "from observed level (x-axis)"
		local titlePIF3 = "Bar chart shows percentage of participants"
		
		/* Axes titles */
		local xtitle = "`variablename', minutes/day"
		local ytitleHR = "Hazard ratio (95% CI)"
		local ytitlePIF = "PIF (95% CI)"

		/* Read results from excel file */
		local filename = "Results_`study'_`variable'_model`model'_delta`delta'min`sensitivitytext'"
		if "`study'" == "MA"  | "`study'" == "Joint" {
			import excel "Results meta-analysis\\`filename'.xls", sheet("Sheet1") firstrow clear
		}
		else {
			import excel "Results individual cohorts\\`filename'.xls", sheet("Sheet1") firstrow clear
		}
						
		/* Get options */
		local refstep = Options[3]
		
		/* Textbox with study/MA info */
		if "`study'" == "MA" {
			quietly sum Numstudies
			local numstudies = r(max)
			local textboxline1 = "Meta-analysis of `numstudies' studies"
		}
		else if "`study'" == "Joint" {
			local textboxline1 = "One-stage meta-analysis of 7 studies"
		}
		else local textboxline1 = "Study: `study'"
		if "`sensitivity'" ~= "none" local textboxline1 = "`textboxline1' `sensitivitylabel'"
		if `model' == 1 local textboxline2 = "Model: Adjusted for age and sex"
		if `model' == 2 local textboxline2 = "Model: Fully adjusted"

		
		/* Cumulative PIF textbox */
		local PIFsumHighRisk = PIFsumHighRisk[1]
		local PIFsumHighRisk_L = PIFsumHighRisk[2]
		local PIFsumHighRisk_U = PIFsumHighRisk[3]
		local PIFsumAll = PIFsumAll[1]
		local PIFsumAll_L = PIFsumAll[2]
		local PIFsumAll_U = PIFsumAll[3]

		if `PIFsumHighRisk' == 0 & `PIFsumHighRisk_L' == 0 & `PIFsumHighRisk_U' == 0 {
			local textboxline3 = ""
			local textboxline4 = ""
		}
		else {
			local textboxline3 = "Cumulative PIF for high-risk approach:"
			local textboxline4a: disp %3.1f `PIFsumHighRisk' "% (95%CI"
			local textboxline4b: disp %3.1f `PIFsumHighRisk_L' "% to " %3.1f `PIFsumHighRisk_U' "%)"
			local textboxline4 = "`textboxline4a' `textboxline4b'"
		}
		if `PIFsumAll' == 0 & `PIFsumAll_L' == 0 & `PIFsumAll_U' == 0 {
			local textboxline5 = ""
			local textboxline6 = ""
		}
		else {
			local textboxline5 = "Cumulative PIF for population approach:"
			local textboxline6a: disp %3.1f `PIFsumAll' "% (95%CI"
			local textboxline6b: disp %3.1f `PIFsumAll_L' "% to " %3.1f `PIFsumAll_U' "%)"
			local textboxline6 = "`textboxline6a' `textboxline6b'"
		}

		
		/* ==================== */
		/* Create the HR figure */
		/* ==================== */
		twoway scatter HR Refvalue, mcolor(`color') msymbol(square) msize(`msize') || /*
			*/ rcap L U Refvalue, lcolor(`color') lwidth(medium) msize(vtiny) /*
			*/ yline(1.0, lpattern(shortdash) lcolor(`color') lwidth(vthin)) /*
			*/ yscale(range(`yscaleHR') log) /*
			*/ ylabel(`yticksHR', format(%3.1f) labsize(`ticklabelsize') angle(horizontal) nogrid) /*
			*/ ytitle("`ytitleHR'", size(`axistitlesize') margin(medsmall)) /*
			*/ xscale(range(`xscale')) /*
			*/ xlabel(`xticks', labsize(`ticklabelsize') nogrid) /*
			*/ xtitle("`xtitle'", size(`axistitlesize') margin(small)) /*
			*/ title("{bf:`titleHR1'}" "{bf:`titleHR2'}", size(13pt) linegap(2pt)) /*
			*/ text(`textboxyHR' `textboxxHR' "`textboxline1'" "`textboxline2'", /*
					*/ size(14pt) placement(`textboxHRplacement') /*
					*/ justification(`textboxHRjustification') linegap(3pt)) /*
			*/ text(`panelyHR' `panelx' "`panelHR'", size(huge)) /*
			*/ legend(off) /*
			*/ graphregion(fcolor(white) margin(`graphregionmarginHR')) /*
			*/ ysize("`ysize'") /*
			*/ xsize("`xsize'") /*
			*/ name(HR_`deltaword', replace)				
		if `savefigures' == 1 {
			graph export "Figures final supplementary\\`filename'_HR.tif", as(tif) replace
		}

		
		/* ===================== */
		/* Create the PIF figure */
		/* ===================== */

		/* Generate a variable to hold the percentage of participants labels for the bar chart */
		gen ProportionLabel = ""
		local N = _N
		forvalues i = 1/`N' {
			local proportiontext: disp %3.1f 100*Proportion[`i']
			quietly replace ProportionLabel = "`proportiontext'%" if _n == `i' & Proportion ~= .
		}
		
		local width = `barwidth'*`refstep'
		
		twoway bar Proportion Refvalue, barwidth(`width') color("`barcolor'") lcolor("`baroutlinecolor'") /*
					*/ lwidth(vthin) yaxis(2) ylabel(none, axis(2)) ytitle("", axis(2)) yscale(lstyle(none) /*
					*/ axis(2)) mlabel(ProportionLabel) mlabposition(8) mlabsize(7pt) mlabangle(vertical) /*
					*/ mlabcolor(black) || /*
			*/ scatter PIF Refvalue, yaxis(1) mcolor(`color') msymbol(square) msize(`msize') || /*
			*/ rcap PIF_L PIF_U Refvalue, lcolor(`color') lwidth(medium) msize(vtiny) /*
			*/ yline(0, lpattern(shortdash) lcolor(`color') lwidth(vthin) axis(1)) /*
			*/ yscale(range(`yscalePIF') alt) /*
			*/ ylabel(`yticksPIF', axis(1) format(%3.1f) labsize(`ticklabelsize') angle(horizontal) nogrid) /*
			*/ ytitle("`ytitlePIF'", axis(1) size(`axistitlesize') margin(medsmall)) /*
			*/ yscale(range(0, `maxproportionyaxis') axis(2)) /*
			*/ xscale(range(`xscale')) /*
			*/ xlabel(`xticks', labsize(`ticklabelsize') nogrid) /*
			*/ xtitle("`xtitle'", size(`axistitlesize') margin(small)) /*
			*/ title("{bf:`titlePIF1'}" "{bf:`titlePIF2'}" "{bf:`titlePIF3'}", size(13pt) linegap(3pt)) /*
			*/ text(`textboxyPIF1' `textboxxPIF' "`textboxline1'" "`textboxline2'", /*
					*/ size(14pt) placement(`textboxPIFplacement') /*
					*/ justification(`textboxPIFjustification') linegap(3pt)) /*
			*/ text(`textboxyPIF2' `textboxxPIF' "`textboxline3'" "`textboxline4'", /*
					*/ size(10pt) placement(`textboxPIFplacement') /*
					*/ justification(`textboxPIFjustification') linegap(2pt)) /*
			*/ text(`textboxyPIF3' `textboxxPIF' "`textboxline5'" "`textboxline6'", /*
					*/ size(10pt) placement(`textboxPIFplacement') /*
					*/ justification(`textboxPIFjustification') linegap(2pt)) /*
			*/ text(`panelyPIF' `panelx' "`panelPIF'", size(huge)) /*
			*/ legend(off) /*
			*/ graphregion(fcolor(white) margin(`graphregionmarginPIF')) /*
			*/ ysize("`ysize'") /*
			*/ xsize("`xsize'") /*
			*/ name(PIF_`deltaword', replace)
		if `savefigures' == 1 {
			graph export "Figures final supplementary\\`filename'_PIF.tif", as(tif) replace
		}		
	}
	
end
	

