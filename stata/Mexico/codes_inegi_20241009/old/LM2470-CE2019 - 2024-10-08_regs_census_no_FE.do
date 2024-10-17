
***********************************
* Please change the path as needed
***********************************
set mem 16g, permanently
// use data/dta/Panel_industries.dta, replace

gl path "data/dta"

use "$path/Panel_industries_no_outliers_oct2024.dta", replace

// sample 10

gl tables "output/tables"

* Labeling variables
label var ln_ener_prod_lag1 "Energy Productivity (t-1)"
label var ln_emp_lag1 "Employment (t-1)"
label var debt_dummy_lag1 "Debt Dummy (t-1)"
label var inv_inc_lag1 "Investment/Income (t-1)"
label var ln_lab_prod "Labor Productivity"
label var ln_cap_prod "Capital Productivity"
label var ln_tfp "Total Factor Productivity"

*****************************************************************************
*****************************************************************************
* Production function regressions
*****************************************************************************
*****************************************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_cap ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function.tex", replace label keep(ln_lab ln_cap ln_ener ) addtext(Establishment FE, NO, Year FE, NO)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_cap ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function.tex", append label keep(ln_lab ln_cap ln_ener) addtext(Establishment FE, NO, Year FE, NO)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_cap ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function.tex", append label keep(ln_lab ln_cap ln_ener ) addtext(Establishment FE, NO, Year FE, NO)
}

restore


**********************************************
* Production function with intermediate goods
**********************************************

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_int_prod ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function_int_prod.tex", replace label keep(ln_lab ln_int_prod ln_ener ) addtext(Establishment FE, NO, Year FE, NO)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_int_prod ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function_int_prod.tex", append label keep(ln_lab ln_int_prod ln_ener) addtext(Establishment FE, NO, Year FE, NO)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_int_prod ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function_int_prod.tex", append label keep(ln_lab ln_int_prod ln_ener ) addtext(Establishment FE, NO, Year FE, NO)
}

restore



*****************************************************************************
*****************************************************************************
* Benchmark - without establishment FE
*****************************************************************************
*****************************************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark.tex", replace label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

restore

**************************************************
* Benchmark - without establishment FE - capital
**************************************************

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_cap.tex", replace label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_cap.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_cap.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_cap.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_cap.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_cap.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

restore


**************************************************
* Benchmark - without establishment FE - inverted
**************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted.tex", replace label keep(ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted.tex", append label keep(ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted.tex", append label keep(ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted.tex", append label keep(ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted.tex", append label keep(ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted.tex", append label keep(ln_lab_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

restore

**************************************************
* Benchmark - without establishment FE - capital inverted
**************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted_cap.tex", replace label keep(ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted_cap.tex", append label keep(ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted_cap.tex", append label keep(ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted_cap.tex", append label keep(ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted_cap.tex", append label keep(ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_ener_prod ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_inverted_cap.tex", append label keep(ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, YES)
}

restore

***************************************************************************************
***************************************************************************************
* "Granger" causality - from factor productivity to overall productivity - Full sample
***************************************************************************************
***************************************************************************************
// use data/dta/Panel_industries.dta, replace
eststo clear

global DV ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", replace label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)

}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}

*************************************************************************************
* Keep only "dirty" industries (75%-90% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1


global DV ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}


***************************************************************************************
* Keep only "dirty" industries (Above 90% of emissions/gross output according to WIOD)
***************************************************************************************

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1


global DV ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}

restore
*****************************************************************************
*****************************************************************************
* "Granger" causality - inverted (energy productivity on labor productivity)
*****************************************************************************
*****************************************************************************

// use data/dta/Panel_industries.dta, replace
eststo clear

global IV ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 

foreach x in $IV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", replace label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex",  append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}


*************************************************************************************
* Keep only "dirty" industries (75%-90% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1


global IV ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 

foreach x in $IV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex",  append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}

*************************************************************************************
* Keep only "dirty" industries (75%-90% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1


global IV ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 

foreach x in $IV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex",  append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

}

restore

*****************************************************************************
*****************************************************************************
* Including other factors as independent variables
*****************************************************************************
*****************************************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_lab_prod_all_factors.tex", replace label keep(ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_lab_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_lab_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_lab_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_lab_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_lab_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

restore

*********************************************
* Capital productivity and all other factors
*********************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_cap_prod_all_factors.tex", replace label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_cap_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_cap_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_cap_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_cap_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_cap_prod ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_cap_prod_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

restore

****************************
* TFP and all other factors
****************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_tfp_all_factors.tex", replace label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_tfp_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_tfp_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_tfp_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_tfp_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_tfp ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_tfp_all_factors.tex", append label keep(ln_ener_prod_lag1 ln_lab_prod_lag1 ln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

restore

****************************
* Energ on all other factors
****************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_ener_prod_all_factors.tex", replace label keep(ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_ener_prod_all_factors.tex", append label keep(ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_ener_prod_all_factors.tex", append label keep(ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_ener_prod_all_factors.tex", append label keep(ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** Controlling for establishment FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_ln_ener_prod_all_factors.tex", append label keep(ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe ln_ener_prod ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_ln_ener_prod_all_factors.tex", append label keep(ln_lab_prod_lag1 ln_cap_prod_lag1 ln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, YES, Year FE, YES)
}

restore


***************************************************************************************




***************************************************************************************
***************************************************************************************
* "Granger" causality - dln
***************************************************************************************
***************************************************************************************
// use data/dta/Panel_industries.dta, replace
eststo clear

global DV dln_lab_prod dln_cap_prod dln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", replace label keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)

}
}


*************************************************************************************
* Keep only "dirty" industries (75%-90% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1


global DV dln_lab_prod dln_cap_prod dln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)

}
}


***************************************************************************************
* Keep only "dirty" industries (Above 90% of emissions/gross output according to WIOD)
***************************************************************************************

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1


global DV dln_lab_prod dln_cap_prod dln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)

}
}

restore

*****************************************************************************
*****************************************************************************
* "Granger" causality - inverted (dln energy productivity on labor productivity)
*****************************************************************************
*****************************************************************************

// use data/dta/Panel_industries.dta, replace
eststo clear

global IV dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 

foreach x in $IV {

*** No controls
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", replace label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}
}


*************************************************************************************
* Keep only "dirty" industries (75%-90% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1


global IV dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 

foreach x in $IV {

*** No controls
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}
}

*************************************************************************************
* Keep only "dirty" industries (75%-90% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1


global IV dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 

foreach x in $IV {

*** No controls
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}
}

restore
*****************************************************************************
*****************************************************************************
* Including other factors as independent variables
*****************************************************************************
*****************************************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_lab_prod_all_factors.tex", replace label keep(dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_lab_prod_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_lab_prod_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

restore

*********************************************
* Capital productivity and all other factors
*********************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_cap_prod_all_factors.tex", replace label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_cap_prod_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_cap_prod_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

restore

****************************
* TFP and all other factors
****************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe dln_tfp dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_tfp_all_factors.tex", replace label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_tfp dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_tfp_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_tfp dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_tfp_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

restore

****************************
* Energ on all other factors
****************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_ener_prod_all_factors.tex", replace label keep(dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_ener_prod_all_factors.tex", append label keep(dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_ener_prod_all_factors.tex", append label keep(dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

restore
