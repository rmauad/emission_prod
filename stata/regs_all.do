

*******************************************
* This file contains codes for all regressions that are summarized in the exhibits in the paper as well as in the table with Post-COP21 interactions
* Input file is workfile.dta produced by process_all.  This file is not shared in the replication bundle because of proprietary data, but can be constructed by running process_all.do as indicated on ORBIS-NBER data. 
*******************************************

use workfile

**********************
* Creating some more necessary variables for regressions 
***********************

global TR  Diea Dhqiea 
global PR Lclimat Lmeteo Lhydro Ldeath Lhq_climatological_m Lhq_meteorological_m Lhq_hydrological_m Lhqdeath
global EMI Lemi Lhq_emi
global CCR Lccrh 

foreach v in $TR $PR $CCR {
	capture drop `v'_em
	g `v'_em = `v' * Lemi
}

g post = (year>=2016)

foreach v in $PR  $TR  {
	capture drop `v'_post
	g `v'_post = `v' * post
}

g Lhqemi_em =  Lhq_emi * Lemi

xtset link year

global MACRO L.trade_gdp L.rgdpg L.ppig 
global TRE   Diea  Diea_em   Dhqiea_em 
global PRE   Lclimat Lmeteo Lhydro   Lclimat_em Lmeteo_em Lhydro_em Ldeath_em Lhq_climatological_m_em Lhq_meteorological_m_em Lhq_hydrological_m_em Lhqdeath_em
global CCRE Lccrh_em
global PRP  Lhydro Lmeteo Lclimat Ldeath Lhydro_post Lmeteo_post Lclimat_post Ldeath_post

********************* Disaster only and post-COP21 *********************  

eststo clear
qui eststo: xi: reghdfe D.shcount $PRP $MACRO if ofc==0 & zeros==0  & adv==1, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $PRP $MACRO if ofc==0  & adv==1 & D.count01>=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $PRP $MACRO if ofc==0  & adv==1 & D.count01<=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.shcount $PRP $MACRO if ofc==0 & zeros==0  & eme==1 , a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $PRP $MACRO if ofc==0  & eme==1  & D.count01>=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $PRP $MACRO if ofc==0  & eme==1  & D.count01<=0, a(owner#year naics target) cluster(owner iso2)
esttab using AllP.tex, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  label interaction(" $\times$ ") style(tex) replace booktabs alignment(D{.}{.}{-1}) title(Post-1997 \label{tab:post972})
esttab using AllP.csv, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) replace


eststo clear
qui eststo: xi: reghdfe D.shcount Lvul Lvul_post $MACRO if ofc==0 & zeros==0 & adv==1, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 Lvul Lvul_post $MACRO if ofc==0 & adv==1 & D.count01>=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 Lvul Lvul_post $MACRO if ofc==0 & adv==1 & D.count01<=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.shcount Lvul Lvul_post $MACRO if ofc==0 & zeros==0 & eme==1 , a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 Lvul Lvul_post $MACRO if ofc==0 & eme==1  & D.count01>=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 Lvul Lvul_post $MACRO if ofc==0 & eme==1  & D.count01<=0, a(owner#year naics target) cluster(owner iso2)
esttab using AllPv.tex, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  label interaction(" $\times$ ") style(tex) replace booktabs alignment(D{.}{.}{-1}) title(Post-1997 \label{tab:post972})
esttab using AllPv.csv, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) replace



********************* Main effects - only source, target, year, industry FEs ********************* 

eststo clear
qui eststo: xi: reghdfe D.shcount $TR $PR $EMI $CCR $MACRO if ofc==0 & zeros==0  & adv==1 , a(owner year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TR $PR $EMI $CCR $MACRO if ofc==0  & adv==1 & D.count01>=0 , a(owner year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TR $PR $EMI $CCR $MACRO if ofc==0  & adv==1 & D.count01<=0 , a(owner year naics target) cluster(owner iso2)
esttab using AEiea.tex, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  label interaction(" $\times$ ") style(tex) replace booktabs alignment(D{.}{.}{-1}) title(Post-1997 \label{tab:post972})
esttab using AEiea.csv, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) replace

eststo clear
qui eststo: xi: reghdfe D.shcount $TR $PR $EMI $CCR $MACRO if ofc==0 & zeros==0  & eme==1 , a(owner year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TR $PR $EMI $CCR $MACRO if ofc==0  & eme==1  & D.count01>=0, a(owner year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TR $PR $EMI $CCR $MACRO if ofc==0  & eme==1  & D.count01<=0, a(owner year naics target) cluster(owner iso2)
esttab using EMEiea.tex, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  label interaction(" $\times$ ") style(tex) replace booktabs alignment(D{.}{.}{-1}) title(Post-1997 \label{tab:post972})
esttab using EMEiea.csv, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) replace



********************** Interactions with Emissions for everything **********************
********************** No main effects:  source*time, target, industry FEs *********************

eststo clear
qui eststo: xi: reghdfe D.shcount $TRE $PRE $EMI $CCRE $MACRO if ofc==0 & zeros==0  & adv==1 , a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TRE $PRE $EMI $CCRE $MACRO if ofc==0  & adv==1  & D.count01>=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TRE $PRE $EMI $CCRE $MACRO if ofc==0  & adv==1  & D.count01<=0, a(owner#year naics target) cluster(owner iso2)
esttab using AEEiea.tex, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  label interaction(" $\times$ ") style(tex) replace booktabs alignment(D{.}{.}{-1}) title(Post-1997 \label{tab:post972})
esttab using AEEiea.csv, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) replace

eststo clear
qui eststo: xi: reghdfe D.shcount $TRE $PRE $EMI $CCRE $MACRO if ofc==0 & zeros==0  & eme==1 , a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TRE $PRE $EMI $CCRE $MACRO if ofc==0  & eme==1  & D.count01>=0, a(owner#year naics target) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01 $TRE $PRE $EMI $CCRE $MACRO if ofc==0  & eme==1  & D.count01<=0, a(owner#year naics target) cluster(owner iso2)
esttab using EMEEiea.tex, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  label interaction(" $\times$ ") style(tex) replace booktabs alignment(D{.}{.}{-1}) title(Post-1997 \label{tab:post972})
esttab using EMEEiea.csv, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) replace

********************** Interactions with firm-level climate risk *********************
 
global SENT   Lccrh_c Lccrh_m  Lccrh_h    Lccrh_d  Lccrh_iea 

foreach v in $SENT  {
	capture drop `v'_post
	g `v'_post = `v' * post
}

global SENT  Lccrh_c Lccrh_m  Lccrh_h  Lccrh_d    Lccrh_iea    Lccrh_c_post Lccrh_m_post  Lccrh_h_post   Lccrh_d_post    Lccrh_iea_post   

eststo clear
qui eststo: xi: reghdfe D.shcount  $SENT   if ofc==0 & year>=2010 & usable==1 & zeros==0 , a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe D.shcount  $SENT   if ofc==0 & adv==1 & year>=2010 & usable==1 & zeros==0 , a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe D.shcount  $SENT   if ofc==0 & eme==1 & year>=2010 & usable==1 & zeros==0 , a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe D.shcount  $SENT   if ofc==0 & hq_ofc==1 & year>=2010 & usable==1 & zeros==0 , a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)

qui eststo: xi: reghdfe D.count01  $SENT   if ofc==0 & year>=2010 & usable==1 &  D.count01>=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01  $SENT   if ofc==0 & adv==1 & year>=2010 & usable==1 &  D.count01>=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01  $SENT   if ofc==0 & eme==1 & year>=2010 & usable==1 &  D.count01>=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe D.count01  $SENT   if ofc==0 & hq_ofc==1 & year>=2010 & usable==1 &  D.count01>=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)

qui eststo: xi: reghdfe NDcount01  $SENT   if ofc==0 & year>=2010 & usable==1 &  D.count01<=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe NDcount01  $SENT   if ofc==0 & adv==1 & year>=2010 & usable==1 &  D.count01<=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe NDcount01  $SENT   if ofc==0 & eme==1 & year>=2010 & usable==1 &  D.count01<=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)
qui eststo: xi: reghdfe NDcount01  $SENT   if ofc==0 & hq_ofc==1 & year>=2010 & usable==1 &  D.count01<=0, a(owner#ifs owner#year naics ifs#year) cluster(owner iso2)

esttab, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  
esttab using OT2zieapost.tex, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01)  label interaction(" $\times$ ") style(tex) replace booktabs alignment(D{.}{.}{-1}) title(Post-1997 \label{tab:post972})
esttab using OT2zieapost.csv, se ar2 stats(N r2) star(* 0.10 ** 0.05 *** 0.01) replace

*************************** the end ********************** 
 


