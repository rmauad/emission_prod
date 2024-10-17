
***********************************
* Please change the path as needed
***********************************

use data/dta/Panel_complete.dta, replace

gl tables "output/tables"

*************************************************************************
* "Granger" causality - from factor productivity to overall productivity
*************************************************************************

eststo clear

global IV ener_inv ener_inv_lag1 ln_ener_prod_lag1 environ_prot_inv environ_prot_inv_lag1 cont_prev_inv cont_prev_inv_lag1 green_inv green_inv_lag1

foreach x in $DV {

*** No controls
capture quietly: xi: reghdfe debt_dummy `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
if _rc == 0 {
outreg2 using "$tables/reg_debt_`x'.tex", replace adjr2 keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for establishment FE
capture quietly: xi: reghdfe debt_dummy `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_debt_`x'.tex", append adjr2 keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe debt_dummy `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_debt_`x'.tex", append adjr2 keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe debt_dummy `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_debt_`x'.tex", adjr2 append keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}

