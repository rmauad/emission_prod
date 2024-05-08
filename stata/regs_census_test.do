// Regressions of the productivity measures
// Same as reg_iv_dec20, but at the industry level
// See variables labels: codebook varname

use data/dta/df_cum.dta, clear
winsor2 ae, replace cut(1 99) trim

encode ind,gen(ind1)
drop ind
rename ind1 ind

encode year,gen(year1)
drop year
rename year1 year

encode COU,gen(COU1)
drop COU
rename COU1 COU

egen panelid = group(COU ind), label
xtset panelid year

// Label variables
gen epXhigh = ae*high_ep_2005

* first stage regression
xtreg ae iea_pol_cum i.year, fe
predict EP_instrument

*************************************************************************
* "Granger" causality - from factor productivity to overall productivity
*************************************************************************

* Define lists of variables
local depVars "epXhigh ae high_ep_2005"
local indVars "at iea_pol_cum EP_instrument"

* Begin document for storing results
// local allResults "All_Results.tex"
// file close myfile
// file open myfile using `allResults', write replace

* Write header for TeX document
file write myfile "\documentclass{article}\n\usepackage{booktabs}\n\begin{document}\n\begin{table}\n\centering"

* Loop over each dependent variable
foreach depVar in `depVars' {
    * Loop over each independent variable
    foreach indVar in `indVars' {
        quietly eststo clear
        * Run regressions with different fixed effects specifications
        capture quietly eststo noabs_`depVar'_`indVar': reghdfe `depVar' `indVar' , noabs
        capture quietly eststo panelid_`depVar'_`indVar': reghdfe `depVar' `indVar' , a(panelid)
        capture quietly eststo year_`depVar'_`indVar': reghdfe `depVar' `indVar' , a(year)
        capture quietly eststo id_year_`depVar'_`indVar': reghdfe `depVar' `indVar' , a(panelid year)

        * Store results for each combination in a block
        //local fileName "`depVar'_`indVar'"
		
        * Append results to the main TeX file
        //file read myfile2 using "`fileName'.tex", text
       // file write myfile "`myfile2'\n"
    }
}

esttab using noabs_epXhigh_at "All_results.tex", replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 
