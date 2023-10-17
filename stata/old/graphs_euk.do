// Scatterplot for epg and lpg

use data/dta/df.dta
winsor2 ep_euk_usd, replace cut(1 99) trim

//Binscatter plots of emission productivity vs. labor productivity (in levels)

// Advanced economies
bysort ind year: egen avr_lp_low_ep_ae = mean(lp_euk_usd) if high_ep_2005 == 0 & EME == 0
bysort ind year: egen avr_ep_low_ep_ae = mean(ep_euk_usd) if high_ep_2005 == 0 & EME == 0
bysort ind year: egen avr_lp_high_ep_ae = mean(lp_euk_usd) if high_ep_2005 == 1 & EME == 0
bysort ind year: egen avr_ep_high_ep_ae = mean(ep_euk_usd) if high_ep_2005 == 1 & EME == 0

// Emerging markets
bysort ind year: egen avr_lp_low_ep_em = mean(lp_euk_usd) if high_ep_2005 == 0 & EME == 1
bysort ind year: egen avr_ep_low_ep_em = mean(ep_euk_usd) if high_ep_2005 == 0 & EME == 1
bysort ind year: egen avr_lp_high_ep_em = mean(lp_euk_usd) if high_ep_2005 == 1 & EME == 1
bysort ind year: egen avr_ep_high_ep_em = mean(ep_euk_usd) if high_ep_2005 == 1 & EME == 1

//Binscatter plots of emission productivity vs. labor productivity (in growth)
gen lpg_ln = log(1+lpg)
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
bysort year ind: egen avr_ep_ae = mean(ep_euk_usd) if EME == 0
bysort year ind: egen avr_ep_em = mean(ep_euk_usd) if EME == 1
bysort year ind: egen avr_lp_ae = mean(lp_euk_usd) if EME == 0
bysort year ind: egen avr_lp_em = mean(lp_euk_usd) if EME == 1

// Graph commands
label variable avr_ep_high_ep_ae  "Average EP (high EP industries) - AE"
label variable avr_ep_ae "Advanced Economies"
label variable avr_ep_em "Emerging Markets"
label variable avr_lp_ae "Advanced Economies"
label variable avr_lp_em "Emerging Markets"

encode year,gen(year1)
drop year
rename year1 year

binscatter avr_lp_high_ep_ae avr_ep_high_ep_ae , ytitle("Average LP (across AE)") xtitle("Average EP (across AE)") title("Advanced Economies, high EP ind") nquantiles(40) controls(i.year) saving(output/stata/level_high_ep_ae)
binscatter avr_lp_high_ep_em avr_ep_high_ep_em , ytitle("Average LP (across EME)") xtitle("Average EP (across EME)") title("Emerging Markets, high EP ind") nquantiles(40) controls(i.year)  saving(output/stata/level_high_ep_em)
binscatter avr_lp_low_ep_ae avr_ep_low_ep_ae , ytitle("Average LP (across AE)") xtitle("Average EP (across AE)") title("Advanced Economies, low EP ind") nquantiles(40) controls(i.year)  saving(output/stata/level_low_ep_ae)
binscatter avr_lp_low_ep_em avr_ep_low_ep_em , ytitle("Average LP (across EME)") xtitle("Average EP (across EME)") title("Emerging Markets, low EP ind") nquantiles(40) controls(i.year)  saving(output/stata/level_low_ep_em)


binscatter avr_lpg_high_ep_ae avr_epg_high_ep_ae , ytitle("Average LPG (across AE)") xtitle("Average EPG (across AE)") title("Advanced Economies, high EP ind") nquantiles(40) controls(i.year) saving(output/stata/growth_high_ep_ae)
binscatter avr_lpg_high_ep_em avr_epg_high_ep_em , ytitle("Average LPG (across EME)") xtitle("Average EPG (across EME)") title("Emerging Markets, high EP ind") nquantiles(40) controls(i.year)  saving(output/stata/growth_high_ep_em)
binscatter avr_lpg_low_ep_ae avr_epg_low_ep_ae , ytitle("Average LPG (across AE)") xtitle("Average EPG (across AE)") title("Advanced Economies, low EP ind") nquantiles(40) controls(i.year)  saving(output/stata/growth_low_ep_ae)
binscatter avr_lpg_low_ep_em avr_epg_low_ep_em , ytitle("Average LPG (across EME)") xtitle("Average EPG (across EME)") title("Emerging Markets, low EP ind") nquantiles(40) controls(i.year)  saving(output/stata/growth_low_ep_em)


graph box avr_ep_ae avr_ep_em, title("Emission Productivity (country averages)") ylabel(0[1]5) yscale(range(0 5)) over(year) nooutside saving(output/stata/bw_ep)
graph box avr_lp_ae avr_lp_em, title("Labor Productivity (country averages)") ylabel(0[0.1]0.2) yscale(range(0 0.2)) nooutside over(year) saving(output/stata/bw_lp)
//xlabel(,angle(45))

graph combine level_high_ep_ae.gph level_high_ep_em.gph level_low_ep_ae.gph level_low_ep_em.gph 
graph combine growth_high_ep_ae.gph growth_high_ep_em.gph growth_low_ep_ae.gph growth_low_ep_em.gph 
graph combine bw_ep.gph bw_lp.gph, col(2) iscale(0.6)

































