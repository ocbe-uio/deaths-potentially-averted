cd "[...]\Deaths Potentially Averted"
discard

/* ------------- */
/* Preliminaries */
/* ------------- */
net install st0215_1			/* Install the packapge xblc, used to estimate HRs from Cox regression with splines */
set maxvar 20000, permanently


/* ------------------------------------------------------------------------------------ */
/* Create analysis files (and supplementary table of the construction of analysis sets) */
/* ------------------------------------------------------------------------------------ */
do create_analysis_files
do construction_of_analysis_sets
do create_joint_analysis_file


/* -------------------------------------------------------------------------------------------- */
/* Supplementary analysis: one-stage IPD meta-analysis approach                                 */
/* Do this before the main analyses, so that the results can be added to the sensitivity report */
/* created in "most_of_the_work.do"                                                             */
/* -------------------------------------------------------------------------------------------- */
do one_stage_IPD


/* ------------------------------------------------------------------------------------- */
/* Do most of the analyses and create most of the plots and reports                      */
/* (Some of the plots and reports are not included in the final supplementary materials) */
/* ------------------------------------------------------------------------------------- */
do most_of_the_work


/* --------------------------------- */
/* Main article: Table 1 and Table 2 */
/* --------------------------------- */
do Table1
do Table2


/* --------------------- */
/* Main article: Figures */
/* --------------------- */
do figures_main_text


/* -------------------------------------------------------------------------- */
/* Supplementary: Plots (and a table) of the distribution of the PA variables */
/* -------------------------------------------------------------------------- */
do distribution_of_PA_variables
do distribution_of_PA_variables_by_age_categories


/* ------------------------------------------------------------------------------------------ */
/* Supplementary: the HR and PIF plots that are included in the final supplementary materials */
/* ------------------------------------------------------------------------------------------ */
do create_final_supplementary_plots_all

/* This will create a document containing Supplementary Figures 1 - 15 */
do create_final_supplementary_figures

/* Supplementary Material #4 */
/* This information is given in the previously created document "Supplementary materials - MVPA in each cohort" */



/* -------------------------------------------------------- */
/* Print mean values of PA variables in different subgroups */
/* -------------------------------------------------------- */
do report_additional_summary_stats


/* ----------------- */
/* Assumption checks */
/* ----------------- */
do Cox_model_assumptions



