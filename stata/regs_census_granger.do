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
by id: g dln_lab_prod = ln_lab_prod - L.ln_lab_prod
by id: g dln_lab_prod_factor = ln_lab_prod_factor - L.ln_lab_prod_factor
by id: g dln_cap_prod = ln_cap_prod - L.ln_cap_prod
by id: g dln_tfp = ln_tfp - L.ln_tfp
by id: g dln_tfp_hassler = ln_tfp_hassler - L.ln_tfp_hassler

* Generating independent variables for the Granger causality tests
by id: g dln_ener_prod = ln_ener_prod - L.ln_ener_prod
by id: g dln_ener_prod_lag1 = L.dln_ener_prod

by id: g dln_prev_cont_prod = ln_prev_cont_prod - L.ln_prev_cont_prod
by id: g dln_prev_cont_prod_lag1 = L.dln_prev_cont_prod

by id: g dln_prot_environ_prod = ln_prot_environ_prod - L.ln_prot_environ_prod
by id: g dln_prot_environ_prod_lag1 = L.dln_prot_environ_prod

by id: g dln_green_prod = ln_green_prod - L.ln_green_prod
by id: g dln_green_prod_lag1 = L.dln_green_prod

*************************************************************************
* "Granger" causality - from factor productivity to overall productivity
*************************************************************************

eststo clear
**********************************
* Dependent variable dln_lab_prod (dlp)
**********************************

* Indep: dln_ener_prod_lag1 (dep)
capture quietly reghdfe dln_lab_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlp_dep_noabs

capture quietly reghdfe dln_lab_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlp_dep_id

capture quietly reghdfe dln_lab_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlp_dep_year

capture quietly reghdfe dln_lab_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlp_dep_id_year

* Indep: dln_prev_cont_prod_lag1 (dpc)
capture quietly reghdfe dln_lab_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlp_dpc_noabs

capture quietly reghdfe dln_lab_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlp_dpc_id

capture quietly reghdfe dln_lab_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlp_dpc_year

capture quietly reghdfe dln_lab_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlp_dpc_id_year

* Indep: dln_prot_environ_prod_lag1 (dpep)
capture quietly reghdfe dln_lab_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlp_dpep_noabs

capture quietly reghdfe dln_lab_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlp_dpep_id

capture quietly reghdfe dln_lab_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlp_dpep_year

capture quietly reghdfe dln_lab_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlp_dpep_id_year

* Indep: dln_green_prod_lag1 (dgp)
capture quietly reghdfe dln_lab_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlp_dgp_noabs

capture quietly reghdfe dln_lab_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlp_dgp_id

capture quietly reghdfe dln_lab_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlp_dgp_year

capture quietly reghdfe dln_lab_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlp_dgp_id_year

esttab dlp_dep_noabs dlp_dep_id dlp_dep_year dlp_dep_id_year dlp_dpc_noabs dlp_dpc_id dlp_dpc_year dlp_dpc_id_year dlp_dpep_noabs dlp_dpep_id dlp_dpep_year dlp_dpep_id_year dlp_dgp_noabs dlp_dgp_id dlp_dgp_year dlp_dgp_id_year using Results_dln_lab_prod.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

eststo clear
*****************************************
* Dependent variable dln_lab_prod_factor (dlpf)
*****************************************

* Indep: dln_ener_prod_lag1
capture quietly reghdfe dln_lab_prod_factor dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlpf_dep_noabs

capture quietly reghdfe dln_lab_prod_factor dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlpf_dep_id

capture quietly reghdfe dln_lab_prod_factor dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlpf_dep_year

capture quietly reghdfe dln_lab_prod_factor dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlpf_dep_id_year

* Indep: dln_prev_cont_prod_lag1
capture quietly reghdfe dln_lab_prod_factor dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlpf_dpc_noabs

capture quietly reghdfe dln_lab_prod_factor dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlpf_dpc_id

capture quietly reghdfe dln_lab_prod_factor dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlpf_dpc_year

capture quietly reghdfe dln_lab_prod_factor dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlpf_dpc_id_year

* Indep: dln_prot_environ_prod_lag1

capture quietly reghdfe dln_lab_prod_factor dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlpf_dpep_noabs

capture quietly reghdfe dln_lab_prod_factor dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlpf_dpep_id

capture quietly reghdfe dln_lab_prod_factor dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlpf_dpep_year

capture quietly reghdfe dln_lab_prod_factor dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlpf_dpep_id_year

* Indep: dln_green_prod_lag1

capture quietly reghdfe dln_lab_prod_factor dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dlpf_dgp_noabs

capture quietly reghdfe dln_lab_prod_factor dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dlpf_dgp_id

capture quietly reghdfe dln_lab_prod_factor dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dlpf_dgp_year

capture quietly reghdfe dln_lab_prod_factor dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dlpf_dgp_id_year

esttab dlpf_dep_noabs dlpf_dep_id dlpf_dep_year dlpf_dep_id_year dlpf_dpc_noabs dlpf_dpc_id dlpf_dpc_year dlpf_dpc_id_year dlpf_dpep_noabs dlpf_dpep_id dlpf_dpep_year dlpf_dpep_id_year dlpf_dgp_noabs dlpf_dgp_id dlpf_dgp_year dlpf_dgp_id_year using Results_dln_lab_prod_factor.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

eststo clear
***********************************
* Dependent variable dln_cap_prod (dcp)
***********************************

* Indep: dln_ener_prod_lag1

capture quietly reghdfe dln_cap_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dcp_dep_noabs

capture quietly reghdfe dln_cap_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dcp_dep_id

capture quietly reghdfe dln_cap_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dcp_dep_year

capture quietly reghdfe dln_cap_prod dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dcp_dep_id_year

* Indep: dln_prev_cont_prod_lag1

capture quietly reghdfe dln_cap_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dcp_dpc_noabs

capture quietly reghdfe dln_cap_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dcp_dpc_id

capture quietly reghdfe dln_cap_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dcp_dpc_year

capture quietly reghdfe dln_cap_prod dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dcp_dpc_id_year

* Indep: dln_prot_environ_prod_lag1

capture quietly reghdfe dln_cap_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dcp_dpep_noabs

capture quietly reghdfe dln_cap_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dcp_dpep_id

capture quietly reghdfe dln_cap_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dcp_dpep_year

capture quietly reghdfe dln_cap_prod dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dcp_dpep_id_year

* Indep: dln_green_prod_lag1

capture quietly reghdfe dln_cap_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dcp_dgp_noabs

capture quietly reghdfe dln_cap_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dcp_dgp_id

capture quietly reghdfe dln_cap_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dcp_dgp_year

capture quietly reghdfe dln_cap_prod dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dcp_dgp_id_year

esttab dcp_dep_noabs dcp_dep_id dcp_dep_year dcp_dep_id_year dcp_dpc_noabs dcp_dpc_id dcp_dpc_year dcp_dpc_id_year dcp_dpep_noabs dcp_dpep_id dcp_dpep_year dcp_dpep_id_year dcp_dgp_noabs dcp_dgp_id dcp_dgp_year dcp_dgp_id_year using Results_dln_cap_prod.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

eststo clear
******************************
* Dependent variable dln_tfp (dt)
******************************

* Indep: dln_ener_prod_lag1
capture quietly reghdfe dln_tfp dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dt_dep_noabs

capture quietly reghdfe dln_tfp dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dt_dep_id

capture quietly reghdfe dln_tfp dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dt_dep_year

capture quietly reghdfe dln_tfp dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dt_dep_id_year

* Indep: dln_prev_cont_prod_lag1
capture quietly reghdfe dln_tfp dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dt_dpc_noabs

capture quietly reghdfe dln_tfp dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dt_dpc_id

capture quietly reghdfe dln_tfp dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dt_dpc_year

capture quietly reghdfe dln_tfp dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dt_dpc_id_year

* Indep: dln_prot_environ_prod_lag1
capture quietly reghdfe dln_tfp dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dt_dpep_noabs

capture quietly reghdfe dln_tfp dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dt_dpep_id

capture quietly reghdfe dln_tfp dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dt_dpep_year

capture quietly reghdfe dln_tfp dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dt_dpep_id_year

* Indep: dln_green_prod_lag1

capture quietly reghdfe dln_tfp dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dt_dgp_noabs

capture quietly reghdfe dln_tfp dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dt_dgp_id

capture quietly reghdfe dln_tfp dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dt_dgp_year

capture quietly reghdfe dln_tfp dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dt_dgp_id_year

esttab dt_dep_noabs dt_dep_id dt_dep_year dt_dep_id_year dt_dpc_noabs dt_dpc_id dt_dpc_year dt_dpc_id_year dt_dpep_noabs dt_dpep_id dt_dpep_year dt_dpep_id_year dt_dgp_noabs dt_dgp_id dt_dgp_year dt_dgp_id_year using Results_dln_tfp.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 

eststo clear
*************************************
* Dependent variable dln_tfp_hassler (dth)
*************************************

* Indep: dln_ener_prod_lag1
capture quietly reghdfe dln_tfp_hassler dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dth_dep_noabs

capture quietly reghdfe dln_tfp_hassler dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dth_dep_id

capture quietly reghdfe dln_tfp_hassler dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dth_dep_year

capture quietly reghdfe dln_tfp_hassler dln_ener_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dth_dep_id_year

* Indep: dln_prev_cont_prod_lag1
capture quietly reghdfe dln_tfp_hassler dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dth_dpc_noabs

capture quietly reghdfe dln_tfp_hassler dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dth_dpc_id

capture quietly reghdfe dln_tfp_hassler dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dth_dpc_year

capture quietly reghdfe dln_tfp_hassler dln_prev_cont_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dth_dpc_id_year

* Indep: dln_prot_environ_prod_lag1
capture quietly reghdfe dln_tfp_hassler dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dth_dpep_noabs

capture quietly reghdfe dln_tfp_hassler dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dth_dpep_id

capture quietly reghdfe dln_tfp_hassler dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dth_dpep_year

capture quietly reghdfe dln_tfp_hassler dln_prot_environ_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dth_dpep_id_year

* Indep: dln_green_prod_lag1
capture quietly reghdfe dln_tfp_hassler dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, noabs
eststo dth_dgp_noabs

capture quietly reghdfe dln_tfp_hassler dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id)
eststo dth_dgp_id

capture quietly reghdfe dln_tfp_hassler dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(year)
eststo dth_dgp_year

capture quietly reghdfe dln_tfp_hassler dln_green_prod_lag1 lag1_ln_emp indust_code lag1_debt_dummy lag1_inv_inc, a(id year)
eststo dth_dgp_id_year

esttab dth_dep_noabs dth_dep_id dth_dep_year dth_dep_id_year dth_dpc_noabs dth_dpc_id dth_dpc_year dth_dpc_id_year dth_dpep_noabs dth_dpep_id dth_dpep_year dth_dpep_id_year dth_dgp_noabs dth_dgp_id dth_dgp_year dth_dgp_id_year using Results_dln_tfp_hassler.tex, replace label se ar2 star(* 0.10 ** 0.05 *** 0.01) 
