// Regressions for Census data

***********************************
* Please change the path as needed
***********************************
// ssc install splitvallabels, replace

gl path "data/dta"
gl graphs "output/graphs"
gl tables "output/tables"

set mem 16g, permanently
use "$path/Panel_industries.dta", replace
* sample 10

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

save "$path/Panel_industries_no_outliers.dta", replace

********************************


gl data "data/dta"
gl graphs "output/graphs"
gl excel "output/excel"


*******************************
* Summary statistics - tables
*******************************

preserve
keep if year == $year1

* Establishments 2009
distinct id 
local nid = r(ndistinct) 
putexcel set "$excel/entry_exit_establishments.xlsx", replace
putexcel B1 = ("2009")
putexcel C1 = ("2014")
putexcel D1 = ("2019")
putexcel A2 = ("Total establishments")
putexcel B2 = `nid'

restore
preserve
keep if year == $year2

* Establishments 2014
distinct id 
local nid = r(ndistinct) 
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel C2 = `nid'

restore
preserve
keep if year == $year3

* Establishments 2019
distinct id 
local nid = r(ndistinct) 
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel D2 = `nid'

restore
preserve

* Count establishments present in both 2009 and 2014
egen tag2009 = tag(id) if year == $year1
egen tag2014 = tag(id) if year == $year2
collapse (sum) tag2009 tag2014, by(id)
by id: egen in_both = min(tag2009 * tag2014)
count if in_both == 1
local n_same = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel C3 = `n_same'

restore
preserve

* Count establishments present in both 2009 and 2014
egen tag2014 = tag(id) if year == $year2
egen tag2019 = tag(id) if year == $year3
collapse (sum) tag2014 tag2019, by(id)
by id: egen in_both = min(tag2014 * tag2019)
count if in_both == 1
local n_same = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel A3 = ("Establishments present from previous period (t-1)")
putexcel D3 = `n_same'

restore
preserve

* Count establishments present in both 2009 and 2019
egen tag2009 = tag(id) if year == $year1
egen tag2019 = tag(id) if year == $year3
collapse (sum) tag2009 tag2019, by(id)
by id: egen in_both = min(tag2009 * tag2019)
count if in_both == 1
local n_same = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel A4 = ("Establishments present from two periods ago (t-2)")
putexcel D4 = `n_same'

restore
preserve

* Count new establishments in 2014 wrt 2009
egen tag2009 = tag(id) if year == $year1
egen tag2014 = tag(id) if year == $year2
collapse (sum) tag2009 tag2014, by(id)
by id: egen new_2014 = max(1) if (tag2009 == 0 & tag2014 == 1)
count if new_2014 == 1
local n_new = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel A5 = ("New establishments since previous period (t-1)")
putexcel C5 = `n_new'

restore
preserve

* Count new establishments in 2019 wrt 2014
egen tag2014 = tag(id) if year == $year2
egen tag2019 = tag(id) if year == $year3
collapse (sum) tag2014 tag2019, by(id)
by id: egen new_2019 = max(1) if (tag2014 == 0 & tag2019 == 1)
count if new_2019 == 1
local n_new = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel D5 = `n_new'


restore
preserve

* Count new establishments in 2019 wrt 2009
egen tag2009 = tag(id) if year == $year1
egen tag2019 = tag(id) if year == $year3
collapse (sum) tag2009 tag2019, by(id)
by id: egen new_2019 = max(1) if (tag2009 == 0 & tag2019 == 1)
count if new_2019 == 1
local n_new = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel A6 = ("New establishments since two periods ago (t-2)")
putexcel D6 = `n_new'


restore
preserve

* Count exiting establishments in 2014 wrt 2009
egen tag2009 = tag(id) if year == $year1
egen tag2014 = tag(id) if year == $year2
collapse (sum) tag2009 tag2014, by(id)
by id: egen exit_2014 = max(1) if (tag2009 == 1 & tag2014 == 0)
count if exit_2014 == 1
local n_exit = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel A7 = ("Exiting establishments since previous period (t-1)")
putexcel C7 = `n_exit'

restore
preserve

* Count exiting establishments in 2019 wrt 2014
egen tag2014 = tag(id) if year == $year2
egen tag2019 = tag(id) if year == $year3
collapse (sum) tag2014 tag2019, by(id)
by id: egen exit_2019 = max(1) if (tag2014 == 1 & tag2019 == 0)
count if exit_2019 == 1
local n_exit = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel D7 = `n_exit'

restore
preserve

* Count exiting establishments in 2019 wrt 2009
egen tag2009 = tag(id) if year == $year1
egen tag2019 = tag(id) if year == $year3
collapse (sum) tag2009 tag2019, by(id)
by id: egen exit_2019 = max(1) if (tag2009 == 1 & tag2019 == 0)
count if exit_2019 == 1
local n_exit = r(N)
putexcel set "$excel/entry_exit_establishments.xlsx", modify
putexcel A8 = ("Exiting establishments since two periods ago (t-2)")
putexcel D8 = `n_exit'

restore


****************************
****************************
* Summary statistics table
****************************
****************************

**************
* Full sample
**************

* All years
estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace


* Only 2009
preserve
keep if year == $year1

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if year == $year2

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if year == $year3

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore

*******************************
* Only dirty industries 75-90%
*******************************

preserve
keep if dirty_75_90 == 1

* All years
estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore

* Only 2009
preserve
keep if dirty_75_90 == 1
keep if year == $year1

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_75_90 == 1
keep if year == $year2

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_75_90 == 1
keep if year == $year3

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_75_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore



*******************************
* Only dirty industries 90%+
*******************************

preserve
keep if dirty_90 == 1

* All years
estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore

* Only 2009
preserve
keep if dirty_90 == 1
keep if year == $year1

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_90 == 1
keep if year == $year2

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_90 == 1
keep if year == $year3

estpost summarize ln_ener_prod ln_lab_prod ln_cap_prod ln_tfp ln_emp inv_inc
esttab using "$tables/sum_stat_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore


*******************************
*******************************
* Dln summary statistics
*******************************
*******************************

************
* All years
************

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace


* Only 2009
preserve
keep if year == $year1

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if year == $year2

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if year == $year3

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore

*******************************
* Only dirty industries 75-90%
*******************************

* All years

preserve
keep if dirty_75_90 == 1

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_75_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore

* Only 2009
preserve
keep if dirty_75_90 == 1
keep if year == $year1

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_75_90_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_75_90 == 1
keep if year == $year2

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_75_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_75_90 == 1
keep if year == $year3

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_75_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore


*******************************
* Only dirty industries 90%+
*******************************

* All years

preserve
keep if dirty_90 == 1

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_90_all.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore

* Only 2009
preserve
keep if dirty_90 == 1
keep if year == $year1

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_90_2009.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2014
keep if dirty_90 == 1
keep if year == $year2

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_90_2014.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore
preserve

* Only 2019
keep if dirty_90 == 1
keep if year == $year3

estpost summarize dln_ener_prod dln_lab_prod dln_cap_prod dln_tfp
esttab using "$tables/sum_stat_dln_90_2019.tex", cells("mean(fmt(3)) sd(fmt(3)) min max") ///
noobs title("Summary Statistics") replace

restore


**********************************************
**********************************************
* Graph number of establishments by industry
**********************************************
**********************************************

preserve
* Collapse industries 31-33 and 48-49
gen ind_2_collapsed = ind_2
replace ind_2_collapsed = "31" if inlist(ind_2, "31", "32", "33")
replace ind_2_collapsed = "48" if inlist(ind_2, "48", "49")

* Count unique establishments per collapsed industry
bysort ind_2_collapsed id: keep if _n == 1
collapse (count) num_unique_establishments = id, by(ind_2_collapsed)

* Sort the data
gsort -num_unique_establishments

* Create labels for industries
label define industry_labels ///
11 "Agriculture, Forestry, Fishing & Hunting" ///
21 "Mining" ///
22 "Utilities" ///
23 "Construction" ///
31 "Manufacturing" ///
43 "Wholesale Trade" ///
46 "Retail Trade" ///
48 "Transportation & Warehousing" ///
51 "Information Media" ///
52 "Finance & Insurance" ///
53 "Real Estate & Rental Services" ///
54 "Professional & Technical Services" ///
55 "Corporate Management" ///
56 "Administrative & Waste Services" ///
61 "Educational Services" ///
62 "Healthcare & Social Assistance" ///
71 "Arts, Entertainment & Recreation" ///
72 "Accommodation & Food Services" ///
81 "Other Services (except Public Admin)" ///
93 "Public Administration & International Organizations"

* Convert string to numeric and apply labels
gen ind_2_num = real(ind_2_collapsed)
label values ind_2_num industry_labels

* Create the horizontal bar plot
graph hbar (asis) num_unique_establishments, over(ind_2_num, sort(1) descending label(angle(0) labsize(small))) ///
    ytitle("Number of Establishments") ///
    title("Number of Establishments by Industry") ///
    ylabel(, angle(horizontal)) ///
    bar(1, color(navy)) ///
    scheme(s1color)

restore

graph export "$graphs/est_by_ind.png", replace

***************************************************
***************************************************
* Graph number of establishments by dirty industry (75-90%)
***************************************************
***************************************************


preserve

* Create ind_3_dirty
gen ind_3_dirty = ind_3 if dirty_75_90 == 1
replace ind_3_dirty = "" if dirty_75_90 != 1

* Count unique establishments per collapsed industry
bysort ind_3_dirty id: keep if _n == 1
collapse (count) num_unique_establishments_dirty = id, by(ind_3_dirty)

* Sort the data
gsort -num_unique_establishments_dirty

* Create labels for industries
label define industry_labels_dirty ///
111 "Agriculture" ///
112 "Animal Breeding and Farming" ///
113 "Forestry" ///
114 "Fishing, Hunting and Trapping" ///
211 "Oil and Gas Extraction" ///
212 "Mining (except Oil and Gas)" ///
213 "Mining Support Services" ///
321 "Wood Product Manufacturing" ///
322 "Paper Manufacturing" ///
325 "Chemical Manufacturing" ///
484 "Truck Transportation" ///
485 "Passenger Transportation (ex. rail)" ///
486 "Pipeline Transportation" ///
491 "Postal Service" ///
492 "Couriers and Messengers" ///
493 "Warehousing and Storage" ///
562 "Waste Management"

* Convert string to numeric and apply labels
gen ind_3_dirty_num = real(ind_3_dirty)
label values ind_3_dirty_num industry_labels_dirty

* Create the horizontal bar plot
// graph hbar (asis) num_unique_establishments_dirty, over(ind_3_dirty_num, sort(1) descending label(angle(0) labsize(small)) axis(outergap(*100))) ///
graph hbar (asis) num_unique_establishments_dirty, over(ind_3_dirty_num, sort(1) descending label(angle(0) labsize(small))) ///
    ytitle("Number of Establishments") ///
    title("Establishments by Dirty Industry (75-90%)") ///
    ylabel(, angle(horizontal)) ///
    bar(1, color(navy)) ///
    scheme(s1color) ///

restore

graph export "$graphs/est_by_ind_dirty_75_90.png", replace


***************************************************
***************************************************
* Graph number of establishments by dirty industry (90%+)
***************************************************
***************************************************


preserve

* Create ind_3_dirty
gen ind_3_dirty = ind_3 if dirty_90 == 1
replace ind_3_dirty = "" if dirty_90 != 1

* Count unique establishments per collapsed industry
bysort ind_3_dirty id: keep if _n == 1
collapse (count) num_unique_establishments_dirty = id, by(ind_3_dirty)

* Sort the data
gsort -num_unique_establishments_dirty

* Create labels for industries
label define industry_labels_dirty ///
324 "Petroleum and Coal Products Manufacturing" ///
327 "Non-Metallic Mineral Products Manufacturing" ///
331 "Primary Metal Manufacturing" ///
221 "Utilities (Electricity, Water, Natural Gas)" ///
483 "Water Transportation" ///
481 "Air Transportation" ///

* Convert string to numeric and apply labels
gen ind_3_dirty_num = real(ind_3_dirty)
label values ind_3_dirty_num industry_labels_dirty

* Create the horizontal bar plot
// graph hbar (asis) num_unique_establishments_dirty, over(ind_3_dirty_num, sort(1) descending label(angle(0) labsize(small)) axis(outergap(*100))) ///
graph hbar (asis) num_unique_establishments_dirty, over(ind_3_dirty_num, sort(1) descending label(angle(0) labsize(small))) ///
    ytitle("Number of Establishments") ///
    title("Establishments by Dirty Industry (90% +)") ///
    ylabel(, angle(horizontal)) ///
    bar(1, color(navy)) ///
    scheme(s1color) ///

restore

graph export "$graphs/est_by_ind_dirty_90.png", replace


