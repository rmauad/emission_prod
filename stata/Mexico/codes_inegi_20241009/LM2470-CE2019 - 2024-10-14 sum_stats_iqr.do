// Regressions for Census data

***********************************
* Please change the path as needed
***********************************
// ssc install splitvallabels, replace

gl graphs "Z:\Resultados\LM2470-CE2019-2024-10-14-Figuras"
gl tables "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"
gl path "Z:\Procesamiento\Trabajo\Temp"



gl data "Z:\Procesamiento\Trabajo\Temp"
gl excel "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"



*set mem 16g, permanently
use "$path/Panel_industries_oct2024.dta", replace
 *sample 5

**************************************************
* Please change to 2009, 2014, and 2019 if needed
**************************************************

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

save "$path/Panel_industries_no_outliers_oct2024.dta", replace

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


***************************************************
***************************************************
* Graph number of establishments by dirty industry (0-75%)
***************************************************
***************************************************


preserve

* Create ind_3_dirty
gen ind_3_dirty = ind_3 if (dirty_75_90 == 0 & dirty_90 == 0)
// replace ind_3_dirty = "" if dirty_75_90 == 1

* Count unique establishments per collapsed industry
bysort ind_3_dirty id: keep if _n == 1
collapse (count) num_unique_establishments_dirty = id, by(ind_3_dirty)

* Sort the data
gsort -num_unique_establishments_dirty

* Create labels for industries
label define industry_labels_dirty ///
461 "Grocery retail" ///
722 "Food & beverage services" ///
311 "Food industry" ///
332 "Metal products manufacturing" ///
465 "Stationery & personal items retail" ///
621 "Medical services" ///
337 "Furniture manufacturing" ///
434 "Agricultural wholesale" ///
561 "Business support services" ///
312 "Beverage & tobacco industry" ///
468 "Vehicle & fuel retail" ///
467 "Hardware retail" ///
463 "Textile & footwear retail" ///
713 "Recreational services" ///
462 "Department stores retail" ///
541 "Professional services" ///
531 "Real estate services" ///
431 "Grocery wholesale" ///
721 "Lodging services" ///
466 "Appliances & decor retail" ///
333 "Machinery manufacturing" ///
323 "Printing industry" ///
336 "Transportation equipment manufacturing" ///
315 "Apparel manufacturing" ///
237 "Non-metallic minerals manufacturing" ///
624 "Social assistance services" ///
622 "Hospitals" ///
532 "Rental services" ///
517 "Telecommunications" ///
469 "Catalog & TV retail" ///
433 "Pharmaceutical wholesale" ///
339 "Other manufacturing" ///
326 "Plastics & rubber industry" ///
314 "Textile manufacturing (non-apparel)"

* Convert string to numeric and apply labels
gen ind_3_dirty_num = real(ind_3_dirty)
label values ind_3_dirty_num industry_labels_dirty

xmlsave "$tables/dirty_ind" , doctype(excel) replace

* Create the horizontal bar plot
// graph hbar (asis) num_unique_establishments_dirty, over(ind_3_dirty_num, sort(1) descending label(angle(0) labsize(small)) axis(outergap(*100))) ///
graph hbar (asis) num_unique_establishments_dirty, over(ind_3_dirty_num, sort(1) descending label(angle(0) labsize(vsmall))) ///
    ytitle("Number of Establishments", size(vsmall)) ///
///    title("Establishments by Cleaner Industries (0-75%)", size(small)) ///
    ylabel(, angle(horizontal) labsize(vsmall) ) ///
    bar(1, color(navy)) ///
    scheme(s1color) 

restore

graph export "$graphs/est_by_ind_dirty_0_75.png", replace
