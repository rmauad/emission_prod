// Regressions of the productivity measures
// Same as reg_iv_dec20, but at the industry level
// See variables labels: codebook varname

use data/dta/df_cum.dta, clear

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

by panelid: g test = ln(L.ae)

// Label variables
gen epXhigh = ae*high_ep_2005


// Regression without instrument (levels)
eststo clear

capture quietly reghdfe at c.ae i.year, noabs
eststo noabs

capture quietly reghdfe at c.ae i.year, a(year)
eststo year

capture quietly reghdfe at c.ae i.year, a(panelid)
eststo id

capture quietly reghdfe at c.ae i.year, a(panelid year)
eststo idyear

esttab noabs year id idyear using output/tex/test.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) 

// Regression without instrument (levels)
eststo clear

capture quietly eststo: reghdfe at c.ae i.year, noabs
estadd local fixed "no" , replace
capture quietly eststo: reghdfe at c.ae i.year, a(year)
estadd local fixed "year" , replace
capture quietly eststo: reghdfe at c.ae i.year, a(panelid)
estadd local fixed "id" , replace
capture quietly eststo: reghdfe at c.ae i.year, a(panelid year)
estadd local fixed "year id" , replace

// capture quietly eststo: reghdfe c.ae i.year, noabs
// estadd local fixed "no" , replace
// capture quietly eststo: reghdfe c.ae i.year, a(year)
// estadd local fixed "year" , replace

esttab using output/tex/test.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)

esttab using output/tex/AllP.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace drop(*.year)
esttab using Results_dln_lab_prod.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

//stats(fixed N, label("Fixed effects"))
outreg2 noabs year id idyear using output/tex/test, replace excel dec(3)

* Stating FE in the output

sysuse auto, clear
eststo clear
eststo: xtreg weight length turn , fe i(rep78)
estadd local fixed "year" , replace
eststo: xtreg weight length turn , re i(rep78)
estadd local fixed "id" , replace
//esttab , cells(b) indicate(turn) s(fixed N, label("fixed effects"))
esttab , replace label se ar2 stats(fixed N, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
//esttab using output/tex/test.tex, replace label se ar2 stats(fixed N, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) 

