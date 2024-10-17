***********************************
* Please change the path as needed 
***********************************

// ssc install distinct //In case needed

gl data "data/dta"
gl graphs "output/graphs"
gl excel "output/excel"

use "$data/Panel_complete.dta", clear

g ind_2 = substr(indust, 1, 2)
g ind_3 = substr(indust, 1, 3)
g ind_4 = substr(indust, 1, 4)

********************************************************
* Creating the "dirty" industries dummy (based on WIOD)
********************************************************

g dirty_75_90 = 0
g dirty_90 = 0

replace dirty_75_90 = 1 if inlist(ind_3, "111", "112")
replace dirty_75_90 = 1 if ind_3 == "113"
replace dirty_75_90 = 1 if ind_3 == "114"
replace dirty_75_90 = 1 if ind_2 == "21"
replace dirty_75_90 = 1 if ind_3 == "321"
replace dirty_75_90 = 1 if ind_3 == "322"
replace dirty_75_90 = 1 if ind_3 == "325"
replace dirty_75_90 = 1 if ind_3 == "562"
replace dirty_75_90 = 1 if inlist(ind_3, "484", "485", "486")
replace dirty_75_90 = 1 if inlist(ind_3, "491", "492", "493")

replace dirty_90 = 1 if ind_3 == "324"
replace dirty_90 = 1 if ind_3 == "327"
replace dirty_90 = 1 if ind_3 == "331"
replace dirty_90 = 1 if ind_3 == "221"
replace dirty_90 = 1 if ind_3 == "483"
replace dirty_90 = 1 if ind_3 == "481"

save "$data/Panel_industries.dta", replace
