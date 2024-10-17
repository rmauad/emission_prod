
***********************************
* Please change the path as needed
***********************************

use data/dta/Panel_industries.dta, replace

gl tables "output/tables"

**************************************************************************************************
* Keep only "dirty" industries (75%-90% or above 90% of emissions/gross output according to WIOD)
**************************************************************************************************
keep if dirty_75_90 == 1
// keep if dirty_90 == 1

*************************************************************************
* "Granger" causality - from factor productivity to overall productivity
*************************************************************************

eststo clear

global DV dln_lab_prod dln_cap_prod dln_tfp dln_tfp_hassler

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", replace  keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

// *** Controlling for establishment FE
// capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
// if _rc == 0 {
// outreg2 using "$tables/reg_`y'.tex", append  keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
// }
//
// *** Controlling for year FE
// capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`y'.tex", append  keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
// }
//
// *** Controlling for establishment-year FE
// capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`y'.tex",  append keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
// }

}


*************************************************************************
* "Granger" causality - from overall productivity to factor productivity 
*************************************************************************

eststo clear

global IV dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 dln_tfp_hassler_lag1

foreach x in $IV {

*** No controls
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", replace  keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

// *** Controlling for establishment FE
// capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
// if _rc == 0 {
// outreg2 using "$tables/reg_`x'.tex", append  keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
// }
//
// *** Controlling for year FE
// capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`x'.tex", append  keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
// }
//
// *** Controlling for establishment-year FE
// capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`x'.tex",  append keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
// }

}


*********************************************************************************
* Please change the path as needed
* Now we redo the regressions with an interaction term ("dirty" industries dummy)
*********************************************************************************

use data/dta/Panel_industries.dta, replace

gl tables "output/tables"


*************************************************************************
* "Granger" causality - from factor productivity to overall productivity
*************************************************************************

eststo clear

global DV dln_lab_prod dln_cap_prod dln_tfp dln_tfp_hassler
global DIRTY dirty_75_90 dirty_90

foreach d in $DIRTY{
foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' c.dln_ener_prod_lag1##`d' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'_`d'.tex", replace  keep(dln_ener_prod_lag1 c.dln_ener_prod_lag1#`d' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

// *** Controlling for establishment FE
// capture quietly: xi: reghdfe `y' c.dln_ener_prod_lag1##dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
// if _rc == 0 {
// outreg2 using "$tables/reg_`y'_dirty_int.tex", append  keep(dln_ener_prod_lag1 c.dln_ener_prod_lag1#dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
// }
//
// *** Controlling for year FE
// capture quietly: xi: reghdfe `y' c.dln_ener_prod_lag1##dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`y'_dirty_int.tex", append  keep(dln_ener_prod_lag1 c.dln_ener_prod_lag1#dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
// }
//
// *** Controlling for establishment-year FE
// capture quietly: xi: reghdfe `y' c.dln_ener_prod_lag1##dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`y'_dirty_int.tex",  append keep(dln_ener_prod_lag1 c.dln_ener_prod_lag1#dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
// }

}
}


*************************************************************************
* "Granger" causality - from overall productivity to factor productivity 
*************************************************************************

eststo clear

global IV dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 dln_tfp_hassler_lag1

foreach d in $DIRTY{
foreach x in $IV {

*** No controls
capture quietly: xi: reghdfe dln_ener_prod c.`x'##`d' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`x'_`d'.tex", replace  keep(`x' c.`x'#`d' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

// *** Controlling for establishment FE
// capture quietly: xi: reghdfe dln_ener_prod c.`x'##dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
// if _rc == 0 {
// outreg2 using "$tables/reg_`x'_dirty_int.tex", append  keep(`x' c.`x'#dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
// }
//
// *** Controlling for year FE
// capture quietly: xi: reghdfe dln_ener_prod c.`x'##dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`x'_dirty_int.tex", append  keep(`x' c.`x'#dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
// }
//
// *** Controlling for establishment-year FE
// capture quietly: xi: reghdfe dln_ener_prod c.`x'##dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
// if _rc == 0 {
// outreg2 using "$tables/reg_`x'_dirty_int.tex",  append keep(`x' c.`x'#dirty_75_90 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
// }

}
}
