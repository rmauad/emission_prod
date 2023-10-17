// Regressions of the productivity measures
// See variables labels: codebook varname

use df.dta
winsor2 ep_euk_usd, replace cut(1 99) trim

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
gen epXhigh = ep_euk_usd*high_ep_2005
gen epXEME = ep_euk_usd*EME

label variable lp_euk_usd   "Labor Productivity"
label variable ep_euk_usd   "Emission Productivity"
label variable high_ep_2005   "High EP 2005"
label variable lpg   "LP Growth"
label variable epg   "Emission Productivity Growth"
label variable epXhigh   "Emission Productivity * High EP 2005"
label variable epXEME   "Emission Productivity * EME"


// Regression without instrument (levels)
eststo: xtreg lp_euk_usd c.ep_euk_usd high_ep_2005 EME epXhigh epXEME i.year, cluster(ind)

// Regression with IEA policy as instrument (levels). Need to bootstrap the standard errors because we're using an estimate as a regressor.
capture program drop ep2sls
program ep2sls
* first stage regression
xtreg ep_euk_usd iea_pol i.ind
* get predicted values
predict EP_instrument
* second stage regression
gen EP_instrumentXhigh_ep_2005 = EP_instrument*high_ep_2005
gen EP_instrumentXEME = EP_instrument*EME
xtreg lp_euk_usd c.EP_instrument high_ep_2005 EME EP_instrumentXhigh_ep_2005 EP_instrumentXEME i.year, cluster(ind)
drop EP_instrument
drop EP_instrumentXhigh_ep_2005
drop EP_instrumentXEME
end

//label variable ep_hatXhigh   "EP instrument * High EP 2005"

eststo: bootstrap, reps(200): ep2sls
esttab , replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year)

esttab using ep_lev.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year)

eststo clear
// Regression without instrument (levels)
eststo: xtreg lpg c.epg high_ep_2005 EME epXhigh epXEME i.year, cluster(ind)

// With instrument
capture program drop epg2sls
program epg2sls
* first stage regression
xtreg epg iea_pol i.ind
* get predicted values
predict EPG_instrument
* second stage regression
xtreg lpg c.EPG_instrument high_ep_2005 EME epXhigh epXEME i.year, cluster(ind)
drop EPG_instrument
end

eststo: bootstrap, reps(200): epg2sls
esttab using ep_growth.tex, replace label se ar2 stats(N) star(* 0.10 ** 0.05 *** 0.01) drop(*.year)
