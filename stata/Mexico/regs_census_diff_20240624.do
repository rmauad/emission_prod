
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
capture quietly eststo: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

***********************************
* Dependent variable dln_cap_prod (dcp)
***********************************

* Indep: dln_ener_prod_lag1
capture quietly eststo: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

******************************
* Dependent variable dln_tfp (dt)
******************************

* Indep: dln_ener_prod_lag1
capture quietly eststo: xi: reghdfe dln_tfp dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_tfp dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_tfp dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_tfp dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

*************************************
* Dependent variable dln_tfp_hassler (dth)
*************************************

* Indep: dln_ener_prod_lag1
capture quietly eststo: xi: reghdfe dln_tfp_hassler dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_tfp_hassler dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_tfp_hassler dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_tfp_hassler dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/Results_dln_lab_prod_test.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_dln_lab_prod_test.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace
esttab using Results_dln_lab_prod.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_dln_lab_prod.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace
