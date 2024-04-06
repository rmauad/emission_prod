// Regressions for Census data
// ssc install reghdfe, replace
// ssc install ftools, replace

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
encode new_id, gen(new_id_num)
xtset new_id_num year

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

* Generating control variables
g lag1_ln_emp = ln(L.emp)
encode indust, gen(indust_code)
g lag1_inv_inc = L.inv/L.y


***************
* Regressions 
***************

* Defining lists of variables
local depVars "ln_lab_prod ln_lab_prod_factor ln_cap_prod ln_tfp ln_tfp_hassler"
local indVars "ln_ener_prod ln_prev_cont_prod ln_prot_environ_prod ln_green_prod"

eststo clear
* Loop over each combination of dependent and independent variables
foreach depVar in `depVars' {
    local i = 1
    foreach indVar in `indVars' {
        * Adjust the independent variable in your model
        quietly eststo: reghdfe `depVar' `indVar' lag1_ln_emp indust_code debt_dummy lag1_inv_inc, noabs
        quietly eststo: reghdfe `depVar' `indVar' lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id)
        quietly eststo: reghdfe `depVar' `indVar' lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(year)
        quietly eststo: reghdfe `depVar' `indVar' lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id year)
        
        * Increment the index for the independent variables list
        local ++i
    }
}

* Output the results
esttab, se star(* 0.10 ** 0.05 *** 0.01)


* Labor productivity

eststo clear
quietly eststo:  reghdfe ln_lab_prod L.prev_cont_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, noabs
quietly eststo:  reghdfe ln_lab_prod L.prev_cont_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id)
quietly eststo:  reghdfe ln_lab_prod L.prev_cont_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(year)
quietly eststo:  reghdfe ln_lab_prod L.prev_cont_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id year)
esttab, se  starl(* 0.10 ** 0.05 *** 0.01) 
 
 
eststo clear
quietly eststo:  reghdfe ln_lab_prod L.prot_environ_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, noabs
quietly eststo:  reghdfe ln_lab_prod L.prot_environ_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id)
quietly eststo:  reghdfe ln_lab_prod L.prot_environ_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(year)
quietly eststo:  reghdfe ln_lab_prod L.prot_environ_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id year)
esttab, se  starl(* 0.10 ** 0.05 *** 0.01)


eststo clear
quietly eststo:  reghdfe ln_lab_prod L.green_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, noabs 
quietly eststo:  reghdfe ln_lab_prod L.green_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id)
quietly eststo:  reghdfe ln_lab_prod L.green_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(year)
quietly eststo:  reghdfe ln_lab_prod L.green_prod lag1_ln_emp indust_code debt_dummy lag1_inv_inc, a(new_id year)
esttab, se  starl(* 0.10 ** 0.05 *** 0.01)  
