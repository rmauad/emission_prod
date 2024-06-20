// Productivity boxplot

use data/dta/df_cum.dta, clear //from prep_dta.R

// Plotting box and whiskers in levels
winsor2 ae, replace cut(5 95) trim
bysort year ind: egen avr_ae = mean(ae)
label variable avr_ae "Average energy productivity"
graph box avr_ae, over(year) title("Energy productivity industry distribution (avr across countries)")
graph export "output/stata/boxplot_ae_levels.png"

winsor2 at, replace cut(5 95) trim
bysort year ind: egen avr_at = mean(at)
label variable avr_at "Average productivity"
graph box avr_at, over(year) title("Productivity industry distribution (avr across countries)")
graph export "output/stata/boxplot_at_levels.png"


// Plotting box and whiskers in growth
drop if year == "2005"
winsor2 epg, replace cut(5 95) trim
bysort year ind: egen avr_epg = mean(epg)
label variable avr_epg "Average energy productivity growth"
graph box avr_epg, over(year) title("Energy productivity growth industry distribution")
graph export "output/stata/boxplot_epg.png"

drop if year == "2005"
winsor2 atg, replace cut(5 95) trim
bysort year ind: egen avr_atg = mean(atg)
label variable avr_atg "Average productivity growth"
graph box avr_atg, over(year) title("Productivity growth industry distribution")
graph export "output/stata/boxplot_atg.png"


