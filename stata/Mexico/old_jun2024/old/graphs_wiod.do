// Scatterplot for epg and lpg

use df.dta

//Binscatter plots of emission productivity vs. labor productivity (in levels)

// Advanced economies
bysort ind year: egen avr_lp_low_ep_ae = mean(lp_wiod) if high_ep_2005 == 0 & EME == 0
bysort ind year: egen avr_ep_low_ep_ae = mean(ep) if high_ep_2005 == 0 & EME == 0
bysort ind year: egen avr_lp_high_ep_ae = mean(lp_wiod) if high_ep_2005 == 1 & EME == 0
bysort ind year: egen avr_ep_high_ep_ae = mean(ep) if high_ep_2005 == 1 & EME == 0

// Emerging markets
bysort ind year: egen avr_lp_low_ep_em = mean(lp_wiod) if high_ep_2005 == 0 & EME == 1
bysort ind year: egen avr_ep_low_ep_em = mean(ep) if high_ep_2005 == 0 & EME == 1
bysort ind year: egen avr_lp_high_ep_em = mean(lp_wiod) if high_ep_2005 == 1 & EME == 1
bysort ind year: egen avr_ep_high_ep_em = mean(ep) if high_ep_2005 == 1 & EME == 1

//Binscatter plots of emission productivity vs. labor productivity (in growth)
gen lpg_ln = log(1+lpg_wiod)
gen epg_ln = log(1+epg)

// Advanced economies
bysort ind year: egen avr_lpg_low_ep_ae = mean(lpg_ln) if high_ep_2005 == 0 & EME == 0
bysort ind year: egen avr_epg_low_ep_ae = mean(epg_ln) if high_ep_2005 == 0 & EME == 0
bysort ind year: egen avr_lpg_high_ep_ae = mean(lpg_ln) if high_ep_2005 == 1 & EME == 0
bysort ind year: egen avr_epg_high_ep_ae = mean(epg_ln) if high_ep_2005 == 1 & EME == 0
replace avr_lpg_low_ep_ae = exp(avr_lpg_low_ep_ae)-1
replace avr_epg_low_ep_ae = exp(avr_epg_low_ep_ae)-1
replace avr_lpg_high_ep_ae = exp(avr_lpg_high_ep_ae)-1
replace avr_epg_high_ep_ae = exp(avr_epg_high_ep_ae)-1

// Emerging markets
bysort ind year: egen avr_lpg_low_ep_em = mean(lpg_ln) if high_ep_2005 == 0 & EME == 1
bysort ind year: egen avr_epg_low_ep_em = mean(epg_ln) if high_ep_2005 == 0 & EME == 1
bysort ind year: egen avr_lpg_high_ep_em = mean(lpg_ln) if high_ep_2005 == 1 & EME == 1
bysort ind year: egen avr_epg_high_ep_em = mean(epg_ln) if high_ep_2005 == 1 & EME == 1
replace avr_lpg_low_ep_em = exp(avr_lpg_low_ep_em)-1
replace avr_epg_low_ep_em = exp(avr_epg_low_ep_em)-1
replace avr_lpg_high_ep_em = exp(avr_lpg_high_ep_em)-1
replace avr_epg_high_ep_em = exp(avr_epg_high_ep_em)-1

// Plotting box and whiskers
bysort year ind: egen avr_ep_ae = mean(ep) if EME == 0
bysort year ind: egen avr_ep_em = mean(ep) if EME == 1
bysort year ind: egen avr_lp_ae = mean(lp_wiod) if EME == 0
bysort year ind: egen avr_lp_em = mean(lp_wiod) if EME == 1

// Graph commands

binscatter avr_ep_high_ep_ae avr_lp_high_ep_ae, saving(level_high_ep_ae)
binscatter avr_ep_high_ep_em avr_lp_high_ep_em, saving(level_high_ep_em)
binscatter avr_ep_low_ep_ae avr_lp_low_ep_ae, saving(level_low_ep_ae)
binscatter avr_ep_low_ep_em avr_lp_low_ep_em, saving(level_low_ep_em)

binscatter avr_epg_high_ep_ae avr_lpg_high_ep_ae, saving(growth_high_ep_ae)
binscatter avr_epg_high_ep_em avr_lpg_high_ep_em, saving(growth_high_ep_em)
binscatter avr_epg_low_ep_ae avr_lpg_low_ep_ae, saving(growth_low_ep_ae)
binscatter avr_epg_low_ep_em avr_lpg_low_ep_em, saving(growth_low_ep_em)


graph box avr_ep_ae avr_ep_em, over(year, ) saving(bw_ep)
graph box avr_lp_ae avr_lp_em, over(year) xlabel(,angle(45)) saving(bw_lp)

graph combine level_high_ep_ae.gph level_high_ep_em.gph level_low_ep_ae.gph level_low_ep_em.gph 
graph combine growth_high_ep_ae.gph growth_high_ep_em.gph growth_low_ep_ae.gph growth_low_ep_em.gph 
graph combine bw_ep.gph bw_lp.gph, col(2) iscale(0.6)

































