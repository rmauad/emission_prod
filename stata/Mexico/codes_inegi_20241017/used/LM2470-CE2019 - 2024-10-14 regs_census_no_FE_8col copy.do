
***********************************
* Please change the path as needed
***********************************
//set mem 16g, permanently
// use data/dta/Panel_industries.dta, replace

gl path "Z:\Procesamiento\Trabajo\Temp"
gl tables "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"

use "$path/Panel_industries_no_outliers_oct2024.dta", replace

// sample 5


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

* 0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_cap ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function.tex", append label keep(ln_lab ln_cap ln_ener) addtext(Establishment FE, NO, Year FE, NO)
}

restore

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

* 0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

*** No controls
capture quietly: xi: reghdfe ln_y ln_lab ln_int_prod ln_ener i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_prod_function_int_prod.tex", append label keep(ln_lab ln_int_prod ln_ener) addtext(Establishment FE, NO, Year FE, NO)
}

restore

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

* 0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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
* Keep only "dirty" industries (0-75% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)


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
keep if (dirty_75_90 == 0 & dirty_90 == 0)


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
* Keep only "dirty" industries (90% of emissions/gross output according to WIOD)
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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

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
keep if (dirty_75_90 == 0 & dirty_90 == 0)


global DV dln_lab_prod dln_cap_prod dln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)

}
}
restore


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
keep if (dirty_75_90 == 0 & dirty_90 == 0)


global IV dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 

foreach x in $IV {

*** No controls
capture quietly: xi: reghdfe dln_ener_prod `x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`x'.tex", append label keep(`x' ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}
}
restore


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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

*** No controls
capture quietly: xi: reghdfe dln_lab_prod dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_lab_prod_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
restore

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

*** No controls
capture quietly: xi: reghdfe dln_cap_prod dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_cap_prod_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}

// use data/dta/Panel_industries.dta, replace
restore

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

*** No controls
capture quietly: xi: reghdfe dln_tfp dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_tfp_all_factors.tex", append label keep(dln_ener_prod_lag1 dln_lab_prod_lag1 dln_cap_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
restore

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

*0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

*** No controls
capture quietly: xi: reghdfe dln_ener_prod dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_dln_ener_prod_all_factors.tex", append label keep(dln_lab_prod_lag1 dln_cap_prod_lag1 dln_tfp_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)
}


// use data/dta/Panel_industries.dta, replace
restore

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


**************************************************************************************************
**************************************************************************************************
* Diff-in-diff: are industries "treated" by climate-change-mitigating policies more energy productive?
**************************************************************************************************
**************************************************************************************************

gl year1 1
gl year2 2
gl year3 3


g post_policy = 0
replace post_policy = 1 if (year == $year1 | year == $year2)
g treated_ind = 0
replace treated_ind = 1 if (ind_3 == "324" | ind_2 == "22" | ind_2 == "23" | ind_3 == "721")
// 324: Fabricación de productos derivados del petróleo y del carbón
// 22: Generación, transmisión, distribución y comercialización de energía eléctrica, suministro de agua y de gas natural por ductos al consumidor final
// 23: Construcción
// 721: Servicios de alojamiento temporal

eststo clear

global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", replace label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}


*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}

*** 0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)
global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}


*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}
restore

*** 75-90%
preserve
keep if dirty_75_90 == 1
global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}



capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}
restore


*** 90%+
preserve
keep if dirty_90 == 1
global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}


*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}
restore



**************************************************************************************************
**************************************************************************************************
* Diff-in-diff with a balanced panel
**************************************************************************************************
**************************************************************************************************


* Generate a variable to count appearances
bysort id: gen appearances = _N

* Keep only establishments that appear in all three years
keep if appearances == 3

* Drop the appearances variable
drop appearances


gl year1 1
gl year2 2
gl year3 3

replace post_policy = 0
replace post_policy = 1 if (year == $year1 | year == $year2)
replace treated_ind = 0
replace treated_ind = 1 if (ind_3 == "324" | ind_2 == "22" | ind_2 == "23" | ind_3 == "721")
// 324: Fabricación de productos derivados del petróleo y del carbón
// 22: Generación, transmisión, distribución y comercialización de energía eléctrica, suministro de agua y de gas natural por ductos al consumidor final
// 23: Construcción
// 721: Servicios de alojamiento temporal

eststo clear

global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", replace label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}


*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}

*** 0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)
global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}


*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}
restore

*** 75-90%
preserve
keep if dirty_75_90 == 1
global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}



capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}
restore


*** 90%+
preserve
keep if dirty_90 == 1
global DV ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, NO, Year FE, NO)
}


*** No controls
capture quietly: xi: reghdfe `y' post_policy##treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, a(id)
if _rc == 0 {
    outreg2 using "$tables/reg_iea_pol_balanced_`y'.tex", append label ///
    keep(1.post_policy 1.treated_ind 1.post_policy#1.treated_ind ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
    addtext(Establishment FE, YES, Year FE, NO)
}
}
restore




