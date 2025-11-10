cd "[...]\Deaths Potentially Averted"


/* ============= */
/* ==== ABC ==== */
/* ============= */
import excel "Data files\ABC.xlsx", firstrow clear

drop _st _d _t _t0
drop if studytime_days == .

rename id ID
gen INCLUDE = 1

rename sex Gender
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl

rename dod Death
gen follow_up_years = studytime_days/365.25

rename age Age
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

destring sed_min, gen(SED)
destring light_min, gen(LPA)
destring mod_min, gen(MPA)
destring vig_min, gen(VPA)
destring veryvig_min, gen(VVPA)
destring mvpa_min, gen(MVPA)
gen TotalPA = LPA + MPA + VPA + VVPA

/* Round all PA variables to one decimal place */
replace SED = round(SED, 0.1)
replace TotalPA = round(TotalPA, 0.1)
replace LPA = round(LPA, 0.1)
replace MVPA = round(MVPA, 0.1)
replace VPA = round(VPA, 0.1)

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .

destring bmi, gen(BMI)
gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename smoke_cat Smoke
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename nyeduc Education
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename heartd CVD
label define yesnolbl 0 "No" 1 "Yes"
label values CVD yesnolbl

rename tumour Cancer
label values Cancer yesnolbl

rename diabetes Diabetes
label values Diabetes yesnolbl

gen location = "Sweden"
gen accelerometer = "ActiGraph 7164 (lower back)"

order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA MVPA MVPA_active VPA Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer
save "Analysis files\ABC_with_missing.dta", replace






/* ============= */
/* ==== HAI ==== */
/* ============= */
use "Data files\HAI.dta", clear

drop id	/* Filled with missing values only */

drop if follow_up_months == .

rename lopnummer ID
format ID %10.0g
gen INCLUDE = 1

rename sex Gender
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl

rename dead Death
gen follow_up_years = follow_up_months/12

rename age Age
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

rename sed_valid_days SED
rename lpa_valid_days LPA
rename mvpa_valid_days MVPA
rename vig_valid_days VPA
gen TotalPA = LPA + MVPA

/* Round all PA variables to one decimal place */
replace SED = round(SED, 0.1)
replace TotalPA = round(TotalPA, 0.1)
replace LPA = round(LPA, 0.1)
replace MVPA = round(MVPA, 0.1)
replace VPA = round(VPA, 0.1)

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .

drop if SED == . & LPA == . & MVPA == . & TotalPA == .

rename bmi BMI
gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename smoke Smoke
recode Smoke (1=2) (2=1) (3=0)
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename education Education
recode Education (1=0) (2=1) (3=2) (4=2)
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename cvd CVD
label define yesnolbl 0 "No" 1 "Yes"
label values CVD yesnolbl

rename cancer Cancer
label values Cancer yesnolbl

rename diabetes Diabetes
label values Diabetes yesnolbl

gen location = "Sweden"
gen accelerometer = "ActiGraph GT3X+ (right hip)"

/* Exclude participants with less than 10 hours/day for four days of weartime */
drop if number_valid_days < 4


order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA MVPA MVPA_active VPA Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer
save "Analysis files\HAI_with_missing.dta", replace







/* ================ */
/* ==== NHANES ==== */
/* ================ */
use "Data files\NHANES.dta", clear

drop if follow_up_years == .

rename seqn ID
gen INCLUDE = 1

gen Gender = .
replace Gender = 0 if riagendr == 2
replace Gender = 1 if riagendr == 1
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl

rename mortstat Death
format follow_up_years %18.1f
rename age_years Age
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

rename sed_perday SED
rename lpa_perday LPA
rename mvpa_perday MVPA
rename vpa_perday VPA
gen TotalPA = LPA + MVPA

/* Round all PA variables to one decimal place */
replace SED = round(SED, 0.1)
replace TotalPA = round(TotalPA, 0.1)
replace LPA = round(LPA, 0.1)
replace MVPA = round(MVPA, 0.1)
replace VPA = round(VPA, 0.1)

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .

/* Mobility problems: yes/no */
rename mobility Mobilityproblems

rename bmxbmi BMI
gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename smoke Smoke
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename dmdeduc Education
recode Education (1=0) (2=1) (3=2) (7=.) (9=.)
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename mcq160b CHF
rename mcq160c CHD
rename mcq160d Angina
rename mcq160e HA
rename mcq160f Stroke
rename mcq220 Cancer

label define yesnolbl 0 "No" 1 "Yes"
local vars = "CHF CHD Angina HA Stroke Cancer"
foreach var in `vars' {
	replace `var' = 0 if `var' == 2
	replace `var' = . if `var' == 7
	replace `var' = . if `var' == 9
	label values `var' yesnolbl	
}
gen CVD = 0
replace CVD = 1 if CHF == 1 | CHD == 1 | Angina == 1 | HA == 1 | Stroke == 1
replace CVD = . if CHF == . & CHD == . & Angina == . & HA == . & Stroke == .
label values CVD yesnolbl

recode diabetes (1 = 1) (2 = 0) (9 = .), gen(Diabetes) /* One participant has "Don't know" -> "No" */
label values Diabetes yesnolbl

gen location = "USA"
gen accelerometer = "ActiGraph 7164 (right hip)"

order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA MVPA MVPA_active VPA Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer Mobilityproblems
save "Analysis files\NHANES_with_missing.dta", replace








/* ================= */
/* ==== REGARDS ==== */
/* ================= */
import sas using "Data files\REGARDS.sas7bdat", clear

rename id ID
gen INCLUDE = 1

rename Male Gender
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl
rename Death_indicator Death
rename futime follow_up_years

rename AgeApprox Age
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

rename _sed_min SED
rename _lt_min LPA
rename _mv_min MVPA
gen VPA = .
gen TotalPA = LPA + MVPA

/* Round all PA variables to one decimal place */
replace SED = round(SED, 0.1)
replace TotalPA = round(TotalPA, 0.1)
replace LPA = round(LPA, 0.1)
replace MVPA = round(MVPA, 0.1)

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .

gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename Smoker Smoke
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename education Education
recode Education (2=1) (3=2)
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename CVD_HX CVD

rename Cancer Cancerstr
gen Cancer = .
replace Cancer = 0 if Cancerstr == "N"
replace Cancer = 1 if Cancerstr == "Y"
label define yesnolbl 0 "No" 1 "Yes"
label values Cancer yesnolbl

gen location = "USA"
gen accelerometer = "Actical (right hip)"

order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA MVPA MVPA_active VPA Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer
save "Analysis files\REGARDS_with_missing.dta", replace






/* ============= */
/* ==== WHS ==== */
/* ============= */
import sas using "Data files\WHS.sas7bdat", clear

drop if randyears == .

rename newid ID
gen INCLUDE = 1

gen Gender = 0
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl

rename death Death
replace Death = 0 if Death == .
rename randyears follow_up_years

rename ageaccel Age
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

rename EP60_vm_min_farias_sed SED
rename EP60_vm_min_farias_light LPA
rename EP60_vm_min_sasaki_mod MPA
rename EP60_vm_min_sasaki_vig VPA
order ID dayworn wday sum_valid compliant SED LPA MPA VPA 

/* Calculate avg PA variables across (compliant) days */
sort ID dayworn
local vars = "SED LPA MPA VPA"
foreach var in `vars' {
	by ID: egen `var'avg = mean(`var') if compliant == 1
	order `var'avg, after(`var')
	by ID: replace `var'avg = `var'avg[_n+1] if dayworn == 1 & `var'avg == .
	by ID: replace `var'avg = `var'avg[_n+2] if dayworn == 1 & `var'avg == .
	by ID: replace `var'avg = `var'avg[_n+3] if dayworn == 1 & `var'avg == .
	by ID: replace `var'avg = `var'avg[_n+4] if dayworn == 1 & `var'avg == .
	by ID: replace `var'avg = `var'avg[_n+5] if dayworn == 1 & `var'avg == .
	by ID: replace `var'avg = `var'avg[_n+6] if dayworn == 1 & `var'avg == .
	by ID: replace `var'avg = `var'avg[_n+7] if dayworn == 1 & `var'avg == .
}

/* ====================================================================================== */
/* Just keep one row for each participant now that avg PA across days has been calculated */
/* ====================================================================================== */
keep if dayworn == 1
drop dayworn wday compliant SED LPA MPA VPA EP60*		/* Drop daily accelerometer data */
rename SEDavg SED
rename LPAavg LPA
rename MPAavg MPA
rename VPAavg VPA
gen MVPA = MPA + VPA
gen TotalPA = LPA + MVPA

/* Round all PA variables to one decimal place */
replace SED = round(SED, 0.1)
replace TotalPA = round(TotalPA, 0.1)
replace LPA = round(LPA, 0.1)
replace MVPA = round(MVPA, 0.1)
replace VPA = round(VPA, 0.1)

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .

drop if SED == . & LPA == . & MVPA == . & TotalPA == .

rename bmi BMI
gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename smoke Smoke
recode Smoke (1=0) (2=1) (3=2)
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename EDUC Education_original
gen Education = Education_original
recode Education (1=1) (2=1) (3=1) (4=2) (5=2) (6=2)
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename basecvd CVD
label define yesnolbl 0 "No" 1 "Yes"
label values CVD yesnolbl

rename basecancer Cancer
label values Cancer yesnolbl

rename histdiab Diabetes
label values Diabetes yesnolbl

gen location = "USA"
gen accelerometer = "ActiGraph GT3X+ (right hip)"

order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA MVPA MVPA_active VPA Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer
save "Analysis files\WHS_with_missing.dta", replace





/* =============== */
/* ==== NNPAS ==== */
/* =============== */
use "Data files\NNPAS.dta",  clear

/* Only use data from KAN1 */
drop if study == 2

rename Internid ID
gen INCLUDE = 1

rename sex Gender
replace Gender = . if Gender == 0 /* One misclassified participant (1=female and 2=male in the original coding) */
recode Gender (1=0) (2=1)
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl

rename DOD Death

gen endfollow_up = mdy(12, 31, 2017)
format %tdD_m_Y endfollow_up
replace endfollow_up = STATUSDATO_DSF if !missing(STATUSDATO_DSF)
gen follow_up_years = (endfollow_up - startdate)/365.25

rename age Age
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

rename sed_per_day SED
rename light_per_day LPA
rename mod_per_day MPA
rename vig_per_day VPA
rename mvpa_per_day MVPA
gen TotalPA = LPA + MVPA

/* Round all PA variables to one decimal place */
replace SED = round(SED, 0.1)
replace TotalPA = round(TotalPA, 0.1)
replace LPA = round(LPA, 0.1)
replace MVPA = round(MVPA, 0.1)
replace VPA = round(VPA, 0.1)

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .


/* Fix some values that for some reason is defined not quite right... */
*replace VPA = 1.2 if ID == 6455 | ID == 1530 | ID == 5088 | ID == 4602 | ID == 4656 | ID == 893 | ID == 3969 | ID == 5943 | ID == 7100 | ID == 100 | ID == 3963 | ID == 3371 | ID == 688 | ID == 8260 | ID == 7965 | ID == 5457 | ID == 7081


gen BMI = weight/((height/100)^2)
gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename smoking Smoke
recode Smoke (1=2) (2=1) (3=0) (9=.)
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename education Education
recode Education (1=0) (2=0) (3=1) (4=1) (5=2) (6=2)
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename myocard MI
rename angina_pec Angina
rename stroke Stroke

gen CVD = 0
replace CVD = 1 if MI == 1 | Angina == 1 | Stroke == 1
replace CVD = . if MI == . & Angina == . & Stroke == .
label define yesnolbl 0 "No" 1 "Yes"
label values CVD yesnolbl

rename cancer Cancer
label values Cancer yesnolbl

gen Diabetes = .
replace Diabetes = 0 if diab1 == 0 & diab2 == 0
replace Diabetes = 1 if diab1 == 1 | diab2 == 1
label values Diabetes yesnolbl

gen location = "Norway"
gen accelerometer = "ActiGraph GT1M (right hip)"

/* Exclude participants with less than 10 hours/day for four days of weartime */
drop if weardays < 4 				/* (83 participants, 6 deaths) */
drop if weartime_tot < 2400 		/* (1 participant, 1 death) */

order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA VPA MVPA MVPA_active Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer
save "Analysis files\NNPAS_with_missing.dta", replace







/* ============================= */
/* ==== Tromsøundersøkelsen ==== */
/* ============================= */
use "Data files\Tromsø.dta", clear

/* Drop participants that are not included in the accelerometer-part of the study */
drop if STATUS_ACTI_OUT_T72 == .

/* Only include participants with valid accelerometer data */
drop if STATUS_ACTI_OUT_T72 ~= 1

gen ID = _n
gen INCLUDE = 1

rename SEX_T7 Gender
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl

gen Death = 0
replace Death = 1 if !missing(DATO_DOD)

gen end_date = mdy(12,31,2022)
format %tdD_m_Y end_date

gen dox = min(end_date, DATO_DOD, DATO_EMIGRERT_EM) 
format %tdD_m_Y dox

gen follow_up_years = (dox - ATTENDANCE_DATE_D1_T7)/365.25
order ID Gender Death follow_up_years ATTENDANCE_DATE_D1_T7 dox DATO_DOD DATO_EMIGRERT_EM 

rename AGE_T7 Age
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

rename ACTI_SED_MIN_DAY_CHOI_AL_T72 SED
rename ACTI_LIGHT_MIN_DAY_CHOI_AL_T72 LPA
rename ACTI_MVPA_MIN_DAY_CHOI_AL_T72 MVPA
gen TotalPA = LPA + MVPA
gen VPA = .

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .

/* Mobility problems: yes/no */
gen Mobilityproblems = .
replace Mobilityproblems = 0 if MOBILITY_T7 == 1
replace Mobilityproblems = 1 if MOBILITY_T7 > 1 & MOBILITY_T7 ~= .

drop if SED == . & LPA == . & MVPA == . & TotalPA == .

/* Round all PA variables to one decimal place */
replace SED = round(SED, 0.1)
replace TotalPA = round(TotalPA, 0.1)
replace LPA = round(LPA, 0.1)
replace MVPA = round(MVPA, 0.1)
replace VPA = round(VPA, 0.1)

gen BMI = WEIGHT_T7/((HEIGHT_T7/100)^2)
gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename SMOKE_DAILY_T7 Smoke
recode Smoke (1=2) (2=1) (3=0)
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename EDUCATION_T7 Education
recode Education (1=0) (2=1) (3=2) (4=2)
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename HEART_ATTACK_T7 HA
rename HEART_FAILURE_T7 HF
*rename ATRIAL_FIBRILLATION_T7 AF		/* Do not include due to questionable data quality */
rename ANGINA_T7 Angina
rename STROKE_T7 Stroke
rename CANCER_T7 Cancer
rename DIABETES_T7 Diabetes
label define yesnolbl 0 "No" 1 "Yes"

local vars = "HA HF Angina Stroke Cancer Diabetes"
foreach var in `vars' {
	recode `var' (2=1)				/* Set "Yes, previously" to "Yes" */
	label values `var' yesnolbl
}

gen CVD = 0
replace CVD = 1 if HA == 1 | HF == 1 | Angina == 1 | Stroke == 1
replace CVD = . if HA == . & HF == . & Angina == . & Stroke == .
label values CVD yesnolbl

gen location = "Norway"
gen accelerometer = "ActiGraph wGT3X-BT (right hip)"

order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA VPA MVPA MVPA_active Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer Mobilityproblems
save "Analysis files\Tromsø study_with_missing.dta", replace







/* ============== */
/* ==== UKBB ==== */
/* ============== */

use "Data files\UKBB.dta", clear

rename n_eid ID
gen INCLUDE = 1

drop s_*
drop n_*
drop ts_*
drop *_code*
drop day*recorded*
drop cutpoint*
drop acc*
drop weartime*

rename sex Gender
label define Genderlbl 0 "Female" 1 "Male"
label values Gender Genderlbl

rename mortstat Death
gen follow_up_years = (end_follow_up - end_date_ac_wear)/365.25
format follow_up_years %18.1f

rename age_ac Age
format Age %10.1f
gen AgeAbove60 = .
replace AgeAbove60 = 0 if Age < 60 & Age ~= .
replace AgeAbove60 = 1 if Age >= 60 & Age ~= .

/* Round all PA variables to one decimal place */
gen SED = round(ac_sed_minweek/7, 0.1)
gen LPA = round(ac_lpa_minweek/7, 0.1)
gen MVPA = round(ac_mvpa_minweek/7, 0.1)
gen VPA = round(ac_vpa_minweek/7, 0.1)
gen TotalPA = LPA + MVPA

/* Weartime */
gen Weartime = SED + TotalPA

/* Active vs inactive according to WHO recommendations */
gen MVPA_active = .
replace MVPA_active = 0 if MVPA < 22 & MVPA ~= .
replace MVPA_active = 1 if MVPA >= 22 & MVPA ~= .

/* Mobility problems: yes/no */
gen unable_walking = 1 if no_days_walking == -2
replace unable_walking = 0 if no_days_walking ~=-2 & no_days_walking ~= .

gen Mobilityproblems = 0
replace Mobilityproblems = 1 if disability == 1 | disability == 2 | disability == 3  
replace Mobilityproblems = 1 if unable_walking == 1

drop if SED == . & LPA == . & MVPA == . & TotalPA == .

rename bmi BMI
format BMI %8.1f
gen BMIabove30 = .
replace BMIabove30 = 0 if BMI < 30 & BMI ~= .
replace BMIabove30 = 1 if BMI >= 30 & BMI ~= .

rename smoking_status Smoke
label define Smokelbl 0 "Never" 1 "Former" 2 "Current"
label values Smoke Smokelbl

rename education Education
label define Educationlbl 0 "Primary" 1 "High School" 2 "University"
label values Education Educationlbl

rename prevalent_cvd_ac CVD
label define yesnolbl 0 "No" 1 "Yes"
label values CVD yesnolbl

rename prevalent_cancer_ac Cancer
label values Cancer yesnolbl

rename diabetes Diabetes
replace Diabetes = 0 if Diabetes == .
label values Diabetes yesnolbl

gen location = "UK"
gen accelerometer = "Axivity AX3 (wrist)"

order ID INCLUDE Gender Death follow_up_years Age AgeAbove60 SED TotalPA LPA MVPA MVPA_active VPA Weartime /*
	*/ BMI BMIabove30 Smoke Education CVD Cancer Diabetes location accelerometer Mobilityproblems
save "Analysis files\UKBB_with_missing.dta", replace



