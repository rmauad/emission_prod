
***********************************
* Please change the path as needed
***********************************

use data/dta/Panel_complete.dta, replace

gl tables "output/tables"

*************************************************************************
* "Granger" causality - from factor productivity to overall productivity
*************************************************************************

eststo clear

global DV dln_lab_prod dln_cap_prod dln_tfp dln_tfp_hassler

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", replace adjr2 keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append adjr2 keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append adjr2 keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", adjr2 append keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}


*************************************************************************
* "Granger" causality - from overall productivity to factor productivity 
*************************************************************************

eststo clear

global IV dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 dln_tfp_hassler_lag1

foreach x in $IV {

*** No controls
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", replace adjr2 keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for establishment FE
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", append adjr2 keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", append adjr2 keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.indust, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", adjr2 append keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}
