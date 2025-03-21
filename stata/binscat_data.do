insheet using binscat_data.csv

twoway (scatter ln_tfp ln_ener_prod, mcolor(navy) lcolor(red)) (function 0*x^2+.5296768517217526*x+1.580133354669693, range(2.939607901705636 4.932888862064907) lcolor(red)), graphregion(fcolor(white))  xtitle(ln_ener_prod) ytitle(ln_tfp) legend(off order()) ytitle("Log TFP") xtitle("Log Energy Productivity") title("Relationship TFP and Energy Productivity") note("Controls: Establishment FE")
