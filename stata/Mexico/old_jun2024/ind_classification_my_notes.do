
use data/dta/Panel_MuestraFicticia_complete.dta, clear

distinct indust 
local numDistinct = r(ndistinct) 
putexcel set "distinct_firms_count.xlsx", replace
putexcel A1 = ("Number of distinct firms:")
putexcel A2 = `numDistinct'


*****************************************************************************
* If ln_ener_prod is not significantly skewed, using terciles to split is ok
*****************************************************************************

* Running industry classification
by year indust, sort: egen avr_ln_ener_prod = mean(ln_ener_prod)
by year indust, sort: egen med_ln_ener_prod = pctile(ln_ener_prod), p(50)
keep if year == 2009
keep indust avr_ln_ener_prod med_ln_ener_prod
rename avr_ln_ener_prod avr_ln_ener_prod_2009
rename med_ln_ener_prod med_ln_ener_prod_2009
duplicates drop 
save data/dta/avr_ln_ener_prod.dta, replace

use data/dta/Panel_MuestraFicticia_complete.dta, clear
merge m:1 indust using avr_ln_ener_prod.dta

* Running and saving the graph
kdensity avr_ln_ener_prod_2009, title("Average log of Energy Productivity in 2009")  xtitle("Average log of Energy Productivity") ytitle("Density")
graph export "density_avr_ln_energ_prod.png", replace


