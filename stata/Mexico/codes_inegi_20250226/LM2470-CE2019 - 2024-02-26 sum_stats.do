// Regressions for Census data

***********************************
* Please change the path as needed
***********************************
// ssc install splitvallabels, replace
* ssc install binscatter


// gl graphs "Z:\Resultados\LM2470-CE2019-2024-10-14-Figuras"
// gl tables "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"
// gl path "Z:\Procesamiento\Trabajo\Temp"

// gl data "Z:\Procesamiento\Trabajo\Temp"
// gl excel "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"

// *set mem 16g, permanently
// use "$path/Panel_industries_feb2025.dta", replace
//  *sample 5


// WHEN RUNNING WITH THE FICTITIOUS DATA, REMEMBER TO COMMENT OUT THE PARTS WITH 90% + OF EMISSIONS (OTHERWISE, THERE ARE INSUFFICIENT OBSERVATIONS)

gl path "data/dta"
// gl data "data/dta"
gl graphs "output/graphs"
gl tables "output/tables"
gl excel "output/excel"

set mem 16g, permanently
use "$path/Panel_industries_feb2025.dta", replace
* sample 10


gl year1 1
gl year2 2
gl year3 3

************************
************************
* Dealing with outliers
***********************
***********************

g ln_emp = ln(emp)
g inv_inc = inv/y

* IQR-based outlier detection for specified variables
foreach var of varlist ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc {
    * Calculate quartiles
    quietly summarize `var', detail
   
    local q1 = r(p25)
    local q3 = r(p75)
    local iqr = `q3' - `q1'
   
    * Calculate fences
    local lower_fence = `q1' - 3 * `iqr'
    local upper_fence = `q3' + 3 * `iqr'
   
    * Generate outlier indicator
    generate `var'_outlier = (`var' < `lower_fence' | `var' > `upper_fence')
   
    * Label the new variable
    label variable `var'_outlier "`var' outlier (1 = outlier, 0 = not outlier)"
   
    * Display summary of outliers
    display "Outliers for `var':"
    tabulate `var'_outlier
}

* Create a single variable indicating if an observation is an outlier in any variable
egen any_outlier = rowmax(*_outlier)
label variable any_outlier "Outlier in any variable (1 = yes, 0 = no)"

* Display summary of observations with any outlier
display "Observations with outliers in any variable:"
tabulate any_outlier

* Dropping outliers
drop if any_outlier == 1

save "$path/Panel_industries_no_outliers_feb2025.dta", replace

********************************

/*
gl data "data/dta"
gl graphs "output/graphs"
gl excel "output/excel"
*/
****************************
****************************
* Summary statistics table
****************************
****************************

***************************************
* All establishments
***************************************


* All years
estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace


* Only 2009
preserve
keep if year == $year1

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if year == $year2

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if year == $year3

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore

***************************************
* Only "low" emission industries 0-75%
***************************************

preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

* All years
estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_0_75_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore

* Only 2009
preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)
keep if year == $year1

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_0_75_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if (dirty_75_90 == 0 & dirty_90 == 0)
keep if year == $year2

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_0_75_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if (dirty_75_90 == 0 & dirty_90 == 0)
keep if year == $year3

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_0_75_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore

*******************************
* Only dirty industries 75-90%
*******************************

preserve
keep if dirty_75_90 == 1

* All years
estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore

* Only 2009
preserve
keep if dirty_75_90 == 1
keep if year == $year1

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_75_90 == 1
keep if year == $year2

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_75_90 == 1
keep if year == $year3

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore



*******************************
* Only dirty industries 90%+
*******************************

preserve
keep if dirty_90 == 1

* All years
estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore

* Only 2009
preserve
keep if dirty_90 == 1
keep if year == $year1

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_90 == 1
keep if year == $year2

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))" ) ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_90 == 1
keep if year == $year3

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore


*******************************
*******************************
* Dln summary statistics
*******************************
*******************************

************
* All establishments
************

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace


preserve

* Only 2014
keep if year == $year2

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if year == $year3

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore

************
*only 0-75%
************

preserve
keep if (dirty_75_90 == 0 & dirty_90 == 0)

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_0_75_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace


restore
preserve

* Only 2014
keep if (dirty_75_90 == 0 & dirty_90 == 0)
keep if year == $year2

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_0_75_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if (dirty_75_90 == 0 & dirty_90 == 0)
keep if year == $year3

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_0_75_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore

*******************************
* Only dirty industries 75-90%
*******************************

* All years

preserve
keep if dirty_75_90 == 1

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_75_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_75_90 == 1
keep if year == $year2

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_75_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_75_90 == 1
keep if year == $year3

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_75_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore


*******************************
* Only dirty industries 90%+
*******************************

* All years

preserve
keep if dirty_90 == 1

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_90 == 1
keep if year == $year2

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_90 == 1
keep if year == $year3

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
noobs title("Summary Statistics") replace

restore


