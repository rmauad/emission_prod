
***********************************
* Please change the path as needed
***********************************

use data/dta/Panel_MuestraFicticia_complete.dta, clear

*******************************************************************
* Regressions of debt dummy on "green factor" productivity
*******************************************************************

* Indep: ener_inv
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy ener_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy ener_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy ener_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy ener_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_ener_inv.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_ener_inv.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_ener_inv.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_ener_inv.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: ener_inv_lag1
eststo clear
capture quietly eststo: xi: reghdfe ener_inv_lag1 debt_dummy_lag1 ln_emp_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe ener_inv_lag1 debt_dummy_lag1 ln_emp_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe ener_inv_lag1 debt_dummy_lag1 ln_emp_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe ener_inv_lag1 debt_dummy_lag1 ln_emp_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_ener_inv_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_ener_inv_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_ener_inv_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_ener_inv_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: ln_ener_prod_lag1
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_ener.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_ener.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: environ_prot_inv
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_environ.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_environ.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_environ.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_environ.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: environ_prot_inv_lag1
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy environ_prot_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_environ_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_environ_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_environ_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_environ_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: cont_prev_inv
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_cont.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_cont.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_cont.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_cont.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: cont_prev_inv_lag1
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy cont_prev_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_cont_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_cont_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_cont_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_cont_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: green_inv
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy green_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy green_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy green_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy green_inv ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_green.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_green.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_green.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_green.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

* Indep: green_inv_lag1
eststo clear
capture quietly eststo: xi: reghdfe debt_dummy green_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
estadd local fixed "No" , replace
capture quietly eststo: xi: reghdfe debt_dummy green_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
estadd local fixed "Entity" , replace
capture quietly eststo: xi: reghdfe debt_dummy green_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
estadd local fixed "Year" , replace
capture quietly eststo: xi: reghdfe debt_dummy green_inv_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
estadd local fixed "Entity and Year" , replace

// esttab using output/tex/debt_green_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
// esttab using output/tex/debt_green_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace

esttab using debt_green_lag1.tex, replace label se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01)
esttab using debt_green_lag1.csv, se stats(fixed N r2, label("Fixed effects")) star(* 0.10 ** 0.05 *** 0.01) replace
