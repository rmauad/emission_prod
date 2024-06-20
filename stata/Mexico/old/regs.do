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

// IV regressions
xtivreg lp_euk_usd (ep_euk_usd = iea_pol) i.year

// Results of instrumentalizing ep_euk_usd and running two regressions should be the same - but it's not! Check this
xtreg ep_euk_usd iea_pol i.ind

predict ep_hat 

xtreg lp_euk_usd c.ep_hat##(high_ep_2005 EME) i.year

// Bootstrap standard errors ############

xtivreg lp_euk_usd (ep_euk_usd = iea_pol) i.year
// write your own 2SLS program
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

// #######################################

xtreg lp_euk_usd c.ep_euk_usd##(high_ep_2005 EME) i.year, cluster(ind)

xtreg lpg c.epg##(high_ep_2005 EME) i.year, cluster(ind)

//gen log_ep = log(ep)
//gen log_lp_wiod = log(lp_wiod)
//xtreg log_lp_wiod c.log_ep#(high_ep_2005 EME) i.year

