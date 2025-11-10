program create_HR_and_PIF_plots, rclass
	version 17
	
	syntax, study(string) variables(string) sensitivity(string) models(string) maintext(string) [includeUKBB(string)]

	if "`variables'" == "all" & "`maintext'" ~= "yes" local variables ""MVPA" "LPA" "SED" "TotalPA""
	else if "`variables'" == "all" & "`maintext'" == "yes" local variables ""MVPA" "SED""
	else local variables "`variables'"

	if "`sensitivity'" == "Men" & "`study'" == "WHS" exit
	if "`sensitivity'" == "AgeBelow60" & "`study'" == "HAI" exit	/* Minimum age in HAI: 69 years */
	if "`sensitivity'" == "AgeBelow60" & "`study'" == "WHS" exit	/* Minimum age in WHS: 62 years */
	
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "ABC" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "HAI" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "REGARDS" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "WHS" exit
	if "`sensitivity'" == "NoMobilityProblems" & "`study'" == "NNPAS" exit

	if "`includeUKBB'" == "" local includeUKBB = "no"
	local savefigures = 1

	
	/* General options common for all cases */
	local color = "black"
	local barcolor = "180 230 255"
	local baroutlinecolor = "`barcolor'"
	local barwidth = 0.8
	local graphregionmarginHR = "b-2 l-2"
	local graphregionmarginPIF = "b-2 l-2"
	local ticklabelsize = "small"
	local axistitlesize = "medium"
	local msize = "small"
	if "`study'" == "UKBB" local msize = "1.5pt"
	
	if "`maintext'" == "yes" {
		local graphregionmarginHR = "b-2 l-2 t-3"
		local graphregionmarginPIF = "b-2 l-2 t-6"
		local ticklabelsize = "medium"
		local axistitlesize = "medlarge"
	}

	if "`sensitivity'" == "none" local sensitivitytext = ""
	else local sensitivitytext = "_`sensitivity'"
	if "`sensitivity'" == "Scandinavia" | "`sensitivity'" == "USA" local sensitivitylabel = "(`sensitivity' only)"
	else local sensitivitylabel = strlower("(`sensitivity' only)")
	if "`sensitivity'" == "AgeAbove60" local sensitivitylabel = "(age {&ge} 60 only)"
	if "`sensitivity'" == "AgeBelow60" local sensitivitylabel = "(age < 60 only)"
	if "`sensitivity'" == "NoAdjForBMI" local sensitivitylabel = "(without adj. for BMI)"
	if "`sensitivity'" == "NoMobilityProblems" local sensitivitylabel = "(excluding mobility limitations)"
	if "`sensitivity'" == "ExcludeChronicDiseases" local sensitivitylabel = "(excluding chronic diseases)"
	
	
	foreach variable in `variables' {	
		local variablename = "`variable'"
		
		/* Theses options are optimzed for the meta-analysis plots */
		/* For the individual studies, options may change below */		
		local yscaleHR = "0.3 1.5"
		local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5"
		local yscalePIF = "-2 6.3"
		local yticksPIF = "-2(1)6"
		local maxproportionyaxis = 0.4

		local textboxyHR = 0.42
		local textboxyPIF1 = 5.6
		local textboxyPIF2 = 4.2
		local textboxyPIF3 = 3.1
		local textboxHRjustification = "right"
		local textboxHRplacement = "sw"
		local textboxPIFjustification = "right"
		local textboxPIFplacement = "sw"		
		
		
		if "`variable'" == "MVPA" {
			local xtitleword = "Moderate-to-vigorous-intensity physical activity (MVPA)"
			local ytitleword = "MVPA"
			local deltas = "5 10"
			local xscale = "0 50"
			local xticks = "0(5)50"
			local textboxxHR = 50
			local textboxxPIF = 50

			if "`study'" == "HAI" {
				local yscaleHR = "0.25, 2.0"
				local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0"
				local textboxyHR = 0.37
			}
			if "`study'" == "NHANES" {
				local yscalePIF = "-2 10"
				local yticksPIF = "-2(1)10"
				local textboxyPIF1 = 8.5
				local textboxyPIF2 = 6.5
				local textboxyPIF3 = 4.9
			}
			if "`study'" == "REGARDS" {
				local yscalePIF = "-2 26"
				local yticksPIF = "-2(2)26"
				local textboxyPIF1 = 21
				local textboxyPIF2 = 16.5
				local textboxyPIF3 = 12.9
			}
		}
		if "`variable'" == "MVPA760" {
			local xtitleword = "Moderate-to-vigorous-intensity physical activity (MVPA 760)"
			local ytitleword = "MVPA"
			local deltas = "10 20"
			local xscale = "0 100"
			local xticks = "0(10)100"
			local textboxxHR = 100
			local textboxxPIF = 100
		}
		if "`variable'" == "LPA" {
			local xtitleword = "Light-intensity physical activity (LPA)"
			local ytitleword = "LPA"
			local deltas = "30 60"
			local xscale = "0 420"
			local xticks = "0(30)420"
			local textboxxHR = 420
			local textboxxPIF = 420

			if "`study'" == "ABC" {
				local yscaleHR = "0.25 4.0"
				local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0 4.0"
				local yscalePIF = "-4 10"
				local yticksPIF = "-4(1)10"
				local textboxyPIF1 = 9.7
				local textboxyPIF2 = 7.4
				local textboxyPIF3 = 5.6
			}
			if "`study'" == "HAI" {
				local textboxyHR = 0.28
				local yscaleHR = "0.2 3.0"
				local yticksHR = "0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0"
				local yscalePIF = "-4 10"
				local yticksPIF = "-4(1)10"
				local textboxyPIF1 = 9.7
				local textboxyPIF2 = 7.4
				local textboxyPIF3 = 5.6
			}
			if "`study'" == "NNPAS" {
				local textboxyHR = 1.7
				local textboxxHR = 130
				local textboxHRjustification = "left"
				local textboxHRplacement = "ne"
				local yscaleHR = "0.2 3.0"
				local yticksHR = "0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0"
				local yscalePIF = "-4 10"
				local yticksPIF = "-4(1)10"
				local textboxyPIF1 = 9.7
				local textboxyPIF2 = 7.4
				local textboxyPIF3 = 5.6
			}
			if "`study'" == "Tromsø study" {
				local textboxyHR = 0.32
				local yscaleHR = "0.2 2.5"
				local yticksHR = "0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 2.5"
				local yscalePIF = "-4 10"
				local yticksPIF = "-4(1)10"
				local textboxyPIF1 = 8.7
				local textboxyPIF2 = 6.4
				local textboxyPIF3 = 4.6
			}
		}
				
		if "`variable'" == "SED" {
			local xtitleword = "Sedentary time"
			local ytitleword = "sedentary time"
			local deltas = "-30 -60"
			local xscale = "210 900"
			local xticks = "240(60)900"
			local textboxxHR = 900
			local textboxxPIF = 900

			if "`study'" == "ABC" {
				local yscaleHR = "0.25 4.0"
				local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0 4.0"
				local yscalePIF = "-6 12"
				local yticksPIF = "-6(2)12"
				local textboxyHR = 3.5
				local textboxyPIF1 = 11.7
				local textboxyPIF2 = 9
				local textboxyPIF3 = 6.8
			}
			if "`study'" == "HAI" {
				local yscaleHR = "0.15 3.0"
				local yticksHR = "0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0"
				local yscalePIF = "-6 12"
				local yticksPIF = "-6(2)12"
				local textboxyHR = 2.4
				local textboxyPIF1 = 11.7
				local textboxyPIF2 = 9
				local textboxyPIF3 = 6.8
			}
			if "`study'" == "NHANES" {
				local yscaleHR = "0.3 2.0"
				local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0"
				local yscalePIF = "-3 6"
				local yticksPIF = "-3(1)6"
				local textboxyHR = 1.7
			}
			if "`study'" == "REGARDS" {
				local yscalePIF = "-2 10"
				local yticksPIF = "-2(1)10"
				local textboxyHR = 1.4
				local textboxyPIF1 = 10
				local textboxyPIF2 = 8.3
				local textboxyPIF3 = 6.9
			}
			if "`study'" == "NNPAS" {
				local yscaleHR = "0.3 3.0"
				local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0"
				local yscalePIF = "-6 12"
				local yticksPIF = "-6(2)12"
				local textboxyHR = 2.5
				local textboxyPIF1 = 11.7
				local textboxyPIF2 = 9
				local textboxyPIF3 = 6.8
			}
			if "`study'" == "Tromsø study" {
				local yscaleHR = "0.3 2.0"
				local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0"
				local yscalePIF = "-6 12"
				local yticksPIF = "-6(2)12"
				local textboxyHR = 0.45
				local textboxxHR = 810				
				local textboxyPIF1 = 11.7
				local textboxyPIF2 = 9
				local textboxyPIF3 = 6.8
			}
			if "`study'" == "MA" {
				local textboxyHR = 1.4
				local textboxyPIF1 = 6.1
				local textboxyPIF2 = 4.7
				local textboxyPIF3 = 3.6
			}
	}
		
		if "`variable'" == "TotalPA" {
			local xtitleword = "Total physical activity"
			local ytitleword = "total physical activity"
			local deltas = "30 60"
			local xscale = "60 600"
			local xticks = "60(60)600"
			local textboxxHR = 600
			local textboxxPIF = 600
			local variablename = "Total PA"
			
			if "`study'" == "ABC" {
				local yscaleHR = "0.25 3.0"
				local yticksHR = "0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0"
				local yscalePIF = "-3 10"
				local yticksPIF = "-3(1)10"
				local textboxyHR = 0.37
				local textboxyPIF1 = 9.6
				local textboxyPIF2 = 7.6
				local textboxyPIF3 = 6.0
			}
			if "`study'" == "HAI" {
				local yscaleHR = "0.1 2.0"
				local yticksHR = "0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0"
				local yscalePIF = "-4 10"
				local yticksPIF = "-4(1)10"
				local textboxyHR = 0.16
				local textboxyPIF1 = 9.6
				local textboxyPIF2 = 7.6
				local textboxyPIF3 = 6.0
			}
			if "`study'" == "NNPAS" {
				local yscaleHR = "0.2 3.0"
				local yticksHR = "0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0 3.0"
				local yscalePIF = "-5 11"
				local yticksPIF = "-5(1)11"
				local textboxyHR = 0.29
				local textboxyPIF1 = 10.9
				local textboxyPIF2 = 8.4
				local textboxyPIF3 = 6.4
			}
			if "`study'" == "Tromsø study" {
				local yscaleHR = "0.2 2.0"
				local yticksHR = "0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 2.0"
				local yscalePIF = "-4 8"
				local yticksPIF = "-4(1)8"
				local textboxyHR = 0.29
				local textboxyPIF1 = 7.6
				local textboxyPIF2 = 5.7
				local textboxyPIF3 = 4.2
			}
		}

		if "`maintext'" == "yes" {
			local yscaleHR = "0.4 1.8"
			local yticksHR = "0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.3 1.5 1.8"
			local yscalePIF = "-2 6"
			local yticksPIF = "-2(1)6"
			local maxproportionyaxis = 0.4
		}
		
		
		foreach delta in `deltas' {
			local deltaword = abs(`delta')
			foreach model in `models' {
				local unit = "min" 

				/* Figure titles */
				if `delta' < 0 {
					local changeword = "decrease"
					local changewordytitle = "less"
				}
				else {
					local changeword = "increase"
					local changewordytitle = "extra"
				}
				
				local titleHR = "Hazard ratio for mortality for `deltaword' `unit' `changeword'"
				local titleHR = "`titleHR' in `variablename' from observed level (x-axis)"

				local titlePIF1 = "Percentage PIF for `deltaword' `unit' `changeword'"
				local titlePIF1 = "`titlePIF1' in `variablename' from observed level (x-axis)"
				local titlePIF2 = "Bar chart shows percentage of participants"
				
				/* Axes titles */
				if "`maintext'" == "yes" {
					local xtitle1 = "`xtitleword', minutes/day"
					local ytitleHR1 = "Having `deltaword' min/day `changewordytitle' `ytitleword'"
					local ytitleHR2 = "Hazard ratio (95% CI) for all-cause mortality"
					local ytitlePIF1 = "Having `deltaword' min/day `changewordytitle' `ytitleword'"
					local ytitlePIF2 = "Potential impact fraction (95% CI)"
				}
				else {
					local xtitle1 = "`variablename', minutes/day"
					local ytitleHR1 = "Hazard ratio (95% CI)"
					local ytitlePIF1 = "PIF (95% CI)"
					local xtitle2 = ""
					local ytitleHR2 = ""
					local ytitlePIF2 = ""
				}

				/* Read results from excel file */
				local filename = "Results_`study'_`variable'_model`model'_delta`delta'min`sensitivitytext'"
				if "`study'" == "MA"  | "`study'" == "Joint" {
					if "`includeUKBB'" == "yes" & "`sensitivity'" ~= "Scandinavia" & "`sensitivity'" ~= "USA" {
						local filename = "`filename'_includingUKBB"
					}
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


				/* Add the study/MA info also in the x title for the figures in the main manuscript */
				if "`maintext'" == "yes" local xtitle2 = "`textboxline1'. `textboxline2'."
				else local xtitle2 = ""

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


				local HRarrowcolor = "none"
				local PIFarrow1color = "none"
				local PIFarrow2color = "none"
				local HRarrowy1 = `textboxyHR'
				local HRarrowx1 = `textboxxHR'
				local HRarrowy2 = `textboxyHR'
				local HRarrowx2 = `textboxxHR'
				local PIFarrow1y1 = `textboxyPIF1'
				local PIFarrow1x1 = `textboxxPIF'
				local PIFarrow1y2 = `textboxyPIF1'
				local PIFarrow1x2 = `textboxxPIF'
				local PIFarrow2y1 = `textboxyPIF1'
				local PIFarrow2x1 = `textboxxPIF'
				local PIFarrow2y2 = `textboxyPIF1'
				local PIFarrow2x2 = `textboxxPIF'

				/* ======================================================================================= */
				/* Remove titles and info boxes for the figures that go in the main text of the manuscript */
				/* (and add abcd and arrows)                                                               */
				/* ======================================================================================= */
				if "`maintext'" == "yes" {
					local titleHR = ""
					local titlePIF1 = ""
					local titlePIF2 = ""
					local textboxline1 = ""
					local textboxline2 = ""
					local textboxline3 = ""
					local textboxline4 = ""
					local textboxline5 = ""
					local textboxline6 = ""
					
					local abcdyHR = word("`yscaleHR'", -1)
					local abcdyPIF = word("`yscalePIF'", -1)
					local abcdx = word("`xscale'", -1)
					
					if "`variable'" == "MVPA" | "`variable'" == "MVPA760" local figure = 1
					if ("`variable'" == "MVPA" | "`variable'" == "MVPA760") & `delta' == 5 {
						local HRabcd = "a"
						local HRarrowcolor = "red"
						local HRarrowy1 = 0.6
						local HRarrowx1 = 15
						local HRarrowy2 = 0.7
						local HRarrowx2 = 2.1

						local PIFabcd = "c"
						local PIFarrow1color = "red"
						local PIFarrow1y1 = 3.55
						local PIFarrow1x1 = 15
						local PIFarrow1y2 = 3.55
						local PIFarrow1x2 = 2.4
						local PIFarrow2color = "red"
						local PIFarrow2y1 = 2.1
						local PIFarrow2x1 = 15
						local PIFarrow2y2 = 1.47
						local PIFarrow2x2 = 4.0
					}
					if ("`variable'" == "MVPA" | "`variable'" == "MVPA760") & `delta' == 10 {
						local HRabcd = "b"
						local HRarrowcolor = "red"
						local HRarrowy1 = 0.5
						local HRarrowx1 = 15
						local HRarrowy2 = 0.575
						local HRarrowx2 = 2.1
						local PIFabcd = "d"
						local PIFarrow1color = "none"
						local PIFarrow2color = "none"
					}
					if "`variable'" == "SED" local figure = 2
					if "`variable'" == "SED" & `delta' == -30 local HRabcd = "a"
					if "`variable'" == "SED" & `delta' == -60 local HRabcd = "b"
					if "`variable'" == "SED" & `delta' == -30 local PIFabcd = "c"
					if "`variable'" == "SED" & `delta' == -60 local PIFabcd = "d"
					if "`study'" == "UKBB" {
						local HRarrowcolor = "none"
						local PIFarrow1color = "none"
						local PIFarrow2color = "none"
					}
					if "`study'" == "UKBB" & "`variable'" == "MVPA" local figure = 3
					if "`study'" == "UKBB" & "`variable'" == "SED" local figure = 4

					local filenameHR = "Figure`figure'`HRabcd'"
					local filenamePIF = "Figure`figure'`PIFabcd'"
										
				}
				else {
					local HRabcd = ""
					local PIFabcd = ""
				}
				

				/* ==================== */
				/* Create the HR figure */
				/* ==================== */
				twoway scatter HR Refvalue, mcolor(`color') msymbol(square) msize(`msize') || /*
					*/ rcap L U Refvalue, lcolor(`color') lwidth(medthin) msize(vtiny) /*
					*/ yline(1.0, lpattern(shortdash) lcolor(`color') lwidth(vthin)) || /*
					*/ pcarrowi `HRarrowy1' `HRarrowx1' `HRarrowy2' `HRarrowx2', lwidth(thick) lcolor(`HRarrowcolor') /*
							*/ msize(large) mlwidth(thick) mcolor(`HRarrowcolor') /*
					*/ yscale(range(`yscaleHR') log) /*
					*/ ylabel(`yticksHR', format(%3.1f) labsize(`ticklabelsize') angle(horizontal) nogrid) /*
					*/ ytitle("`ytitleHR1'" "`ytitleHR2'", size(`axistitlesize') linegap(3pt) margin(medsmall)) /*
					*/ xscale(range(`xscale')) /*
					*/ xlabel(`xticks', labsize(`ticklabelsize') nogrid) /*
					*/ xtitle("`xtitle1'" "`xtitle2'", size(`axistitlesize') linegap(3pt) margin(small)) /*
					*/ title("{bf:`titleHR'}", size(small)) /*
					*/ text(`textboxyHR' `textboxxHR' "`textboxline1'" "`textboxline2'", /*
							*/ size(medsmall) placement(`textboxHRplacement') /*
							*/ justification(`textboxHRjustification') linegap(3pt)) /*
					*/ text(`abcdyHR' `abcdx' "`HRabcd'", size(huge)) /*
					*/ legend(off) /*
					*/ graphregion(fcolor(white) margin(`graphregionmarginHR')) /*
					*/ name(HR_`deltaword', replace)				
				if `savefigures' == 1 {
					if "`maintext'" == "yes" {
						graph export "Figures for main text\\`filenameHR'.tif", as(tif) replace
						graph export "Figures for main text\EPS\\`filenameHR'.eps", as(eps) replace
						graph export "Figures for main text\PDF\\`filenameHR'.pdf", as(pdf) replace
					}
					else graph export "Figures\\`filename'_HR.tif", as(tif) replace
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
							*/ axis(2)) mlabel(ProportionLabel) mlabposition(8) mlabsize(vsmall) mlabangle(vertical) /*
							*/ mlabcolor(black) || /*
					*/ scatter PIF Refvalue, yaxis(1) mcolor(`color') msymbol(square) msize(`msize') || /*
					*/ rcap PIF_L PIF_U Refvalue, lcolor(`color') lwidth(medthin) msize(vtiny) /*
					*/ yline(0, lpattern(shortdash) lcolor(`color') lwidth(vthin) axis(1)) ||  /*
					*/ pcarrowi `PIFarrow1y1' `PIFarrow1x1' `PIFarrow1y2' `PIFarrow1x2', lwidth(thick) lcolor(`PIFarrow1color') /*
							*/ msize(large) mlwidth(thick) mcolor(`PIFarrow1color') || /*
					*/ pcarrowi `PIFarrow2y1' `PIFarrow2x1' `PIFarrow2y2' `PIFarrow2x2', lwidth(thick) lcolor(`PIFarrow2color') /*
							*/ msize(large) mlwidth(thick) mcolor(`PIFarrow2color') /*
					*/ yscale(range(`yscalePIF') alt) /*
					*/ ylabel(`yticksPIF', axis(1) format(%3.1f) labsize(`ticklabelsize') angle(horizontal) nogrid) /*
					*/ ytitle("`ytitlePIF1'" "`ytitlePIF2'", axis(1) size(`axistitlesize') linegap(3pt) margin(medsmall)) /*
					*/ yscale(range(0, `maxproportionyaxis') axis(2)) /*
					*/ xscale(range(`xscale')) /*
					*/ xlabel(`xticks', labsize(`ticklabelsize') nogrid) /*
					*/ xtitle("`xtitle1'" "`xtitle2'", size(`axistitlesize') linegap(3pt) margin(small)) /*
					*/ title("{bf:`titlePIF1'}" "{bf:`titlePIF2'}", size(small) linegap(2pt)) /*
					*/ text(`textboxyPIF1' `textboxxPIF' "`textboxline1'" "`textboxline2'", /*
							*/ size(medsmall) placement(`textboxPIFplacement') /*
							*/ justification(`textboxPIFjustification') linegap(3pt)) /*
					*/ text(`textboxyPIF2' `textboxxPIF' "`textboxline3'" "`textboxline4'", /*
							*/ size(small) placement(`textboxPIFplacement') /*
							*/ justification(`textboxPIFjustification') linegap(2pt)) /*
					*/ text(`textboxyPIF3' `textboxxPIF' "`textboxline5'" "`textboxline6'", /*
							*/ size(small) placement(`textboxPIFplacement') /*
							*/ justification(`textboxPIFjustification') linegap(2pt)) /*
					*/ text(`abcdyPIF' `abcdx' "`PIFabcd'", size(huge)) /*
					*/ legend(off) /*
					*/ graphregion(fcolor(white) margin(`graphregionmarginPIF')) /*
					*/ name(PIF_`deltaword', replace)
				if `savefigures' == 1 {
					if "`maintext'" == "yes" {
						graph export "Figures for main text\\`filenamePIF'.tif", as(tif) replace
						graph export "Figures for main text\EPS\\`filenamePIF'.eps", as(eps) replace
						graph export "Figures for main text\PDF\\`filenamePIF'.pdf", as(pdf) replace
					}
					else graph export "Figures\\`filename'_PIF.tif", as(tif) replace
					
				}
			}
		}
	}

end


