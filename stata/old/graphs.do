// Scatterplot for epg and lpg

use df.dta

//Using levels of labor and emissions productivity
//gen lp_wiod = va_wiod/emp_h
//bysort COU ind: gen lpg_wiod = log(lp_wiod) - log(lp_wiod[_n-1])

bysort year: egen avr_lp = mean(lp)
bysort year: egen avr_ep = mean(ep)

binscatter avr_lp avr_ep

bysort ind year: egen avr_lp_by_ind = mean(lp)
bysort ind year: egen avr_ep_by_ind = mean(ep)

binscatter avr_lp_by_ind avr_ep_by_ind


// Using growth
gen lpg_ln = log(1+lpg)
gen epg_ln = log(1+epg)

bysort year: egen avr_lpg = mean(lpg_ln)
bysort year: egen avr_epg = mean(epg_ln)
gen lpg_gmean = exp(avr_lpg)-1
gen epg_gmean = exp(avr_epg)-1
binscatter lpg_gmean epg_gmean
//scatter y x
// ssc install binscatter

bysort ind year: egen avr_lpg_by_ind = mean(lpg_ln)
bysort ind year: egen avr_epg_by_ind = mean(epg_ln)
gen lpg_gmean_by_ind = exp(avr_lpg_by_ind)-1
gen epg_gmean_by_ind = exp(avr_epg_by_ind)-1

binscatter lpg_gmean_by_ind epg_gmean_by_ind

// Plotting box and whiskers
bysort year ind: egen avr_ep_ae = mean(ep_wiod) if EME == 0
bysort year ind: egen avr_ep_em = mean(ep_wiod) if EME == 1


graph box avr_ep_ae avr_ep_em, over(year)

