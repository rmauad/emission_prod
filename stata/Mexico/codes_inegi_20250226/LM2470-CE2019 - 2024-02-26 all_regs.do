
***********************************
* Please change the path as needed
***********************************
//set mem 16g, permanently
// use data/dta/Panel_industries.dta, replace


// gl path "Z:\Procesamiento\Trabajo\Temp"
// gl tables "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"
// use "$path/Panel_industries_no_outliers_oct2024.dta", replace
// sample 5


gl path "data/dta"
gl tables "output/tables"
use "$path/Panel_industries_no_outliers_feb2025.dta", replace
// sample 5

g industXyear = indust*year

* Labeling variables
label var ln_ener_prod_lag1 "Energy Productivity (t-1)"
label var ln_emp_lag1 "Employment (t-1)"
label var debt_dummy_lag1 "Debt Dummy (t-1)"
label var inv_inc_lag1 "Investment/Income (t-1)"
label var ln_lab_prod "Labor Productivity"
label var ln_cap_prod "Capital Productivity"
label var ln_tfp "Total Factor Productivity"
label var industXyear "Industry x Year dummy"

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

*****************************************************************************
*****************************************************************************
* Benchmark - without establishment FE and with sectorXtime dummy
*****************************************************************************
*****************************************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

// global DV ln_lab_prod ln_cap_prod ln_tfp

*** No controls
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", replace label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, YES)
}

* 0-75%
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

*** No controls
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore


// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, YES)
}

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1

*** No controls
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, NO)
}

*** Controlling for year FE
capture quietly: xi: reghdfe ln_lab_prod ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(year)
if _rc == 0 {
outreg2 using "$tables/reg_benchmark_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, NO, Year FE, YES)
}

restore


***************************************************************************************
***************************************************************************************
* "Granger" causality - from factor productivity to overall productivity - Full sample
***************************************************************************************
***************************************************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

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


global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

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


global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

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


global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

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


***************************************************************************************
***************************************************************************************
***************************************************************************************
* "Granger" causality - dln
***************************************************************************************
***************************************************************************************
// use data/dta/Panel_industries.dta, replace
eststo clear

global DV dln_lab_prod dln_cap_prod dln_tfp_hassler

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


global DV dln_lab_prod dln_cap_prod dln_tfp_hassler

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


global DV dln_lab_prod dln_cap_prod dln_tfp_hassler

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


global DV dln_lab_prod dln_cap_prod dln_tfp_hassler

foreach y in $DV {

*** No controls
capture quietly: xi: reghdfe `y' dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 i.ind_2, noabs
if _rc == 0 {
outreg2 using "$tables/reg_`y'.tex", append label keep(dln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) addtext(Establishment FE, NO, Year FE, NO)

}
}

restore

***************************************************************************************
***************************************************************************************
* "Granger" causality - from factor productivity to overall productivity - Full sample WITH INDUSTRY YEAR DUMMY
***************************************************************************************
***************************************************************************************
// use data/dta/Panel_industries.dta, replace

eststo clear

global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

foreach y in $DV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", replace label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, NO)

}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, YES)
}

}

*************************************************************************************
* Keep only "dirty" industries (0-75% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)


global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

foreach y in $DV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, YES)
}

}
restore

*************************************************************************************
* Keep only "dirty" industries (75%-90% of emissions/gross output according to WIOD)
*************************************************************************************
// use data/dta/Panel_industries.dta, replace
preserve
keep if dirty_75_90 == 1


global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

foreach y in $DV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, YES)
}

}


***************************************************************************************
* Keep only "dirty" industries (Above 90% of emissions/gross output according to WIOD)
***************************************************************************************

// use data/dta/Panel_industries.dta, replace
restore
preserve
keep if dirty_90 == 1


global DV ln_lab_prod ln_cap_prod ln_tfp_hassler

foreach y in $DV {

*** Controlling for establishment FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, NO)
}

*** Controlling for establishment-year FE
capture quietly: xi: reghdfe `y' ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear i.ind_2, a(id year)
if _rc == 0 {
outreg2 using "$tables/reg_`y'_indYear.tex", append label keep(ln_ener_prod_lag1 ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1 industXyear) addtext(Establishment FE, YES, Year FE, YES)
}

}

restore
