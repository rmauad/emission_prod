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

* Generating control variables
g lag1_ln_emp = ln(L.emp)
egen indust_code = group(indust)
g lag1_inv_inc = L.inv/L.y
g lag1_debt_dummy = L.debt_dummy

* Generating dependent variables for the Granger causality tests
by id: g dln_ener_prod = ln_ener_prod - L.ln_ener_prod
by id: g dln_prev_cont_prod = ln_prev_cont_prod - L.ln_prev_cont_prod
by id: g dln_prot_environ_prod = ln_prot_environ_prod - L.ln_prot_environ_prod
by id: g dln_green_prod = ln_green_prod - L.ln_green_prod

* Generating independent variables for the Granger causality tests
by id: g dln_lab_prod = ln_lab_prod - L.ln_lab_prod
by id: g dln_lab_prod_lag1 = L.dln_lab_prod

by id: g dln_lab_prod_factor = ln_lab_prod_factor - L.ln_lab_prod_factor
by id: g dln_lab_prod_factor_lag1 = L.dln_lab_prod_factor

by id: g dln_cap_prod = ln_cap_prod - L.ln_cap_prod
by id: g dln_cap_prod_lag1 = L.dln_cap_prod

by id: g dln_tfp = ln_tfp - L.ln_tfp
by id: g dln_tfp_lag1 = L.dln_tfp

by id: g dln_tfp_hassler = ln_tfp_hassler - L.ln_tfp_hassler
by id: g dln_tfp_hassler_lag1 = L.dln_tfp_hassler

*************************************************************************
* "Granger" causality - from overall productivity to factor productivity
*************************************************************************

eststo clear
**********************************
* Dependent variable dln_ener_prod
**********************************

* Indep: dln_lab_prod_lag1

capture quietly reghdfe dln_ener_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dep_dlp_noabs

capture quietly reghdfe dln_ener_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dep_dlp_id

capture quietly reghdfe dln_ener_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dep_dlp_year

capture quietly reghdfe dln_ener_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dep_dlp_id_year

* Indep: dln_lab_prod_factor_lag1

capture quietly reghdfe dln_ener_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dep_dlpf_noabs

capture quietly reghdfe dln_ener_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dep_dlpf_id

capture quietly reghdfe dln_ener_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dep_dlpf_year

capture quietly reghdfe dln_ener_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dep_dlpf_id_year

* Indep: dln_cap_prod_lag1

capture quietly reghdfe dln_ener_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dep_dcp_noabs

capture quietly reghdfe dln_ener_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dep_dcp_id

capture quietly reghdfe dln_ener_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dep_dcp_year

capture quietly reghdfe dln_ener_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dep_dcp_id_year

* Indep: dln_tfp_lag1

capture quietly reghdfe dln_ener_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dep_dt_noabs

capture quietly reghdfe dln_ener_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dep_dt_id

capture quietly reghdfe dln_ener_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dep_dt_year

capture quietly reghdfe dln_ener_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dep_dt_id_year

* Indep: dln_tfp_hassler_lag1

capture quietly reghdfe dln_ener_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dep_dth_noabs

capture quietly reghdfe dln_ener_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dep_dth_id

capture quietly reghdfe dln_ener_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dep_dth_year

capture quietly reghdfe dln_ener_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dep_dth_id_year

esttab dep_dlp_noabs dep_dlp_id dep_dlp_year dep_dlp_id_year dep_dlpf_noabs dep_dlpf_id dep_dlpf_year dep_dlpf_id_year dep_dcp_noabs dep_dcp_id dep_dcp_year dep_dcp_id_year dep_dt_noabs dep_dt_id dep_dt_year dep_dt_id_year dep_dth_noabs dep_dth_id dep_dth_year dep_dth_id_year using Results_dln_ener_prod.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

eststo clear
****************************************
* Dependent variable dln_prev_cont_prod
****************************************

* Indep: dln_lab_prod_lag1

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpc_dlp_noabs

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpc_dlp_id

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpc_dlp_year

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpc_dlp_id_year

* Indep: dln_lab_prod_factor_lag1

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpc_dlpf_noabs

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpc_dlpf_id

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpc_dlpf_year

capture quietly reghdfe dln_prev_cont_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpc_dlpf_id_year

* Indep: dln_cap_prod_lag1

capture quietly reghdfe dln_prev_cont_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpc_dcp_noabs

capture quietly reghdfe dln_prev_cont_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpc_dcp_id

capture quietly reghdfe dln_prev_cont_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpc_dcp_year

capture quietly reghdfe dln_prev_cont_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpc_dcp_id_year

* Indep: dln_tfp_lag1

capture quietly reghdfe dln_prev_cont_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpc_dt_noabs

capture quietly reghdfe dln_prev_cont_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpc_dt_id

capture quietly reghdfe dln_prev_cont_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpc_dt_year

capture quietly reghdfe dln_prev_cont_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpc_dt_id_year

* Indep: dln_tfp_hassler_lag1

capture quietly reghdfe dln_prev_cont_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpc_dth_noabs

capture quietly reghdfe dln_prev_cont_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpc_dth_id

capture quietly reghdfe dln_prev_cont_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpc_dth_year

capture quietly reghdfe dln_prev_cont_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpc_dth_id_year

esttab dpc_dlp_noabs dpc_dlp_id dpc_dlp_year dpc_dlp_id_year dpc_dlpf_noabs dpc_dlpf_id dpc_dlpf_year dpc_dlpf_id_year dpc_dcp_noabs dpc_dcp_id dpc_dcp_year dpc_dcp_id_year dpc_dt_noabs dpc_dt_id dpc_dt_year dpc_dt_id_year dpc_dth_noabs dpc_dth_id dpc_dth_year dpc_dth_id_year using Results_dln_prev_cont_prod.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

eststo clear
****************************************
* Dependent variable dln_prot_environ_prod
****************************************

* Indep: dln_lab_prod_lag1

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpep_dlp_noabs

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpep_dlp_id

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpep_dlp_year

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpep_dlp_id_year

* Indep: dln_lab_prod_factor_lag1

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpep_dlpf_noabs

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpep_dlpf_id

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpep_dlpf_year

capture quietly reghdfe dln_prot_environ_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpep_dlpf_id_year

* Indep: dln_cap_prod_lag1

capture quietly reghdfe dln_prot_environ_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpep_dcp_noabs

capture quietly reghdfe dln_prot_environ_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpep_dcp_id

capture quietly reghdfe dln_prot_environ_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpep_dcp_year

capture quietly reghdfe dln_prot_environ_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpep_dcp_id_year

* Indep: dln_tfp_lag1

capture quietly reghdfe dln_prot_environ_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpep_dt_noabs

capture quietly reghdfe dln_prot_environ_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpep_dt_id

capture quietly reghdfe dln_prot_environ_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpep_dt_year

capture quietly reghdfe dln_prot_environ_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpep_dt_id_year

* Indep: dln_tfp_hassler_lag1

capture quietly reghdfe dln_prot_environ_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dpep_dth_noabs

capture quietly reghdfe dln_prot_environ_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dpep_dth_id

capture quietly reghdfe dln_prot_environ_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dpep_dth_year

capture quietly reghdfe dln_prot_environ_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dpep_dth_id_year

esttab dpep_dlp_noabs dpep_dlp_id dpep_dlp_year dpep_dlp_id_year dpep_dlpf_noabs dpep_dlpf_id dpep_dlpf_year dpep_dlpf_id_year dpep_dcp_noabs dpep_dcp_id dpep_dcp_year dpep_dcp_id_year dpep_dt_noabs dpep_dt_id dpep_dt_year dpep_dt_id_year dpep_dth_noabs dpep_dth_id dpep_dth_year dpep_dth_id_year using Results_dln_prot_environ_prod.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

eststo clear
****************************************
* Dependent variable dln_green_prod
****************************************

* Indep: dln_lab_prod_lag1

capture quietly reghdfe dln_green_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dgp_dlp_noabs

capture quietly reghdfe dln_green_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dgp_dlp_id

capture quietly reghdfe dln_green_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dgp_dlp_year

capture quietly reghdfe dln_green_prod dln_lab_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dgp_dlp_id_year

* Indep: dln_lab_prod_factor_lag1

capture quietly reghdfe dln_green_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dgp_dlpf_noabs

capture quietly reghdfe dln_green_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dgp_dlpf_id

capture quietly reghdfe dln_green_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dgp_dlpf_year

capture quietly reghdfe dln_green_prod dln_lab_prod_factor_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dgp_dlpf_id_year

* Indep: dln_cap_prod_lag1

capture quietly reghdfe dln_green_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dgp_dcp_noabs

capture quietly reghdfe dln_green_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dgp_dcp_id

capture quietly reghdfe dln_green_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dgp_dcp_year

capture quietly reghdfe dln_green_prod dln_cap_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dgp_dcp_id_year

* Indep: dln_tfp_lag1

capture quietly reghdfe dln_green_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dgp_dt_noabs

capture quietly reghdfe dln_green_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dgp_dt_id

capture quietly reghdfe dln_green_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dgp_dt_year

capture quietly reghdfe dln_green_prod dln_tfp_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dgp_dt_id_year

* Indep: dln_tfp_hassler_lag1

capture quietly reghdfe dln_green_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dgp_dth_noabs

capture quietly reghdfe dln_green_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dgp_dth_id

capture quietly reghdfe dln_green_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dgp_dth_year

capture quietly reghdfe dln_green_prod dln_tfp_hassler_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dgp_dth_id_year

esttab dgp_dlp_noabs dgp_dlp_id dgp_dlp_year dgp_dlp_id_year dgp_dlpf_noabs dgp_dlpf_id dgp_dlpf_year dgp_dlpf_id_year dgp_dcp_noabs dgp_dcp_id dgp_dcp_year dgp_dcp_id_year dgp_dt_noabs dgp_dt_id dgp_dt_year dgp_dt_id_year dgp_dth_noabs dgp_dth_id dgp_dth_year dgp_dth_id_year using Results_dln_green_prod.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 
