// Regressions for Census data

***********************************
* Please change the path as needed
***********************************
// ssc install splitvallabels, replace
* ssc install binscatter


gl graphs "Z:\Resultados\LM2470-CE2019-2024-10-14-Figuras"
gl tables "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"
gl path "Z:\Procesamiento\Trabajo\Temp"

gl data "Z:\Procesamiento\Trabajo\Temp"
gl excel "Z:\Resultados\LM2470-CE2019-2024-10-14-Tablas"

*set mem 16g, permanently
use "$path/Panel_industries_oct2024.dta", replace
 *sample 5


/*
gl path "data/dta"
gl data "data/dta"
gl graphs "output/graphs"
gl tables "output/tables"
gl excel "output/excel"

set mem 16g, permanently
use "$path/Panel_industries_oct2024.dta", replace
* sample 10
*/

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
//
// preserve
// keep if dirty_90 == 1
//
// * All years
// estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
// esttab using "$tables/sum_stat_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
// noobs title("Summary Statistics") replace
//
// restore
//
// * Only 2009
// preserve
// keep if dirty_90 == 1
// keep if year == $year1
//
// estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
// esttab using "$tables/sum_stat_90_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
// noobs title("Summary Statistics") replace
//
// restore
// preserve
//
// * Only 2014
// keep if dirty_90 == 1
// keep if year == $year2
//
// estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
// esttab using "$tables/sum_stat_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))" ) ///
// noobs title("Summary Statistics") replace
//
// restore
// preserve
//
// * Only 2019
// keep if dirty_90 == 1
// keep if year == $year3
//
// estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
// esttab using "$tables/sum_stat_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
// noobs title("Summary Statistics") replace
//
// restore


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

// preserve
// keep if dirty_90 == 1
//
// estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
// esttab using "$tables/sum_stat_dln_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
// noobs title("Summary Statistics") replace
//
// restore
// preserve
//
// * Only 2014
// keep if dirty_90 == 1
// keep if year == $year2
//
// estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
// esttab using "$tables/sum_stat_dln_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
// noobs title("Summary Statistics") replace
//
// restore
// preserve
//
// * Only 2019
// keep if dirty_90 == 1
// keep if year == $year3
//
// estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
// esttab using "$tables/sum_stat_dln_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max count(fmt(0))") ///
// noobs title("Summary Statistics") replace
//
// restore


***************************************************
***************************************************
* Graph number of establishments by dirty industry (0-75%)
***************************************************
***************************************************


preserve

* Create ind_3_dirty
gen ind_3_dirty = ind_3 if (dirty_75_90 == 0 & dirty_90 == 0)
// replace ind_3_dirty = "" if dirty_75_90 == 1

drop if (ind_3_dirty == "222" | ind_3_dirty == "523" | ind_3_dirty == "313" | ind_3_dirty == "515" | ind_3_dirty == "432" | ind_3_dirty == "623" | ind_3_dirty == "335" | ind_3_dirty == "512" | ind_3_dirty == "511" | ind_3_dirty == "487" | ind_3_dirty == "115" | ind_3_dirty == "524" | ind_3_dirty == "334" | ind_3_dirty == "436" | ind_3_dirty == "519" | ind_3_dirty == "712" | ind_3_dirty == "469" | ind_3_dirty == "437" | ind_3_dirty == "518" | ind_3_dirty == "551" | ind_3_dirty == "533" | ind_3_dirty == "482")

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
314 "Textile manufacturing (non-apparel)" ///
811 "Repair and maintenance" ///
812 "Personal services" ///
611 "Education" ///
464 "Health product retail" ///
316 "Leather processing and products" ///
236 "Construction" ///
238 "Specialized construction" ///
435 "Wholesale of machinery and equipment" ///
813 "Associations and organizations" ///
522 "Non-stock financial institutions" ///
711 "Arts, culture, and sports" ///
488 "Transportation services"


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


***************************************************
***************************************************
* Binscatter plots between productivity measures 
* lagged and with control variables, like the regressions
***************************************************
***************************************************

*****************************
* all factors on ener_prod
*****************************
  
* Labor
binscatter ln_lab_prod ln_ener_prod_lag1, ///
  controls(ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Labor Productivity") ///
  xtitle("Log Energy Productivity(t-1)") ///
  title("Relationship between Labor Productivity and Energy (t-1)") ///
  note("Controls: ln(emp)(t-1), debt dummy(t-1), inv/inc(t-1)")
  
  graph export "$graphs/lab_ener_prod_binscatter.png", replace

  
binscatter ln_lab_prod ln_ener_prod_lag1, ///
  controls(ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
  absorb(id) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Labor Productivity") ///
  xtitle("Log Energy Productivity(t-1)") ///
  title("Relationship between Labor Productivity and Energy (t-1)") ///
  note("Controls: ln(emp)(t-1), debt dummy(t-1), inv/inc(t-1), establishment FE")

  graph export "$graphs/lab_ener_prod_binscatter_FE.png", replace


* Capital
binscatter ln_cap_prod ln_ener_prod_lag1, ///
  controls(ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Capital Productivity") ///
  xtitle("Log Energy Productivity(t-1)") ///
  title("Relationship between Capital Productivity and Energy (t-1)") ///
  note("Controls: ln(emp)(t-1), debt dummy(t-1), inv/inc(t-1)")
  
  graph export "$graphs/cap_ener_prod_binscatter.png", replace

  
binscatter ln_cap_prod ln_ener_prod_lag1, ///
  controls(ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
  absorb(id) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Capital Productivity") ///
  xtitle("Log Energy Productivity(t-1)") ///
  title("Relationship between Capital Productivity and Energy (t-1)") ///
  note("Controls: ln(emp)(t-1), debt dummy(t-1), inv/inc(t-1), establishment FE")

  graph export "$graphs/cap_ener_prod_binscatter_FE.png", replace
  
  
* TFP
binscatter ln_tfp ln_ener_prod_lag1, ///
  controls(ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log TFP") ///
  xtitle("Log Energy Productivity(t-1)") ///
  title("Relationship between TFP and Energy Productivity (t-1)") ///
  note("Controls: ln(emp)(t-1), debt dummy(t-1), inv/inc(t-1)")
  
  graph export "$graphs/tfp_ener_prod_binscatter.png", replace

  
binscatter ln_tfp ln_ener_prod_lag1, ///
  controls(ln_emp_lag1 debt_dummy_lag1 inv_inc_lag1) ///
  absorb(id) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log TFP") ///
  xtitle("Log Energy Productivity(t-1)") ///
  title("Relationship between TFP and Energy Productivity (t-1)") ///
  note("Controls: ln(emp)(t-1), debt dummy(t-1), inv/inc(t-1), establishment FE")

  graph export "$graphs/tfp_ener_prod_binscatter_FE.png", replace
  
  
***************************************************
***************************************************
* Binscatter plots between productivity measures 
* contemporaneous and no control variables, except for FE
***************************************************
***************************************************

*****************************
* ln_ener_prod on all others
*****************************
 
* Labor
binscatter ln_lab_prod ln_ener_prod, ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Labor Productivity") ///
  xtitle("Log Energy Productivity") ///
  title("Relationship between Labor and Energy Productivity")
 
  graph export "$graphs/lab_ener_prod_binscatter_contemp.png", replace

 

binscatter ln_lab_prod ln_ener_prod, ///
  absorb(id) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Labor Productivity") ///
  xtitle("Log Energy Productivity") ///
  title("Relationship between Labor and Energy Productivity") ///
  note("Controls: Establishment FE")

  graph export "$graphs/lab_ener_prod_binscatter_contemp_FE.png", replace


* Capital
binscatter ln_cap_prod ln_ener_prod, ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Capital Productivity") ///
  xtitle("Log Energy Productivity") ///
  title("Relationship between Capital and Energy Productivity")
 
  graph export "$graphs/cap_ener_prod_binscatter_contemp.png", replace

 

binscatter ln_cap_prod ln_ener_prod, ///
  absorb(id) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log Capital Productivity") ///
  xtitle("Log Energy Productivity") ///
  title("Relationship between Capital and Energy Productivity") ///
  note("Controls: Establishment FE")

  graph export "$graphs/cap_ener_prod_binscatter_contemp_FE.png", replace

  
* TFP
binscatter ln_tfp ln_ener_prod, ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log TFP") ///
  xtitle("Log Energy Productivity") ///
  title("Relationship TFP and Energy Productivity")
 
  graph export "$graphs/tfp_ener_prod_binscatter_contemp.png", replace


binscatter ln_tfp ln_ener_prod, ///
  absorb(id) ///
  nquantiles(20) ///
  lcolor(red) ///
  mcolor(navy) ///
  savedata(binscat_data) replace ///
  ytitle("Log TFP") ///
  xtitle("Log Energy Productivity") ///
  title("Relationship TFP and Energy Productivity") ///
  note("Controls: Establishment FE")

  graph export "$graphs/tfp_ener_prod_binscatter_contemp_FE.png", replace
