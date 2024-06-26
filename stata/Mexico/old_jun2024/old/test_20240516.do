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

capture quietly reghdfe at c.ae epXhigh, a(year)
eststo dln_lab_prod_dln_ener_prod_lag1_noabs
eststo test1

capture quietly reghdfe ae c.at epXhigh, a(year)
eststo test2
capture esttab test1 test2 using Results_dln_lab_prod.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

// sort year
// by year: summarize at ae epXhigh
// estout using "sum_stats.tex", replace

* Variables to summarize
local vars at ae epXhigh

* Generate summary statistics manually
egen mean_at = mean(at), by(year)
egen sd_at = sd(at), by(year)
egen min_at = min(at), by(year)
egen max_at = max(at), by(year)

egen mean_ae = mean(ae), by(year)
egen sd_ae = sd(ae), by(year)
egen min_ae = min(ae), by(year)
egen max_ae = max(ae), by(year)

egen mean_epXhigh = mean(epXhigh), by(year)
egen sd_epXhigh = sd(epXhigh), by(year)
egen min_epXhigh = min(epXhigh), by(year)
egen max_epXhigh = max(epXhigh), by(year)

* Keep one record per group
bysort year: gen tag = _n == 1
keep year tag mean_at sd_at mean_ae sd_ae
save summary_stats.dta, replace

use summary_stats.dta, clear
compress
export excel using "summary_statistics.xlsx", firstrow(variables) replace

graph box at ae epXhigh, over(year) title("test graph") 
graph export "test_graph.png", replace

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


* Clear existing stored estimates
eststo clear

* Initialize counter for unique naming

local depVarIndex = 1
* Loop over each combination of dependent and independent variables
foreach depVar in `depVars' {
	local indVarIndex = 1
	
    foreach indVar in `indVars' {
        eststo clear
        eststo model`counter': reghdfe `depVar' `indVar', noabs
        eststo model`counter': reghdfe `depVar' `indVar', a(new_id)
        eststo model`counter': reghdfe `depVar' `indVar', a(year)
        eststo model`counter': reghdfe `depVar' `indVar', a(new_id year)
		
		local fileName "regression_depVar${depVarIndex}_indVar${indVarIndex}"
		esttab using "${fileName}.tex", booktabs replace
		
		local ++indVarIndex
    }
	local ++ depVarIndex
}

* Output the results for all stored models after the loop
esttab model1, se star(* 0.10 ** 0.05 *** 0.01)
	
	
eststo clear
* Loop over each combination of dependent and independent variables
foreach depVar in `depVars' {
    local i = 1
    foreach indVar in `indVars' {
        * Adjust the independent variable in your model
        quietly eststo: reghdfe `depVar' `indVar', noabs
        quietly eststo: reghdfe `depVar' `indVar', a(new_id)
        quietly eststo: reghdfe `depVar' `indVar', a(year)
        quietly eststo: reghdfe `depVar' `indVar', a(new_id year)
       esttab, se star(* 0.10 ** 0.05 *** 0.01) 
        * Increment the index for the independent variables list
        local ++i
    }
}

* Output the results

