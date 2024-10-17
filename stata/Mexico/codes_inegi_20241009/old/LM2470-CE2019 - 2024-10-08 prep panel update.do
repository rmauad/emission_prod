***********************************
* Please change the path as needed
***********************************
gl data "data/dta/"

use "$data/Panel_industries.dta", clear

rename a131a va

*********************************************************
* Creating variables to estimate the production function
*********************************************************

g ln_y = ln(y)
g ln_lab = ln(hours)
g ln_cap = ln(k)
g ln_ener = ln(energ)
g ln_int_prod = ln(y - va)

*****************************************
* Fixing the energy productivity measure
*****************************************

* Assuming the production function as in Hassler et al. (2021)
scalar ggamma = 0.5
scalar epsilon = 0.02

replace ln_ener_prod = ln(y) - ln(energ) + (epsilon/(epsilon-1))*(ln(energ/y) - ln(ggamma)) // this is Ae in the paper
replace ener_prod = exp(ln_ener_prod)

* Generating independent variables for the Granger causality tests
by id: replace dln_ener_prod = ln_ener_prod - L.ln_ener_prod
by id: replace dln_ener_prod_lag1 = L.dln_ener_prod
by id: replace ln_ener_prod_lag1 = L.ln_ener_prod

save "$data/Panel_industries_oct2024.dta", replace
