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

label variable at   "Productivity"
label variable ae   "Emission Productivity"
label variable high_ep_2005   "High EP 2005"
label variable atg   "Productivity Growth"
label variable epg   "Emission Productivity Growth"
label variable epXhigh   "Emission Productivity * High EP 2005"
label variable iea_pol_cum   "IEA policies cumulative"


// Regression without instrument (levels)
eststo: xtreg at c.ae epXhigh i.year, cluster(ind)
eststo: xtreg at c.ae epXhigh i.year, cluster(ind) //repeat just for the format of the table.
esttab using output/tex/ep_lev_noinst.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons) 

eststo: xtreg at c.ae epXhigh i.year, cluster(ind) //repeat just for the format of the table.
local depVars "at ae atg"
local indVars "epg epXhigh iea_pol_cum"
local depVarIndex = 1
local indVarIndex = 1
local `fileName' regression_depVar`depVarIndex'_indVar`indVarIndex'
display fileName.tex
esttab using "${fileName}.tex", booktabs replace

* Defining lists of variables

eststo clear

quietly eststo: reghdfe at c.ae epXhigh, noabs
quietly eststo: reghdfe at c.ae epXhigh, a(panelid)
quietly eststo: reghdfe at c.ae epXhigh, a(year)
quietly eststo: reghdfe at c.ae epXhigh, a(panelid year)
esttab using output/tex/test.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) 
esttab using output/tex/test.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

local depVars "at ae atg"
local indVars "epg epXhigh iea_pol_cum"

* Loop over each dependent variable
foreach depVar in `depVars' {
    * Loop over each independent variable
    foreach indVar in `indVars' {
        * Clear the stored estimates before running a new set of regressions
        quietly eststo clear

        * Run your regressions with different fixed effects specifications
        quietly eststo: reghdfe `depVar' `indVar', noabs
        quietly eststo: reghdfe `depVar' `indVar', a(panelid)
        quietly eststo: reghdfe `depVar' `indVar', a(year)
        quietly eststo: reghdfe `depVar' `indVar', a(panelid year)

        * Construct the filename based on the dependent and independent variable names
        local fileName = "`depVar'_`indVar'"

        * Use esttab to output the regression table to a TeX file, named according to the current variable combination
        esttab using "`fileName'.tex", replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

        * Optionally, display a message indicating completion of this combination
        display "Output for `depVar' regressed on `indVar' saved to `fileName'.tex"
    }
}

