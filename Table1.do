cd "[...]\Deaths Potentially Averted"

local title = "Table 1: Descriptive characteristics of each cohort."
local title = "`title' Numbers shown are mean (standard deviation) or count (%)."
local logfilename = "Table 1 - Descriptives - $S_DATE"
putdocx begin, font(Calibri, 8) margin(left, 1.4cm) margin(right, 1.4cm) margin(top, 2.0cm) margin(bottom, 2.0cm)


/* Split into two parts (t=1 and t=2), technically two different tables */
forvalues t = 1/2 {
	if `t' == 1 {
		putdocx table table1 = (28,9), width(100%) title("`title'", bold)
		local studies ""ABC" "HAI" "NHANES" "REGARDS""
	}
	if `t' == 2 {
		putdocx table table2 = (27,9), width(100%) title(" ")
		putdocx table table2(.,3), width(45pt)	/* Lessen the width of the WHS men column */
		local studies ""WHS" "NNPAS" "Tromsø study" "UKBB""
	}

	putdocx table table`t'(3,1) = ("Number of participants"), halign(left)
	putdocx table table`t'(4,1) = ("Location"), halign(left)
	putdocx table table`t'(5,1) = ("Accelerometer type"), halign(left)
	putdocx table table`t'(7,1) = ("Participants"), halign(left)
	putdocx table table`t'(8,1) = ("Deaths"), halign(left)
	putdocx table table`t'(9,1) = ("Follow up time, years"), halign(left)
	putdocx table table`t'(10,1) = ("Age, years"), halign(left)
	putdocx table table`t'(11,1) = ("Age ≥60 years"), halign(left)
	putdocx table table`t'(12,1) = ("Sedentary, min/day"), halign(left)
	putdocx table table`t'(13,1) = ("Total PA, min/day"), halign(left)
	putdocx table table`t'(14,1) = ("LPA, min/day"), halign(left)
	putdocx table table`t'(15,1) = ("MVPA, min/day"), halign(left)
	putdocx table table`t'(16,1) = ("BMI, kg/m"), halign(left)
	putdocx table table`t'(16,1) = ("2"), script(super) append
	putdocx table table`t'(17,1) = ("BMI ≥30"), halign(left)
	putdocx table table`t'(18,1) = ("Smoking"), halign(left)
	putdocx table table`t'(19,1) = ("  Never"), halign(left)
	putdocx table table`t'(20,1) = ("  Former"), halign(left)
	putdocx table table`t'(21,1) = ("  Current"), halign(left)
	putdocx table table`t'(22,1) = ("Education"), halign(left)
	putdocx table table`t'(23,1) = ("  Primary"), halign(left)
	putdocx table table`t'(24,1) = ("  High school"), halign(left)
	putdocx table table`t'(25,1) = ("  University"), halign(left)
	putdocx table table`t'(26,1) = ("History of CVD"), halign(left)
	putdocx table table`t'(27,1) = ("History of cancer"), halign(left)
	putdocx table table`t'(28,1) = ("Diabetes"), halign(left)

	putdocx table table`t'(.,1), width(90pt)

	local womencolnum = 0
	foreach study in `studies' {
		local womencolnum = `womencolnum' + 2
		local mencolnum = `womencolnum' + 1

		disp _newline "Loading file: `study'.dta"
		use "Analysis files\\`study'.dta", clear
		
		/* Study header */
		quietly count if INCLUDE == 1
		local N = r(N)
		local col = 1 + `womencolnum'/2
		putdocx table table`t'(2,`col') = ("`study'"), colspan(2) halign(center) bold

		/* Number of participants */
		putdocx table table`t'(3,`col') = ("`N'"), colspan(2) halign(center)		
		
		/* Cohort location */
		local location = location[1]
		putdocx table table`t'(4, `col') = ("`location'"), colspan(2) halign(center)

		/* Accelerometer type */
		local accelerometer = accelerometer[1]
		putdocx table table`t'(5, `col') = ("`accelerometer'"), colspan(2) halign(center)

		
		/* Gender: 0 = Female, 1 = Male */
		forvalues i = 0/1 {
			if `i' == 0 {
				local genderheader = "Women"
				local col = `womencolnum'
			}
			else if `i' == 1 {
				local genderheader = "Men"
				local col = `mencolnum'
			}			
			
			/* Women/Men header */
			putdocx table table`t'(6, `col') = ("`genderheader'"), halign(center) bold

			/* Participants */
			quietly count if Gender == `i' & INCLUDE == 1
			local n = r(N)
			local percent: disp %4.1f 100*`n'/`N'
			if `percent' == 100 local percent: disp %3.0f `percent'
			if `n' == 0 local percent = "0"
			putdocx table table`t'(7, `col') = ("`n' (`percent'%)"), halign(center)

			/* Deaths */
			quietly count if Death == 1 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(8, `col') = ("`celltext'"), halign(center)
			
			/* Follow-up */
			quietly sum follow_up_years if Gender == `i' & INCLUDE == 1
			local celltext: disp %4.1f r(mean) " (" %3.1f r(sd) ")"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(9, `col') = ("`celltext'"), halign(center)

			/* Age */
			quietly sum Age if Gender == `i' & INCLUDE == 1
			local celltext: disp %4.1f r(mean) " (" %3.1f r(sd) ")"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(10, `col') = ("`celltext'"), halign(center)
			
			/* Age >= 60 */
			quietly count if AgeAbove60 == 1 & Gender == `i' & INCLUDE == 1
			local percent: disp %4.1f 100*r(N)/`n'
			if `percent' == 100 local percent: disp %3.0f `percent'
			local celltext: disp r(N) " (`percent'%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(11, `col') = ("`celltext'"), halign(center)
			
			/* Sedentary time (min/day) */
			quietly sum SED if Gender == `i' & INCLUDE == 1
			if r(mean) < 100 local celltext: disp %4.1f r(mean)
			if r(mean) >= 100 local celltext: disp %3.0f r(mean)
			if r(sd) < 100 local celltext: disp "`celltext'" " (" %3.1f r(sd) ")"
			if r(sd) >= 100 local celltext: disp "`celltext'" " (" %3.0f r(sd) ")"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(12, `col') = ("`celltext'"), halign(center)
			
			/* Total physical activity (min/day) */
			quietly sum TotalPA if Gender == `i' & INCLUDE == 1
			if r(mean) < 100 local celltext: disp %4.1f r(mean)
			if r(mean) >= 100 local celltext: disp %3.0f r(mean)
			if r(sd) < 100 local celltext: disp "`celltext'" " (" %3.1f r(sd) ")"
			if r(sd) >= 100 local celltext: disp "`celltext'" " (" %3.0f r(sd) ")"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(13, `col') = ("`celltext'"), halign(center)

			/* LPA (min/day) */
			quietly sum LPA if Gender == `i' & INCLUDE == 1
			if r(mean) < 100 local celltext: disp %4.1f r(mean)
			if r(mean) >= 100 local celltext: disp %3.0f r(mean)
			if r(sd) < 100 local celltext: disp "`celltext'" " (" %3.1f r(sd) ")"
			if r(sd) >= 100 local celltext: disp "`celltext'" " (" %3.0f r(sd) ")"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(14, `col') = ("`celltext'"), halign(center)

			/* MVPA (min/day) */
			quietly sum MVPA if Gender == `i' & INCLUDE == 1
			local celltext: disp %4.1f r(mean) " (" %3.1f r(sd) ")"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(15, `col') = ("`celltext'"), halign(center)
			
			/* BMI */
			quietly sum BMI if Gender == `i' & INCLUDE == 1
			local celltext: disp %4.1f r(mean) " (" %3.1f r(sd) ")"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(16, `col') = ("`celltext'"), halign(center)
			
			/* BMI >= 30 */
			quietly count if BMIabove30 == 1 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(17, `col') = ("`celltext'"), halign(center)

			/* Smoking */
			quietly count if Smoke == 0 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(19, `col') = ("`celltext'"), halign(center)
			quietly count if Smoke == 1 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(20, `col') = ("`celltext'"), halign(center)
			quietly count if Smoke == 2 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(21, `col') = ("`celltext'"), halign(center)

			/* Education */
			quietly count if Education == 0 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(23, `col') = ("`celltext'"), halign(center)
			quietly count if Education == 1 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(24, `col') = ("`celltext'"), halign(center)
			quietly count if Education == 2 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(25, `col') = ("`celltext'"), halign(center)
			
			/* History of CVD */
			quietly count if CVD == 1 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(26, `col') = ("`celltext'"), halign(center)
			
			/* History of cancer */
			if "`study'" == "REGARDS" {
				quietly count if Cancer ~= . & Gender == `i' & INCLUDE == 1
				local n_non_missing`i' = r(N)
				quietly count if Cancer == 1 & Gender == `i' & INCLUDE == 1
				local celltext: disp r(N) " (" %3.1f 100*r(N)/`n_non_missing`i'' "%)*"
			}
			else {
				quietly count if Cancer == 1 & Gender == `i' & INCLUDE == 1
				local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
				if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			}
			
			putdocx table table`t'(27, `col') = ("`celltext'"), halign(center)

			/* Diabetes */
			quietly count if Diabetes == 1 & Gender == `i' & INCLUDE == 1
			local celltext: disp r(N) " (" %3.1f 100*r(N)/`n' "%)"
			if "`study'" == "WHS" & `i' == 1 local celltext = " . (  .)"
			putdocx table table`t'(28, `col') = ("`celltext'"), halign(center)
			
		}	
	}
}


putdocx table table1(29, 1) = ("*Percentages calculated out of `n_non_missing0' (women) and `n_non_missing1' (men) non-missing observations"), halign(left) colspan(9) font(Calibri, 7) border(bottom, nil) border(left, nil) border(right, nil)

putdocx save "Reports\\`logfilename'.docx", replace


