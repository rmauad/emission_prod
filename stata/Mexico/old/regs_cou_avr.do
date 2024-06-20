// Regressions of the productivity measures

use df_cou_avr.dta
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


//egen panelid = group(COU ind), label
xtset ind year


// IV regressions
xtivreg lp_euk_usd (ep_euk_usd = iea_pol) i.ind

// Results of instrumentalizing ep_euk_usd and running two regressions should be the same - but it's not! Check this
xtreg ep_euk_usd iea_pol i.ind

predict ep_hat 

xtreg lp_euk_usd ep_hat i.ind

// 
xtreg avr_lp c.avr_ep##(high_ep_2005) i.year, cluster(ind)

xtreg lpg c.epg#(high_ep_2005 EME) i.year, cluster(ind)



//gen log_ep = log(ep)
//gen log_lp_wiod = log(lp_wiod)
//xtreg log_lp_wiod c.log_ep#(high_ep_2005 EME) i.year

