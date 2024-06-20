// Plot emission productivity and IEA cumulative policies

use df_cum.dta
winsor2 ep_euk_usd, replace cut(1 99) trim

bysort COU: egen avr_ep_COU = mean(ep_euk_usd)
bysort COU: egen avr_iea_COU = mean(iea_pol_cum)
bysort year: egen avr_ep_year = mean(ep_euk_usd)
bysort year: egen avr_iea_year = mean(iea_pol_cum)


encode year,gen(year1)
drop year
rename year1 year

scatter avr_iea_COU avr_ep_COU, ytitle("Average # IEA policies (across countries)") xtitle("Average EP (across countries)") title("EP and IEA policies")


scatter avr_iea_year avr_ep_year, ytitle("Average # IEA policies (over time)") xtitle("Average EP (over time)") title("EP and IEA policies") 
