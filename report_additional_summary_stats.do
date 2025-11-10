cd "[...]\Deaths Potentially Averted"
discard

use "Analysis files\Jointdata.dta", clear

log using "Reports\Additional summary stats - $S_DATE.log", replace


/* Mean and std MVPA for the 20% most active */
centile MVPA if INCLUDE == 1 & Studyname ~= "UKBB", centile(80)
sum MVPA if MVPA >= r(c_1) & INCLUDE == 1 & Studyname ~= "UKBB"


/* Mean and std SED for the 20% least sedentary */
centile SED if INCLUDE == 1 & Studyname ~= "UKBB", centile(20)
sum SED if SED <= r(c_1) & INCLUDE == 1 & Studyname ~= "UKBB"


/* Age, follow-up, and gender in the combined sample (without UKBB) */
sum Age follow_up_years if INCLUDE == 1 & Studyname ~= "UKBB"
tab Gender if INCLUDE == 1 & Studyname ~= "UKBB"

/* Age, follow-up, and gender in the combined sample (with UKBB) */
sum Age follow_up_years if INCLUDE == 1
tab Gender if INCLUDE == 1



/* MVPA, sedentary time, and weartime in the accelerometer consortium and UKBB separately */
sum MVPA SED Weartime if INCLUDE == 1 & Studyname ~= "UKBB"
sum MVPA SED Weartime if INCLUDE == 1 & Studyname == "UKBB"


/* MVPA and SED for "high-risk approach" and "population approach" (from Table 2) */
local studies ""MA" "UKBB""
local variables ""MVPA" "LPA" "SED" "TotalPA""

local row = 1
foreach variable in `variables' {
	local row = `row' + 1
	if "`variable'" == "MVPA" local delta = "5"
	if "`variable'" == "LPA" local delta = "30"
	if "`variable'" == "SED" local delta = "-30"
	if "`variable'" == "TotalPA" local delta = "30"

	foreach study in `studies' {
		local filename = "Results_`study'_`variable'_model2_delta`delta'min"
		if "`study'" == "MA" quietly import excel "Results meta-analysis\\`filename'.xls", sheet("Sheet1") firstrow clear
		if "`study'" == "UKBB" quietly import excel "Results individual cohorts\\`filename'.xls", sheet("Sheet1") firstrow clear
		
		local PAmax = PIFsum[6]
		local PAmaxAll = PIFsumAll[6]
		local PAmaxHighRisk = PIFsumHighRisk[6]
		
		use "Analysis files\Jointdata.dta", clear
		if "`study'" == "MA" quietly drop if Studyname == "UKBB"
		if "`study'" == "UKBB" quietly drop if Studyname ~= "UKBB"
		
		if "`variable'" == "SED" quietly sum `variable' if INCLUDE == 1 & `variable' >= `PAmax'
		else quietly sum `variable' if INCLUDE == 1 & `variable' <= `PAmax'
		local mean: disp %3.1f r(mean)
		if "`variable'" == "SED" quietly sum `variable' if INCLUDE == 1 & `variable' >= `PAmaxAll'
		else quietly sum `variable' if INCLUDE == 1 & `variable' <= `PAmaxAll'
		local meanAll: disp %3.1f r(mean)
		if "`variable'" == "SED" quietly sum `variable' if INCLUDE == 1 & `variable' >= `PAmaxHighRisk'
		else quietly sum `variable' if INCLUDE == 1 & `variable' <= `PAmaxHighRisk'
		local meanHighRisk: disp %3.1f r(mean)

		if "`study'" == "MA" local studytext = "Accelerometer consortium"
		else local studytext = "`study'"

		disp "`variable', `studytext':"
		disp "   Mean high-risk approach: `meanHighRisk' min/day"
		disp "   Mean population approach: `meanAll' min/day"
	}
}

log close



