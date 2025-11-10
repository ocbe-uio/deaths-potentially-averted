cd "[...]\Deaths Potentially Averted"

local includesamplesize = 0
local logfilename = "Table 2 - Cumulative PIFs - $S_DATE"

local title1 = "Table 2: Cumulative potential impact fraction (PIF) for changes in moderate and vigorous physical activity"
local title1 = "`title1' (MVPA), light physical activity (LPA), sedentary time (SED), and total physical activity (Total PA),"
local title1 = "`title1' based on meta-analysis of 7(6)"
local title2 = " studies in the accelerometer consortium and a separate analysis of the UKBB study"


putdocx begin, font(Calibri, 10) margin(left, 2.5cm) margin(right, 2.5cm) margin(top, 2.5cm) margin(bottom, 2.5cm)

putdocx paragraph
putdocx text ("`title1'"), font(Calibri, 11) bold
putdocx text ("1"), script(super) font(Calibri, 11) bold
putdocx text ("`title2'"), font(Calibri, 11) bold

putdocx table table = (29,3), width(100%)
putdocx table table(.,1), width(150pt)
putdocx table table(.,2), width(200pt)
putdocx table table(.,3), width(200pt)

putdocx table table(1,2) = ("Cumulative PIF (95% CI)"), colspan(3) halign(center) bold
putdocx table table(2,2) = ("High-risk approach"), halign(center) bold
putdocx table table(2,2) = ("2"), script(super) append bold
putdocx table table(2,3) = ("Population approach"), halign(center) bold
putdocx table table(2,3) = ("3"), script(super) append bold

putdocx table table(3,1) = ("MVPA: 5 min/day increase"), halign(left) bold
putdocx table table(4,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(5,1) = ("   UKBB"), halign(left)
putdocx table table(6,1) = ("MVPA: 10 min/day increase"), halign(left) bold
putdocx table table(7,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(8,1) = ("   UKBB"), halign(left)

putdocx table table(10,1) = ("LPA: 30 min/day increase"), halign(left) bold
putdocx table table(11,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(12,1) = ("   UKBB"), halign(left)
putdocx table table(13,1) = ("LPA: 60 min/day increase"), halign(left) bold
putdocx table table(14,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(15,1) = ("   UKBB"), halign(left)

putdocx table table(17,1) = ("SED: 30 min/day decrease"), halign(left) bold
putdocx table table(18,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(19,1) = ("   UKBB"), halign(left)
putdocx table table(20,1) = ("SED: 60 min/day decrease"), halign(left) bold
putdocx table table(21,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(22,1) = ("   UKBB"), halign(left)

putdocx table table(24,1) = ("Total PA: 30 min/day increase"), halign(left) bold
putdocx table table(25,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(26,1) = ("   UKBB"), halign(left)
putdocx table table(27,1) = ("Total PA: 60 min/day increase"), halign(left) bold
putdocx table table(28,1) = ("   Accelerometer consortium"), halign(left)
putdocx table table(29,1) = ("   UKBB"), halign(left)

putdocx paragraph, font(Calibri, 10) spacing(before, 0pt)
putdocx text ("1"), script(super)
putdocx text ("The REGARDS study is only included in the meta-analysis for MVPA"), linebreak
putdocx text ("2"), script(super)
putdocx text ("Cumulative PIF calculated for the 20% (approximately) least active participants"), linebreak
putdocx text ("3"), script(super)
putdocx text ("Cumulative PIF calculated for all participants except the 20% (approximately) most active"), linebreak


/* Insert the PIFs */
local studies ""MA" "UKBB""
local variables ""MVPA" "LPA" "SED" "TotalPA""

local row = 1
foreach variable in `variables' {
	disp "Reading PIFs for `variable'"
	
	local row = `row' + 1
	if "`variable'" == "MVPA" local deltas = "5 10"
	if "`variable'" == "LPA" local deltas = "30 60"
	if "`variable'" == "SED" local deltas = "-30 -60"
	if "`variable'" == "TotalPA" local deltas = "30 60"
	foreach delta in `deltas' {
		local row = `row' + 1
		foreach study in `studies' {
			local row = `row' + 1
			
			local filename = "Results_`study'_`variable'_model2_delta`delta'min"
			if "`study'" == "MA" quietly import excel "Results meta-analysis\\`filename'.xls", sheet("Sheet1") firstrow clear
			if "`study'" == "UKBB" quietly import excel "Results individual cohorts\\`filename'.xls", sheet("Sheet1") firstrow clear
			
			local PIF = PIFsumHighRisk[1]
			local L = PIFsumHighRisk[2]
			local U = PIFsumHighRisk[3]
			local N = PIFsumHighRisk[5]
			if `includesamplesize' == 1 local celltext: disp %4.1f `PIF' "% (" %3.1f `L' "% to " %3.1f `U' "%) N=`N'"
			else local celltext: disp %4.1f `PIF' "% (" %3.1f `L' "% to " %3.1f `U' "%)"
			putdocx table table(`row',2) = ("`celltext'"), halign(center)

			local PIF = PIFsumAll[1]
			local L = PIFsumAll[2]
			local U = PIFsumAll[3]
			local N = PIFsumAll[5]
			if `includesamplesize' == 1 local celltext: disp %4.1f `PIF' "% (" %3.1f `L' "% to " %3.1f `U' "%) N=`N'"
			else local celltext: disp %4.1f `PIF' "% (" %3.1f `L' "% to " %3.1f `U' "%)"
			putdocx table table(`row',3) = ("`celltext'"), halign(center)		
			
		}
	}
}

putdocx save "Reports\\`logfilename'.docx", replace


