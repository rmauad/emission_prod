// Galina's original code

g debtgr2 = D.totalliabilitiesanddebt/L.totalliabilitiesanddebt
cap_ren is "green" variable (share of renewables)
g inv_retear = investments/retainedear
also try g invgr = D.investments/L.investments 
g inv_debt2 = investments/D.totalliabilitiesanddebt
g size = log(numberofemp/1000 + 1)

eststo clear
quietly eststo:  reghdfe debtgr2 L.cap_ren size , noabs
quietly eststo:  reghdfe debtgr2 L.cap_ren size , a(cntry)
quietly eststo:  reghdfe debtgr2 L.cap_ren size , a(year)
quietly eststo:  reghdfe debtgr2 L.cap_ren size , a(cntry year)
esttab, se  starl(* 0.10 ** 0.05 *** 0.01) 
 

eststo clear
quietly eststo:  reghdfe inv_retear L.cap_ren size , noabs
quietly eststo:  reghdfe inv_retear L.cap_ren size , a(cntry)
quietly eststo:  reghdfe inv_retear L.cap_ren size , a(year)
quietly eststo:  reghdfe inv_retear L.cap_ren size , a(cntry year)
esttab, se  starl(* 0.10 ** 0.05 *** 0.01) 
 
 
eststo clear
quietly eststo:  reghdfe inv_debt2 L.cap_ren size, noabs
quietly eststo:  reghdfe inv_debt2 L.cap_ren size, a(cntry)
quietly eststo:  reghdfe inv_debt2 L.cap_ren size, a(year)
quietly eststo:  reghdfe inv_debt2 L.cap_ren size, a(cntry year)
esttab, se  starl(* 0.10 ** 0.05 *** 0.01) 
 
The other direction

eststo: reghdfe D.cap_ren LD.leverage LD.ltdebt LD.interest_expense, a(cntry year)

