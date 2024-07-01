
***********************************
* Please change the path as needed
***********************************

use data/dta/Panel_MuestraFicticia_complete.dta, replace

*************************************************************************
* "Granger" causality - from factor productivity to overall productivity
*************************************************************************

eststo clear
**********************************
* Dependent variable dln_lab_prod (dlp)
**********************************

* Indep: dln_ener_prod_lag1 (dep)
capture quietly eststo: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_lab_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_lab_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_lab_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_lab_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

***********************************
* Dependent variable dln_cap_prod (dcp)
***********************************

* Indep: dln_ener_prod_lag1
eststo clear
capture quietly eststo: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_cap_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_cap_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_cap_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_cap_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

******************************
* Dependent variable dln_tfp (dt)
******************************

* Indep: dln_ener_prod_lag1
eststo clear
capture quietly eststo: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_tfp_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_tfp_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_tfp_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_tfp_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

*************************************
* Dependent variable dln_tfp_hassler (dth)
*************************************

* Indep: dln_ener_prod_lag1
eststo clear
capture quietly eststo: xi: reghdfe ln_tfp_hassler ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_tfp_hassler ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_tfp_hassler ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_tfp_hassler ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_tfph_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_tfph_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_tfph_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_tfph_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

