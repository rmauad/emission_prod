// Regressions of the productivity measures
// Same as reg_iv_dec20, but at the industry level
// See variables labels: codebook varname

use data/dta/df_pol_feb2025.dta, clear //from prep_dta_feb2025.R
winsor2 ae, replace cut(1 99) trim

encode ind,gen(ind1)
drop ind
rename ind1 ind

encode year,gen(year1)
drop year
rename year1 year

encode COU,gen(COU1)
drop COU
rename COU1 COU

egen panelid = group(COU ind), label
xtset panelid year

// Label variables
gen epXhigh = ae*high_ep_2005

label variable at   "Productivity"
label variable ae   "Emission Productivity"
label variable high_ep_2005   "High EP 2005"
label variable atg   "Productivity Growth"
label variable epg   "Emission Productivity Growth"
label variable epXhigh   "Emission Productivity * High EP 2005"
label variable iea_pol_count   "IEA policy count"


// // Regression without instrument (levels)
// eststo: xtreg at c.ae epXhigh i.year, cluster(ind)
// eststo: xtreg at c.ae epXhigh i.year, cluster(ind) //repeat just for the format of the table.
// esttab using output/tex/ep_lev_noinst.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons) 
//
// //tabulate year, generate(dyear) - creating dummies from categorical variable
// //xtreg ep_euk_usd iea_pol_cum dyear2 dyear3 dyear4 dyear5 dyear6 dyear7 dyear8 dyear9 dyear10, fe
// //test iea_pol_cum dyear2 dyear3 dyear4 dyear5 dyear6 dyear7 dyear8 dyear9 dyear10
//
// // Regression with IEA policy as instrument (levels). Need to bootstrap the standard errors because we're using an estimate as a regressor.
// capture program drop ep2sls
// program ep2sls
// * first stage regression
// xtreg ae iea_pol_cum i.year, fe // it doesn't make sense to include coutry FE here, since iea_pol_cum only varies across countries.
// * get predicted values
// predict EP_instrument
// * second stage regression
// gen EP_instrumentXhigh_ep_2005 = EP_instrument*high_ep_2005
// xtreg at c.EP_instrument EP_instrumentXhigh_ep_2005 i.year, cluster(ind)
// drop EP_instrument
// drop EP_instrumentXhigh_ep_2005
// end
//
// eststo clear
// xtreg ae iea_pol_cum i.year, fe
// esttab using output/tex/ep_lev_inst1.tex, replace label se ar2 stats(N F) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons) scalar(F)
//
// bootstrap, reps(200): ep2sls
// esttab using output/tex/ep_lev_inst2.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons)

*********************
// Bartik instrument
*********************

gen epgXhigh = epg*high_ep_2005
gen iea_polXavr_em_2005 = iea_pol_count*avr_emissions_2005
gen atg_stock_perc = atg_stock*100
label variable epgXhigh   "EP growth * High EP 2005"
label variable iea_polXavr_em_2005   "IEA policies * Avr emissions 2005"

// With instrument
capture program drop epg2sls
program epg2sls
* first stage regression
xtreg ae iea_polXavr_em_2005 iea_pol_count, fe
* get predicted values
predict EP_instrument
* second stage regression
gen EP_instrumentXhigh_ep_2005 = EP_instrument*high_ep_2005
xtreg atg_stock_perc c.EP_instrument EP_instrumentXhigh_ep_2005 i.year, cluster(ind)
drop EP_instrument
drop EP_instrumentXhigh_ep_2005
end

eststo clear
xtreg ae iea_polXavr_em_2005 iea_pol_count i.year, fe
esttab using output/tex/ep_growth_1st.tex, replace label se ar2 stats(N F) star(* 0.10 ** 0.05 *** 0.01) drop(_cons) scalar(F)

// eststo clear
// xtreg ae iea_polXavr_em_2005 iea_pol_count avr_emissions_2005, fe
// esttab using output/tex/ep_growth_1st.tex, replace label se ar2 stats(N F) star(* 0.10 ** 0.05 *** 0.01) drop(_cons) scalar(F)

set seed 12345
bootstrap, reps(200): epg2sls
esttab using output/tex/ep_growth_median.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(_cons)



******************************************
// Regression without instrument (growth)
******************************************

gen epgXhigh_75 = epg*high_75_ep_2005
label variable epgXhigh_75   "EP growth * High EP 2005 75%"

// xtreg atg epg epgXhigh_75 i.year, cluster(ind)
// esttab using ep_gr_noinst.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons)

// xtreg atg iea_pol_cum_gr i.year

// With instrument
capture program drop epg2sls
program epg2sls
* first stage regression
xtreg ae iea_polXavr_em_2005 iea_pol_count, fe
* get predicted values
predict EPG_instrument
* second stage regression
gen EPG_instrumentXhigh_75_ep_2005 = EPG_instrument*high_75_ep_2005
xtreg atg_stock_perc c.EPG_instrument EPG_instrumentXhigh_75_ep_2005 i.year, cluster(ind)
drop EPG_instrument
drop EPG_instrumentXhigh_75_ep_2005
end

eststo clear
// xtreg epg iea_pol_cum i.year, fe
// esttab using output/tex/ep_growth_1st.tex, replace label se ar2 stats(N F) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons) scalar(F)

set seed 12345
bootstrap, reps(200): epg2sls
esttab using output/tex/ep_growth_75.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons)


******************************************
// Regression without instrument (growth)
******************************************

gen epgXhigh_90 = epg*high_90_ep_2005
label variable epgXhigh_90   "EP growth * High EP 2005 90%"

// xtreg atg epg epgXhigh_90 i.year, cluster(ind)
// esttab using ep_gr_noinst.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons)

// xtreg atg iea_pol_cum_gr i.year

// With instrument
capture program drop epg2sls
program epg2sls
* first stage regression
xtreg ae iea_polXavr_em_2005 iea_pol_count, fe
* get predicted values
predict EPG_instrument
* second stage regression
gen EPG_instrumentXhigh_90_ep_2005 = EPG_instrument*high_90_ep_2005
xtreg atg_stock_perc c.EPG_instrument EPG_instrumentXhigh_90_ep_2005 i.year, cluster(ind)
drop EPG_instrument
drop EPG_instrumentXhigh_90_ep_2005
end

eststo clear
// xtreg epg iea_pol_cum i.year, fe
// esttab using output/tex/ep_growth_1st.tex, replace label se ar2 stats(N F) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons) scalar(F)

set seed 12345
bootstrap, reps(200): epg2sls
esttab using output/tex/ep_growth_90.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year _cons)

