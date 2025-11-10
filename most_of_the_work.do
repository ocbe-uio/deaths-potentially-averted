cd "[...]\Deaths Potentially Averted"
discard

local studies ""ABC" "HAI" "NHANES" "REGARDS" "WHS" "NNPAS" "Tromsø study" "UKBB""
local variables = "all"

local sensitivityanalyses ""Women" "Men" "AgeAbove60" "AgeBelow60" "NoAdjForBMI" "NoMobilityProblems" "ExcludeChronicDiseases" "ActiveInactive""
local sensitivityanalysesMA ""Scandinavia" "USA" `sensitivityanalyses'"
local sensitivityvariables = "MVPA"

local studiesplotsmaintext ""MA" "UKBB""
local variablesplotsmaintext = "all"


/* ---------------------------------------- */
/* Turn on/off analyses, plots, and reports */
/* ---------------------------------------- */
local analyze_each_cohort = 0
local analyze_each_cohort_sensitivity = 0
local create_MA_files = 0
local create_MA_files_sensitivity = 0
local meta_analyses = 0
local meta_analyses_sensitivity = 0

local plots_main_text = 0
local plots_each_cohort = 0
local plots_MA = 0
local plots_each_cohort_sensitivity = 0
local plots_MA_sensitivity = 0

local reports_by_cohorts = 0
local reports_by_cohorts_sensitivity = 0
local reports_MA = 0
local report_MA_sensitivity = 0




/* ================================ */
/* Analyze each cohort individually */
/* ================================ */

if `analyze_each_cohort' == 1 {
	foreach study in `studies' {
		analyze_cohorts_individually, study("`study'") variables("`variables'") sensitivity("none")
	}
}

if `analyze_each_cohort_sensitivity' == 1 {
	foreach sensitivity in `sensitivityanalyses' {
		foreach study in `studies' {
			analyze_cohorts_individually, study("`study'") variables("`sensitivityvariables'") sensitivity("`sensitivity'")
		}
	}
}



/* ========================== */
/* Create meta-analysis files */
/* ========================== */

if `create_MA_files' == 1 {
	create_meta_analysis_files, variables("`variables'") sensitivity("none") includeUKBB("no")
	create_meta_analysis_files, variables("`variables'") sensitivity("none") includeUKBB("yes")
}

if `create_MA_files_sensitivity' == 1 {
	foreach sensitivity in `sensitivityanalysesMA' {
		disp "Sensitivity: `sensitivity'"
		create_meta_analysis_files, variables("`sensitivityvariables'") sensitivity("`sensitivity'") includeUKBB("no")
	}
}



/* ============= */
/* Meta-analysis */
/* ============= */

if `meta_analyses' == 1 {
	meta_analysis, variables("`variables'") sensitivity("none") includeUKBB("no")
	meta_analysis, variables("`variables'") sensitivity("none") includeUKBB("yes")
}

if `meta_analyses_sensitivity' == 1 {
	foreach sensitivity in `sensitivityanalysesMA' {
		meta_analysis, variables("`sensitivityvariables'") sensitivity("`sensitivity'") includeUKBB("no")
	}
}



/* =========================================== */
/* Plot HRs and PIFs for the main article text */
/* =========================================== */

if `plots_main_text' == 1 {
	foreach study in `studiesplotsmaintext' {
		create_HR_and_PIF_plots, study("`study'") variables("`variablesplotsmaintext'") sensitivity("none") /*
			*/ models("2") maintext("yes")
	}
}



/* ================================================= */
/* Plot HRs and PIFs for the supplementary materials */
/* ================================================= */

if `plots_each_cohort' == 1 {
	foreach study in `studies' {
		create_HR_and_PIF_plots, study("`study'") variables("`variables'") sensitivity("none") models("1 2") maintext("no")
	}
}

if `plots_MA' == 1 {
	create_HR_and_PIF_plots, study("MA") variables("`variables'") sensitivity("none")  models("1 2") maintext("no") includeUKBB("no")
	create_HR_and_PIF_plots, study("MA") variables("`variables'") sensitivity("none")  models("1 2") maintext("no") includeUKBB("yes")
}

if `plots_each_cohort_sensitivity' == 1 {
	foreach sensitivity in `sensitivityanalyses' {
		if "`sensitivity'" == "ActiveInactive" continue
		foreach study in `studies' {
			create_HR_and_PIF_plots, study("`study'") variables("`sensitivityvariables'") sensitivity("`sensitivity'") /*
				*/ models("1 2") maintext("no")
		}
	}
}

if `plots_MA_sensitivity' == 1 {
	foreach sensitivity in `sensitivityanalysesMA' {
		if "`sensitivity'" == "ActiveInactive" continue
		create_HR_and_PIF_plots, study("MA") variables("`sensitivityvariables'") sensitivity("`sensitivity'") /*
			*/ models("1 2") maintext("no")
	}
	create_HR_and_PIF_plots, study("Joint") variables("`sensitivityvariables'") sensitivity("none") /*
		*/ models("1 2") maintext("no") includeUKBB("no")
}




/* ======================================================= */
/* Create reports with results from each individual cohort */
/* ======================================================= */

if `reports_by_cohorts' == 1 {
	create_reports_by_cohorts, studies("all") variables("all") sensitivity("none")
}

if `reports_by_cohorts_sensitivity' == 1 {
	foreach sensitivity in `sensitivityanalyses' {
		if "`sensitivity'" == "ActiveInactive" continue
		create_reports_by_cohorts, studies("all") variables("`sensitivityvariables'") sensitivity("`sensitivity'")
	}
}



/* ================================================== */
/* Create reports with results from the meta-analyses */
/* ================================================== */


if `reports_MA' == 1 {
	create_report_MA, variables("all") includeUKBB("no")
}

if `report_MA_sensitivity' == 1 {
	create_report_MA_sensitivity, variables("`sensitivityvariables'") sensitivity("all") includeUKBB("no")
}


