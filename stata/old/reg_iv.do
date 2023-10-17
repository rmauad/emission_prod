// Regressions of the productivity measures

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
label variable lpg   "Labor Productivity Growth"
label variable epg   "Emission Productivity Growth"
label variable epXhigh   "Emission Productivity * High EP 2005"
label variable epXEME   "Emission Productivity * EME"


// Regression without instrument (levels and growth rate)
//xtreg lp_euk_usd c.ep_euk_usd##(high_ep_2005 EME) i.year, cluster(ind)
xtreg lp_euk_usd c.ep_euk_usd high_ep_2005 EME epXhigh epXEME i.year, cluster(ind)

//outreg2 using ep_lev.tex, replace label drop(i.year) dec(3) nocons
//esttab using ep_lev.tex, se ar2 stats(N r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*.year) ///
esttab using ep_lev.tex, replace label se ar2 stats(N r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*.year)
//esttab, replace label se ar2 drop(*.year)

xtreg lpg c.epg##(high_ep_2005 EME) i.year, cluster(ind)

// Regression with IEA policy as instrument (levels and growth). Need to bootstrap the standard errors because we're using an estimate as a regressor.
capture program drop ep2sls
program ep2sls
* first stage regression
xtreg ep_euk_usd iea_pol i.ind
* get predicted values
predict ep_hat
* second stage regression
xtreg lp_euk_usd c.ep_hat##(high_ep_2005 EME) i.year, cluster(ind)
drop ep_hat
end

bootstrap, reps(200): ep2sls

capture program drop epg2sls
program epg2sls
* first stage regression
xtreg epg iea_pol i.ind
* get predicted values
predict epg_hat
* second stage regression
xtreg lpg c.epg_hat##(high_ep_2005 EME) i.year, cluster(ind)
drop epg_hat
end

bootstrap, reps(200): epg2sls
