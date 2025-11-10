cd "[...]\Deaths Potentially Averted"
discard

local title "Supplementary materials: Distribution of PA variables"
local logfilename = "Supplementary materials - Distribution of PA variables - $S_DATE"

local studies ""ABC" "HAI" "NHANES" "REGARDS" "WHS" "NNPAS" "Tromsø study" "UKBB""
local variables ""MVPA" "LPA" "SED" "TotalPA""

local savefigures = 1
local createdocx = 1
local barcolor = "ltblue"
local barwidth = 0.80


if `createdocx' == 1 {
	putdocx begin, font(Calibri, 10) pagenum(decimal) header(header) footer(footer) /*
		*/ margin(left, 2.5cm) margin(right, 2.5cm) margin(top, 2.0cm) margin(bottom, 2.0cm)
	putdocx paragraph, toheader(header) halign(center) font(, 11)
	putdocx text ("`title'")
	putdocx paragraph, tofooter(footer) halign(center) font(, 11)
	putdocx pagenumber
}


local firstfigureonpage = 1
local page1 = 1
foreach variable in `variables' {
	disp "Working on: `variable'"

	foreach study in `studies' {
		disp "Study: `study'"
		use "Analysis files\\`study'.dta", clear
		
		quietly count if INCLUDE == 1
		local N = r(N)

		/* Options that work for most cases */
		local xtitle = "`variable', minutes/day"
		local yscale = "0,10"
		local yticks = "0(2)10"
	
		if "`variable'" == "MVPA" {
			local xfirst = 0
			local xlast = 100
			local dx = 2
			local xticks = "0(10)100"
			if "`study'" == "NHANES" local yscale = "0,20"
			else if "`study'" == "REGARDS" local yscale = "0,50"
			else local yscale = "0, 10"
			if "`study'" == "NHANES" local yticks = "0(5)20"
			else if "`study'" == "REGARDS" local yticks = "0(10)50"
			else local yticks = "0(2)10"
		}
		if "`variable'" == "LPA" {
			local xfirst = 0
			local xlast = 600
			local dx = 10
			local xticks = "0(50)600"
		}
		if "`variable'" == "SED" {
			local xfirst = 0
			local xlast = 1000
			local dx = 20
			local xticks = "0(100)1000"
		}
		if "`variable'" == "TotalPA" {
			local xtitle = "Total PA, minutes/day"
			local xfirst = 0
			local xlast = 600
			local dx = 10
			local xticks = "0(50)600"
		}
		
		local numintervals = (`xlast' - `xfirst')/`dx'

		
		matrix Proportions = J(`numintervals', 1, .)
		matrix x = J(`numintervals', 1, .)
		matrix numparticipants = J(`numintervals', 1, .)
		forvalues i = 1/`numintervals' {
			local x0 = `xfirst' + (`i'-1)*`dx'
			local x1 = `x0' + `dx'
			quietly count if `variable' >= `x0' & `variable' < `x1' & INCLUDE == 1
			local n = r(N)
			local percent: disp %4.1f 100*`n'/`N'
			matrix Proportions[`i',1] = `percent'
			matrix x[`i',1] = `x0' + 0.5*`dx'
			matrix numparticipants[`i',1] = `n'
		}
		
		svmat x
		svmat Proportions
		svmat numparticipants
		rename x1 x
		rename Proportions1 Proportions
		rename numparticipants1 numparticipants

		local width = `barwidth'*`dx'
		twoway bar Proportions x, barwidth(`width') color(`barcolor') /*
			*/ xtitle("`xtitle'", size(17pt) margin(medsmall)) /*
			*/ xscale(range(`xfirst', `xlast')) /*
			*/ xlabel(`xticks', labsize(14pt) nogrid) /*
			*/ ytitle("Percent of participants", size(17pt) margin(medsmall)) /*
			*/ yscale(range(`yscale')) /*
			*/ ylabel(`yticks', labsize(14pt) glpattern(solid)) /*
			*/ title("`study'", size(22pt)) /*
			*/ xsize(500pt) ysize(250pt) /*
			*/ graphregion(fcolor(white) margin(b-2 l-2))

		local filename = "Figures final supplementary\Distribution_`variable'_`study'"
		if `savefigures' == 1 graph export "`filename'.tif", replace
		
		if `createdocx' == 1 {
			if `firstfigureonpage' == 1 {
				if `page1' ~= 1 putdocx pagebreak
				putdocx paragraph
				local firstfigureonpage = 0
			}
			else local firstfigureonpage = 1			
			putdocx text (" "), linebreak(5)
			putdocx image "`filename'.tif", width(19cm)
			local page1 = 0
		}
	}
}

if `createdocx' == 1 putdocx save "Reports\\`logfilename'.docx", replace




