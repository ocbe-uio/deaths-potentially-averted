cd "[...]\Deaths Potentially Averted"
discard


/* Figure 4: MVPA */
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("none") models("1") delta("5") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("none") models("1") delta("5") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("none") models("1") delta("10") panelHR("e") panelPIF("f")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("none") models("1") delta("10") panelHR("g") panelPIF("h")


/* Figure 5: LPA */
create_final_supplementary_plots, study("MA") variable("LPA") sensitivity("none") models("2") delta("30") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("UKBB") variable("LPA") sensitivity("none") models("2") delta("30") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("MA") variable("LPA") sensitivity("none") models("2") delta("60") panelHR("e") panelPIF("f")
create_final_supplementary_plots, study("UKBB") variable("LPA") sensitivity("none") models("2") delta("60") panelHR("g") panelPIF("h")


/* Figure 6: SED */
create_final_supplementary_plots, study("MA") variable("SED") sensitivity("none") models("1") delta("-30") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("UKBB") variable("SED") sensitivity("none") models("1") delta("-30") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("MA") variable("SED") sensitivity("none") models("1") delta("-60") panelHR("e") panelPIF("f")
create_final_supplementary_plots, study("UKBB") variable("SED") sensitivity("none") models("1") delta("-60") panelHR("g") panelPIF("h")


/* Figure 7: Total PA */
create_final_supplementary_plots, study("MA") variable("TotalPA") sensitivity("none") models("2") delta("30") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("UKBB") variable("TotalPA") sensitivity("none") models("2") delta("30") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("MA") variable("TotalPA") sensitivity("none") models("2") delta("60") panelHR("e") panelPIF("f")
create_final_supplementary_plots, study("UKBB") variable("TotalPA") sensitivity("none") models("2") delta("60") panelHR("g") panelPIF("h")


/* Figure 8: Sensitivity (MVPA, 5 min, fully adjusted) - women, men, age <> 60 years */
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("women") models("2") delta("5") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("men") models("2") delta("5") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("AgeAbove60") models("2") delta("5") panelHR("e") panelPIF("f")
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("AgeBelow60") models("2") delta("5") panelHR("g") panelPIF("h")


/* Figure 9: Sensitivity (MVPA, 5 min, fully adjusted) - BMI, Mobility, Scandinavia, USA */
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("NoAdjForBMI") models("2") delta("5") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("5") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("Scandinavia") models("2") delta("5") panelHR("e") panelPIF("f")
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("USA") models("2") delta("5") panelHR("g") panelPIF("h")


/* Figure 10: Sensitivity (MVPA, 5 min, fully adjusted) - MA: No chronic disesases */
create_final_supplementary_plots, study("MA") variable("MVPA") sensitivity("ExcludeChronicDiseases") models("2") delta("5") panelHR("a") panelPIF("b")


/* Figure 11: Sensitivity (MVPA, 5 min, fully adjusted) - UKBB: women, men, age <> 60 years  */
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("women") models("2") delta("5") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("men") models("2") delta("5") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("AgeAbove60") models("2") delta("5") panelHR("e") panelPIF("f")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("AgeBelow60") models("2") delta("5") panelHR("g") panelPIF("h")


/* Figure 12: Sensitivity (MVPA, 5 min, fully adjusted) - UKBB: BMI, Mobility, no chronic diseases  */
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("NoAdjForBMI") models("2") delta("5") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("5") panelHR("c") panelPIF("d")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("ExcludeChronicDiseases") models("2") delta("5") panelHR("e") panelPIF("f")


/* Figure 13: Sensitivity (MVPA, 5 min, fully adjusted) - Mobility in individual studes: NHANES, Tromsø, UKBB */
create_final_supplementary_plots, study("NHANES") variable("MVPA") sensitivity("none") models("2") delta("5") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("NHANES") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("5") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("NHANES") variable("MVPA") sensitivity("none") models("2") delta("10") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("NHANES") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("10") panelHR(" ") panelPIF(" ")

create_final_supplementary_plots, study("Tromsø study") variable("MVPA") sensitivity("none") models("2") delta("5") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("Tromsø study") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("5") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("Tromsø study") variable("MVPA") sensitivity("none") models("2") delta("10") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("Tromsø study") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("10") panelHR(" ") panelPIF(" ")

create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("none") models("2") delta("5") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("5") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("none") models("2") delta("10") panelHR(" ") panelPIF(" ")
create_final_supplementary_plots, study("UKBB") variable("MVPA") sensitivity("NoMobilityProblems") models("2") delta("10") panelHR(" ") panelPIF(" ")


/* Figure 14: Sensitivity (MVPA, 5 min & 10 min, fully adjusted) - one-stage MA, inactive -> active */
create_final_supplementary_plots, study("Joint") variable("MVPA") sensitivity("none") models("2") delta("5") panelHR("a") panelPIF("b")
create_final_supplementary_plots, study("Joint") variable("MVPA") sensitivity("none") models("2") delta("10") panelHR("c") panelPIF("d")




