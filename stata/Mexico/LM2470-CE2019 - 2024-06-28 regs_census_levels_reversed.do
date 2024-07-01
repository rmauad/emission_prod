

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

* Indep: ln_lab_prod_lag1
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_ener_lab.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_ener_lab.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_ener_lab.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_ener_lab.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace


* Indep: ln_cap_prod_lag1
eststo clear
capture quietly eststo: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_ener_cap.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_ener_cap.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_ener_cap.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_ener_cap.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: ln_tfp_lag1
eststo clear
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_ener_tfp.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_ener_tfp.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_ener_tfp.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_ener_tfp.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: ln_tfp_hassler_lag1
eststo clear
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_tfp_hassler_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_ener_tfph.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_ener_tfph.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_ener_tfph.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_ener_tfph.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: all
eststo clear
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

esttab using Results_ln_ener_prod.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using Results_ln_ener_prod.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

// esttab using output/tex/Results_ln_ener_prod.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/Results_ln_ener_prod.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace


