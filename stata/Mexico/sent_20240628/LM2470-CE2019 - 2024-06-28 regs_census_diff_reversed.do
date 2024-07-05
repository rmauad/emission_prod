

***********************************
* Please change the path as needed
***********************************

use data/dta/Panel_MuestraFicticia_complete.dta, clear

*************************************************************************
* "Granger" causality - from overall productivity to factor productivity
*************************************************************************

eststo clear
**********************************
* Dependent variable dln_ener_prod
**********************************

* Indep: dln_lab_prod_lag1
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

* Indep: dln_cap_prod_lag1
capture quietly eststo: xi: reghdfe dln_ener_prod dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

* Indep: dln_tfp_lag1
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

* Indep: dln_tfp_hassler_lag1
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

* Indep: dln_tfp_lag1
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/Results_dln_ener_prod.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_dln_ener_prod.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using Results_dln_ener_prod.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_dln_ener_prod.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace
