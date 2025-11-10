cd "[...]\Deaths Potentially Averted"
discard

local studies ""ABC" "HAI" "NHANES" "REGARDS" "WHS" "NNPAS" "Tromsø study" "UKBB""

local studynum = 0
foreach study in `studies' {
	local studynum = `studynum' + 1
	disp "Adding: `study'"
	use "Analysis files\\`study'.dta", clear

	keep INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA MVPA VPA Weartime /*
		*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer
	
	foreach var of varlist _all {
		label variable `var' ""
	}

	gen Studynum = `studynum'
	gen Studyname = "`study'"
	quietly gen ID = `studynum'*1000000 + _n
	order Studynum Studyname ID
	
	if `studynum' ~= 1 {
		quietly append using "Analysis files\Jointdata.dta"
		sort Studynum ID		
	}
	save "Analysis files\Jointdata.dta", replace
}

