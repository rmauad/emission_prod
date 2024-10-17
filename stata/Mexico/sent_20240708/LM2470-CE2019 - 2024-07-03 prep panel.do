
***********************************
* Please change the path as needed
***********************************

use data/dta/Panel.dta, clear
keep id_uelm year m000a h001d h114d q100a k412a o605 o606 h001a e17 o511a o511 a211a
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
rename o605 cont_prev
rename o606 environ_prot
rename h001a emp
rename e17 indust
rename o511a debt_dummy
rename a211a inv

****************************************************************************************************************************
* Generating variables/control variables: labor productivity, capital productivity, "green factor" productivity, size, etc.
****************************************************************************************************************************
encode id_uelm,gen(id)
g year_str = string(year)

encode year_str,gen(year_panel)
drop year year_str
rename year_panel year


xtset id year

g ln_lab_prod = ln(y/hours) 
g ln_cap_prod = ln(y/k)
scalar alppha = 0.4
g ln_tfp =  ln(y) - alppha*ln(k) - (1-alppha)*ln(hours)

* Assuming the production function as in Hassler et al. (2021)
scalar ggamma = 0.5
scalar epsilon = 0.02
g ln_tfp_hassler = ln(y) - alppha*ln(k) - (1-alppha)*ln(hours) + (epsilon/(epsilon-1))*(ln(hours/y) - ln(1-alppha) - ln(1-ggamma)) // this is At in the paper
g ln_ener_prod = ln(y) - ln(energ) + (epsilon/(epsilon-1))*(ln(y/energ) - ln(ggamma)) // this is Ae in the paper
g ener_prod = exp(ln_ener_prod)

* Generating control variables
by id: g ln_emp_lag1 = ln(L.emp)
by id: g inv_inc_lag1 = L.inv/L.y
by id: g debt_dummy_lag1 = L.debt_dummy

* Generating dependent variables for the Granger causality tests
by id: g dln_lab_prod = ln_lab_prod - L.ln_lab_prod
by id: g dln_cap_prod = ln_cap_prod - L.ln_cap_prod
by id: g dln_tfp = ln_tfp - L.ln_tfp
by id: g dln_tfp_hassler = ln_tfp_hassler - L.ln_tfp_hassler

by id: g dln_lab_prod_lag1 = L.dln_lab_prod
by id: g dln_cap_prod_lag1 = L.dln_cap_prod
by id: g dln_tfp_lag1 = L.dln_tfp
by id: g dln_tfp_hassler_lag1 = L.dln_tfp_hassler

by id: g ln_lab_prod_lag1 = L.ln_lab_prod
by id: g ln_cap_prod_lag1 = L.ln_cap_prod
by id: g ln_tfp_lag1 = L.ln_tfp
by id: g ln_tfp_hassler_lag1 = L.ln_tfp_hassler

* Generating independent variables for the Granger causality tests
by id: g dln_ener_prod = ln_ener_prod - L.ln_ener_prod
by id: g dln_ener_prod_lag1 = L.dln_ener_prod

by id: g ln_ener_prod_lag1 = L.ln_ener_prod

* Generating variables for the debt regressions
g ener_inv = energ/inv
g environ_prot_inv = environ_prot/inv
g cont_prev_inv = cont_prev/inv
egen green = rowtotal(environ_prot cont_prev)
g green_inv = green/inv
by id: g ener_inv_lag1 = L.ener_inv
by id: g environ_prot_inv_lag1 = L.environ_prot_inv
by id: g cont_prev_inv_lag1 = L.cont_prev_inv
by id: g green_inv_lag1 = L.green_inv


save data/dta/Panel_complete.dta, replace
