// Regressions for Census data

******************************************************************************
* If needed, please install these packages before running the reghdfe command
******************************************************************************

// ssc install reghdfe, replace
// ssc install ftools, replace

***********************************
* Please change the path as needed
***********************************

use data/dta/Panel_MuestraFicticia.dta, clear
keep new_id year m000a h001d h114d q100a k412a o605 o606 h001a e17 o511a o511 a211a
replace o511a = o511 if missing(o511a)
drop o511

***********************************
* Variable description and renaming
************************************

//m000a: total income in thousand Pesos
//h001d: total hours worked in thousands
//h114d: total hours worked in thousands by people working in production (missing values for 2004 in Oscar's database.)
//q100a: total machines and equipment in thousand Pesos (fixed assets)
//k412a: total spending on electric energy in thousand Pesos (missing values for 2014 in Oscar's database.) 
//o605: total investment to prevent, reduce, or eliminate contamination (summed variables in 2019 and 2014 to join with 2009)
//o606: total spending on activities to protect the environment (summed variables in 2019 and 2014 to join with 2009)
//h001a: total employment
//e17: industry code
//o511a: debt dummy (total debt is unavailable)
//o511: debt dummy in 2009
//a211a: total investment

rename m000a y
rename h001d hours
rename h114d hours_prod
rename q100a k
rename k412a energ
rename o605 prev_cont
rename o606 prot_environ
rename h001a emp
rename e17 indust
rename o511a debt_dummy
rename a211a inv

****************************************************************************************************************************
* Generating variables/control variables: labor productivity, capital productivity, "green factor" productivity, size, etc.
****************************************************************************************************************************
egen id=group(new_id)
xtset id year

g ln_lab_prod = ln(y/hours) 
g ln_lab_prod_factor = ln(y/hours_prod) 
g ln_cap_prod = ln(y/k)
scalar alppha = 0.4
g ln_tfp =  ln(y) - alppha*ln(k) - (1-alppha)*ln(hours)

* Assuming the production function as in Hassler et al. (2021)
scalar ggamma = 0.5
scalar epsilon = 0.02
g ln_tfp_hassler = ln(y) - alppha*ln(k) - (1-alppha)*ln(hours) + (epsilon/(epsilon-1))*(ln(hours/y) - ln(1-alppha) - ln(1-ggamma)) // this is At in the paper
g ln_ener_prod = ln(y) - ln(energ) + (epsilon/(epsilon-1))*(ln(y/energ) - ln(ggamma)) // this is Ae in the paper

* Generating the "green factor" productivity measures
g ln_prev_cont_prod = ln(y/prev_cont)
g ln_prot_environ_prod = ln(y/prot_environ)
egen green = rowtotal(prev_cont prot_environ)
g ln_green_prod = ln(y/green)

* Generating dependent variables for the Granger causality tests
by id: g dln_lab_prod = ln_lab_prod - L.ln_lab_prod
by id: g dln_lab_prod_factor = ln_lab_prod_factor - L.ln_lab_prod_factor
by id: g dln_cap_prod = ln_cap_prod - L.ln_cap_prod
by id: g dln_tfp = ln_tfp - L.ln_tfp
by id: g dln_tfp_hassler = ln_tfp_hassler - L.ln_tfp_hassler

* Generating independent variables for the Granger causality tests
by id: g dln_ener_prod = ln_ener_prod - L.ln_ener_prod
by id: g dln_prev_cont_prod = ln_prev_cont_prod - L.ln_prev_cont_prod
by id: g dln_prot_environ_prod = ln_prot_environ_prod - L.ln_prot_environ_prod
by id: g dln_green_prod = ln_green_prod - L.ln_green_prod


*********************************
* Summary statistics - box plots
*********************************

graph box ln_lab_prod ln_lab_prod_factor ln_cap_prod ln_tfp ln_tfp_hassler, over(year) title("Overall productivity in logs")
graph export "overall_prod.png", replace

graph box ln_prev_cont_prod ln_prot_environ_prod ln_green_prod, over(year) title("Green factor productivity in logs")
graph export "green_prod.png", replace

graph box dln_lab_prod dln_lab_prod_factor dln_cap_prod dln_tfp dln_tfp_hassler, over(year) title("Overall productivity in log differences")
graph export "dln_overall_prod.png", replace

graph box dln_prev_cont_prod dln_prot_environ_prod dln_green_prod, over(year) title("Green factor productivity in log differences")
graph export "dln_green_prod.png", replace

*******************************
* Summary statistics - tables
*******************************

* Defining lists of variables
local vars_summary "ln_lab_prod ln_lab_prod_factor ln_cap_prod ln_tfp ln_tfp_hassler ln_prev_cont_prod ln_prot_environ_prod ln_green_prod dln_lab_prod dln_lab_prod_factor dln_cap_prod dln_tfp dln_tfp_hassler dln_prev_cont_prod dln_prot_environ_prod dln_green_prod"
foreach vars in `vars_summary' {
egen mean_`vars' = mean(`vars'), by(year)
egen sd_`vars' = sd(`vars'), by(year)
egen min_`vars' = min(`vars'), by(year)
egen max_`vars' = max(`vars'), by(year)
}

bysort year: gen tag = _n == 1

* Keep one record per group
local var_summary "ln_lab_prod ln_lab_prod_factor ln_cap_prod ln_tfp ln_tfp_hassler ln_prev_cont_prod ln_prot_environ_prod ln_green_prod dln_lab_prod dln_lab_prod_factor dln_cap_prod dln_tfp dln_tfp_hassler dln_prev_cont_prod dln_prot_environ_prod dln_green_prod"
local vars_to_keep "year tag"
foreach vars in `vars_summary' {
local vars_to_keep `vars_to_keep' mean_`vars' sd_`vars' min_`vars' max_`vars'
}

keep `vars_to_keep'
export delimited using "summary_statistics.csv", replace
