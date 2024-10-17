	clear all
	drop _all
	set more off

	***** global with user name
	*gl user ""
	***** global with location of the dataset with firm-level data ( In this case the data with dummys of being above/below median)
	gl data_firms "Z:\Procesamiento\Trabajo\_inegi"
	***** global with location of the cpi dataset. 
	**Assumption 1: The assumption here is that the dataset is at the barcode-week level---i.e., it hasn't been aggregated at any level.
	**Assumption 2: The CPI dataset already contains the info regarding to which firm the article belongs or is related to.
	**Note: If Assumption 2 is false, then you can merge the firm name to the products using the codes in lines 54 to 64.  
	gl data_cpi "Z:\Procesamiento\Trabajo\Temp"
	***** global for a directory for output
	mkdir "Z:\Resultados\LM1230-Precios-2022-09-29\LM1230-Precios-2022-09-29-Tablas"

	gl tables "Z:\Resultados\LM1230-Precios-2022-09-29\LM1230-Precios-2022-09-29-Tablas"
	gl figures "Z:\Resultados\LM1230-Precios-2022-09-29\LM1230-Precios-2022-09-29-Figures"


	cd "$data_cpi"


	
	*********************************************************
	** creating inflation rates **
	***********************************************************
		local filename_prod "products"
		
	*	1)	Open dataset
	use "`filename_prod'.dta", clear
		
drop b7 v51 v5 

sort specific yy mm
 bysort specific: egen nobs= count(specific)
 // if nobs=12*6 + 6 = 78, we have observation for the complete sample
 
 drop if nobs<20
 * I drop around 26740 observations -- i am left w 741330 obs
 
//////////////////////////////////////////////////  
//Generating infl of prices by article 			//
////////////////////////////////////////////////// 
 ** annual inflation
sort specific yy mm
 g inf_w1=(w1-w1[_n-12])/w1[_n-12] if specific==specific[_n-12] & yy-1==yy[_n-12] & mm==mm[_n-12] 
 g inf_w2=(w2-w2[_n-12])/w2[_n-12] if specific==specific[_n-12] & yy-1==yy[_n-12] & mm==mm[_n-12] 
g inf_w3=(w3-w3[_n-12])/w3[_n-12] if specific==specific[_n-12] & yy-1==yy[_n-12] & mm==mm[_n-12] 
g inf_w4=(w4-w4[_n-12])/w4[_n-12] if specific==specific[_n-12] & yy-1==yy[_n-12] & mm==mm[_n-12] 

** generating average price per month
sort specific yy mm
egen price=rowmean(w1 w2 w3 w4)
egen rel_p=rowmean(rel_q1 rel_q2)

*annual inflation
sort  specific yy mm
 g inf_a=(price-price[_n-12])/price[_n-12] if specific==specific[_n-12] & yy-1==yy[_n-12] & mm==mm[_n-12] 
 g rel_a=(rel_p-rel_p[_n-12])/rel_p[_n-12] if specific==specific[_n-12] & yy-1==yy[_n-12] & mm==mm[_n-12] 


cd "$data_firms"


joinby gen_num using "goods_INPC_v2.dta", unm(m)
tab _merge
drop _merge



sort specific yy mm

g mon=ym(yy, mm)
*tsset mon, monthly

drop gen_label w1 w2 w3 w4 rel_q1 rel_q2 inf_w1  inf_w2 inf_w3 inf_w4 

cd "$data_cpi"

save "products_inf_clean_new" , replace
		

	***********************************************
	******************** Inputs
	***********************************************


	**local with the filename with CPI data
	local filename_cpi "products_inf_clean_new"
	**local with the filename with firm-level data ( above/below median)
	local filename_firm "matched_firms_above_below_median_coded_BC"
	** local with the name of the variable with the month to which each observation is related
	local t_month "mon"
	** local with the name of the variable capturing price
	local var_price "price"


	** time window that is relevant for the analysis ( here we need to pick weeks from the first week of 2011 to the last week of 2019

	local time_window "keep if  `t_month'>tm(2010m12) & `t_month'<tm(2014m10)" 
	// there is a change of base in 2018m8... better to keep the data until then

	*	1)	Open dataset
	use "`filename_cpi'.dta", clear

	*	2) rename the variable with the name of firms such that it has the same name as the variable with the name of the firm in filename_firm

	* Local saving the name of the variable that contains the name of the firm to which each article is associated to.

	local var_firm "firm_code"

	rename `var_firm' firmnum

	
	/// Note: make sure firm is a string variable.

	//tostring firmnum, replace

	* 	3) Keep the relevant period of analysis:

	`time_window'

	*	4) Merge the CPI data with the firm-level data (filename_firm)
	cd "$data_firms"
	joinby firmnum using `filename_firm' , unm(m)

	sum T2
	
	/// You can alternatively use: merge m:1 firm using "$data_firms\`filename_firm'" 
	tab _merge

	* keep only the  match articles.

	keep if _merge==3

	drop _merge
	cd "$data_cpi"

	save merged_dataset, replace

	preserve 
	keep firmnum 
	g matched=1
	collapse (max) matched , by(firmnum)
	export excel "${tables}\matched_firms.xlsx", firstrow(variables) 
	restore
	
	*** create pannel ****
	***********************************************
	******************** Inputs
	***********************************************
	
	*** Using quarters
	use merged_dataset, clear // 
	drop if firmnum==74
	drop if T==.

	set matsize 10000
	gen qq=1 if mm<4
	replace qq=2 if mm>3 & mm<7
	replace qq=3 if mm>6 & mm<10
	replace qq=4 if mm>9

	** taking out outliers
	sum inf_a, det
	g outlier=inf_a>r(p99) | inf_a<r(p1) 
	// there are 4 periods with outliers on the below median
	count if inf_a>r(p99) | inf_a<r(p1)
	loc drop_inf_a: di %10.2f `r(N)'
	sum inf_a, det
	replace inf_a=r(p99) if inf_a>r(p99)
	replace inf_a=r(p1) if inf_a<r(p1) 
	**	

	g qtr=yq(yy, qq)
	format qtr %tq
	egen CityXy=group(city yy)
	egen GoodXy=group(gen_num yy)
	egen CityXGoodXy=group(city gen_num yy)

	order qtr firmnum specific

	sort  qtr firmnum specific

	cap drop Post // this is worth asking
	cap drop tau // this is worth asking

	g Post=mon>tm(2013m2)
	replace Post=. if mon==.

	gen r_policy=.

	replace r_policy=4.5 if mon<=tm(2013m2)

	replace r_policy=4 if tm(2013m2)<mon & mon<tm(2013m9)

	replace r_policy=3.75 if mon==tm(2013m9)

	replace r_policy=3.5 if tm(2013m9)<mon & mon<tm(2014m6)

	replace r_policy=3 if tm(2014m5)<mon & mon<tm(2014m10)
	
	keep if qtr>=tq(2011q1) & qtr<=tq(2014q3)	

	tab qtr, g(q_)

	distinct qtr
	if r(ndistinct)!=15 {
		di r(ndistinct)
		error 1
		} 
		


****** Identifying durable and non-durable goods.
	
gen cat_dur=.
replace cat_dur=0 if gen_num<109 // comida, bebida, alimentos, cigarrillos (non-durables)
replace cat_dur=1 if gen_num>=110  & gen_num!=. // ropa, zapatos, relojes, joyas, servicios, bienes para el hogar, cuidados personales, medicamentos, servicios (durables)

	
gen durable=cat_dur==1
gen nondurable=cat_dur==0
	
**** Computing price dispersion by genericgen_num

preserve
keep if qtr==tq(2012q4)
g lprice=log(price)
egen avg_price=mean(lprice), by(gen_num )
egen sd_price=sd(lprice), by(gen_num)
gen coef_var=sd_price/avg_price

collapse coef_var, by(gen_num)
sum coef_var, det
g high_vol=coef_var>=`r(p50)'
replace high_vol=. if coef_var==.
label var coef_var "Coefficient of variation"
tempfile volatility
save `volatility', replace
sum coef_var, det
hist coef_var, ytitle(Density) xtitle(Coef. of variation (log prices)) xline(`r(p50)') bfcolor(none) blcolor(maroon) graphregion(color(white))
graph export "${figures}\volatility.png", replace
restore


preserve
keep if qtr==tq(2012q4)
g lprice=log(price)
egen avg_price=mean(lprice), by(gen_num city)
egen sd_price=sd(lprice), by(gen_num city)
gen coef_var=sd_price/avg_price

collapse coef_var, by(gen_num city)
sum coef_var, det
g high_vol2=coef_var>=`r(p50)'
replace high_vol2=. if coef_var==.
rename coef_var coef_var2
label var coef_var2 "Coefficient of variation"
tempfile volatility2
save `volatility2', replace
sum coef_var2, det
hist coef_var2, ytitle(Density) xtitle(Coef. of variation (log prices)) xline(`r(p50)') bfcolor(none) blcolor(maroon) graphregion(color(white))
graph export "${figures}\volatility2.png", replace
restore

joinby gen_num using `volatility', unm(m) _merge(_merge2)
tab _merge2
drop _merge2

g low_vol=high_vol==0

joinby gen_num city using `volatility2', unm(m) _merge(_merge3)
tab _merge3
drop _merge3

g low_vol2=high_vol2==0

	
********************************************************************************
******** summary statistics*****************************************************
********************************************************************************

preserve 
keep if mon==tm(2012m12)
keep gen_num firmnum T
g num_generic=1
collapse (sum) num_generic (max) T, by(firmnum)
label var num_generic "# of goods traded"

export excel "${tables}\number_goods.xlsx", firstrow(variables) 
restore

preserve 
keep if mon==tm(2012m12)
keep city firmnum T
g num_city=1

collapse (sum) num_city (max) T , by(firmnum)
label var num_city "# of cities"
export excel "${tables}\number_cities.xlsx", firstrow(variables) 
restore

preserve 
keep if mon==tm(2012m12)
keep coef_var coef_var2 firmnum T
collapse (mean) coef_var coef_var2 (max) T, by(firmnum)
label var coef_var "Price dispersion (generic)"
label var coef_var "Price dispersion (generic - city)"
export excel "${tables}\price_dispersion.xlsx", firstrow(variables) 
restore
********************************************************************************
***************** Trends: 
********************************************************************************
preserve
	collapse (mean) rel_p inf_a , by(T qtr)
	* generate deviations from the pre-period mean:
	foreach x in rel_p inf_a  {
		sum `x' if qtr==tq(2012q4)
		g `x'_d=`x'-r(mean)
	}
	export excel "${tables}\trends_DV.xlsx", firstrow(variables)
restore



********************************************************************************
***************** Regressions: Main
********************************************************************************

global DV  rel_p inf_a 

foreach y in $DV {
	*** No controls
quietly: reg `y' c.T#c.Post T Post ,cl(firmnum)
outreg2 using "$tables\reg_`y'", excel replace adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, NO, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm fixed effects
quietly: areg `y' c.T#c.Post  Post , a(firmnum) cl(firmnum)
outreg2 using "$tables\reg_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)
*** Adding for good fixed effects
quietly: areg `y' c.T#c.Post  Post i.firmnum, a(gen_num) cl(firmnum)
outreg2 using "$tables\reg_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

	*** Controlling for firm FE and goodXyear FE
quietly: areg `y' c.T#c.Post  Post i.firmnum , a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm FE and CityXyear FE
quietly: areg `y' c.T#c.Post  Post i.firmnum i.CityXy, a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, YES, city-good-year FE, NO)


	*** Controlling for CityXGoodXy FE
quietly: areg `y' c.T#c.Post  Post i.firmnum , a(CityXGoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE,NO, city-good-year FE, YES)


***** Using IR

quietly: reg `y' c.T#c.r_policy T r_policy ,cl(firmnum)
outreg2 using "$tables\reg_`y'_r", excel replace adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, NO, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm fixed effects
quietly: areg `y' c.T#c.r_policy  r_policy , a(firmnum) cl(firmnum)
outreg2 using "$tables\reg_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)
*** Adding for good fixed effects
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum, a(gen_num) cl(firmnum)
outreg2 using "$tables\reg_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

	*** Controlling for firm FE and goodXyear FE
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum , a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm FE and CityXyear FE
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum i.CityXy, a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, YES, city-good-year FE, NO)


	*** Controlling for CityXGoodXy FE
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum , a(CityXGoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE,NO, city-good-year FE, YES)

}

***** Excluding outliers:

preserve
keep if outlier==0
foreach y in $DV {
	*** No controls
quietly: reg `y' c.T#c.Post T Post ,cl(firmnum)
outreg2 using "$tables\Out_`y'", excel replace adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, NO, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm fixed effects
quietly: areg `y' c.T#c.Post  Post , a(firmnum) cl(firmnum)
outreg2 using "$tables\Out_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)
*** Adding for good fixed effects
quietly: areg `y' c.T#c.Post  Post i.firmnum, a(gen_num) cl(firmnum)
outreg2 using "$tables\Out_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

	*** Controlling for firm FE and goodXyear FE
quietly: areg `y' c.T#c.Post  Post i.firmnum , a(GoodXy) cl(firmnum)
outreg2 using "$tables\Out_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm FE and CityXyear FE
quietly: areg `y' c.T#c.Post  Post i.firmnum i.CityXy, a(GoodXy) cl(firmnum)
outreg2 using "$tables\Out_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, YES, city-good-year FE, NO)


	*** Controlling for CityXGoodXy FE
quietly: areg `y' c.T#c.Post  Post i.firmnum , a(CityXGoodXy) cl(firmnum)
outreg2 using "$tables\Out_`y'", excel append adjr2 keep(Post c.T#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE,NO, city-good-year FE, YES)


***** Using IR

quietly: reg `y' c.T#c.r_policy T r_policy ,cl(firmnum)
outreg2 using "$tables\Out_`y'_r", excel replace adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, NO, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm fixed effects
quietly: areg `y' c.T#c.r_policy  r_policy , a(firmnum) cl(firmnum)
outreg2 using "$tables\Out_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)
*** Adding for good fixed effects
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum, a(gen_num) cl(firmnum)
outreg2 using "$tables\Out_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

	*** Controlling for firm FE and goodXyear FE
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum , a(GoodXy) cl(firmnum)
outreg2 using "$tables\Out_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm FE and CityXyear FE
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum i.CityXy, a(GoodXy) cl(firmnum)
outreg2 using "$tables\Out_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, YES, city-good-year FE, NO)


	*** Controlling for CityXGoodXy FE
quietly: areg `y' c.T#c.r_policy  r_policy i.firmnum , a(CityXGoodXy) cl(firmnum)
outreg2 using "$tables\Out_`y'_r", excel append adjr2 keep(r_policy c.T#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE,NO, city-good-year FE, YES)
}

restore


****** Continuous T


foreach y in $DV {
	*** No controls
quietly: reg `y' c.T2#c.Post T2 Post ,cl(firmnum)
outreg2 using "$tables\reg_`y'2", excel replace adjr2 keep(Post c.T2#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, NO, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm fixed effects
quietly: areg `y' c.T2#c.Post  Post , a(firmnum) cl(firmnum)
outreg2 using "$tables\reg_`y'2", excel append adjr2 keep(Post c.T2#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)
*** Adding for good fixed effects
quietly: areg `y' c.T2#c.Post  Post i.firmnum, a(gen_num) cl(firmnum)
outreg2 using "$tables\reg_`y'2", excel append adjr2 keep(Post c.T2#c.Post) addstat("N clusters", `e(N_clust)')  addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

	*** Controlling for firm FE and goodXyear FE
quietly: areg `y' c.T2#c.Post  Post i.firmnum , a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'2", excel append adjr2 keep(Post c.T2#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm FE and CityXyear FE
quietly: areg `y' c.T2#c.Post  Post i.firmnum i.CityXy, a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'2", excel append adjr2 keep(Post c.T2#c.Post) addstat("N clusters", `e(N_clust)')  addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, YES, city-good-year FE, NO)

	*** Controlling for CityXGoodXy FE
quietly: areg `y' c.T2#c.Post  Post i.firmnum , a(CityXGoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'2", excel append adjr2 keep(Post c.T2#c.Post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE,NO, city-good-year FE, YES)


***** Using IR

quietly: reg `y' c.T2#c.r_policy T2 r_policy ,cl(firmnum)
outreg2 using "$tables\reg_`y'_r2", excel replace adjr2 keep(r_policy c.T2#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, NO, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm fixed effects
quietly: areg `y' c.T2#c.r_policy  r_policy , a(firmnum) cl(firmnum)
outreg2 using "$tables\reg_`y'_r2", excel append adjr2 keep(r_policy c.T2#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, NO, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)
*** Adding for good fixed effects
quietly: areg `y' c.T2#c.r_policy  r_policy i.firmnum, a(gen_num) cl(firmnum)
outreg2 using "$tables\reg_`y'_r2", excel append adjr2 keep(r_policy c.T2#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE, NO, city-good-year FE, NO)

	*** Controlling for firm FE and goodXyear FE
quietly: areg `y' c.T2#c.r_policy  r_policy i.firmnum , a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'_r2", excel append adjr2 keep(r_policy c.T2#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, NO, city-good-year FE, NO)

*** Controlling for firm FE and CityXyear FE
quietly: areg `y' c.T2#c.r_policy  r_policy i.firmnum i.CityXy, a(GoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'_r2", excel append adjr2 keep(r_policy c.T2#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE, YES, city-good-year FE, NO)


	*** Controlling for CityXGoodXy FE
quietly: areg `y' c.T2#c.r_policy  r_policy i.firmnum , a(CityXGoodXy) cl(firmnum)
outreg2 using "$tables\reg_`y'_r2", excel append adjr2 keep(r_policy c.T2#c.r_policy) addstat("N clusters", `e(N_clust)') addtext(Firm FE, YES, Good FE, YES, good-year FE, NO, city-year FE,NO, city-good-year FE, YES)

}



********************************************************************************
***************** Regressions: Heterogeneity
********************************************************************************

/* By price dispersion (within generics) */



local replace replace
	foreach y in $DV {
	quietly: areg `y' c.T#c.Post#c.high_vol c.T#c.Post#c.low_vol  T Post high_vol c.Post#c.high_vol c.T#c.high_vol i.firmnum , a(CityXy) cl(firmnum)
	test c.T#c.Post#c.high_vol=c.T#c.Post#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol", excel `replace' adjr2 keep(c.T#c.Post#c.high_vol c.T#c.Post#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
	local replace append
		quietly: areg `y' c.T#c.Post#c.high_vol c.T#c.Post#c.low_vol  T Post high_vol c.Post#c.high_vol c.T#c.high_vol i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T#c.Post#c.high_vol=c.T#c.Post#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol", excel `replace' adjr2 keep(c.T#c.Post#c.high_vol c.T#c.Post#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)
	quietly: areg `y' c.T2#c.Post#c.high_vol c.T2#c.Post#c.low_vol  T2 Post high_vol c.Post#c.high_vol c.T2#c.high_vol i.firmnum , a(CityXy) cl(firmnum)
	test c.T2#c.Post#c.high_vol=c.T2#c.Post#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol", excel `replace' adjr2 keep(c.T2#c.Post#c.high_vol c.T2#c.Post#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
	local replace append
		quietly: areg `y' c.T2#c.Post#c.high_vol c.T2#c.Post#c.low_vol  T2 Post high_vol c.Post#c.high_vol c.T2#c.high_vol i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T2#c.Post#c.high_vol=c.T2#c.Post#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol", excel `replace' adjr2 keep(c.T2#c.Post#c.high_vol c.T2#c.Post#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)	
	}

	
	
/* By price dispersion (within generic-city bins) */


global DV  "rel_p  inf_a"
local replace replace
	foreach y in $DV {
	quietly: areg `y' c.T#c.Post#c.high_vol2 c.T#c.Post#c.low_vol2  T Post high_vol2 c.Post#c.high_vol2 c.T#c.high_vol2 i.firmnum , a(CityXy) cl(firmnum)
	test c.T#c.Post#c.high_vol2=c.T#c.Post#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2", excel `replace' adjr2 keep(c.T#c.Post#c.high_vol2 c.T#c.Post#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
	local replace append
		quietly: areg `y' c.T#c.Post#c.high_vol2 c.T#c.Post#c.low_vol2  T Post high_vol2 c.Post#c.high_vol2 c.T#c.high_vol2 i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T#c.Post#c.high_vol2=c.T#c.Post#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2", excel `replace' adjr2 keep(c.T#c.Post#c.high_vol2 c.T#c.Post#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)
	quietly: areg `y' c.T2#c.Post#c.high_vol2 c.T2#c.Post#c.low_vol2  T2 Post high_vol2 c.Post#c.high_vol2 c.T2#c.high_vol2 i.firmnum , a(CityXy) cl(firmnum)
	test c.T2#c.Post#c.high_vol2=c.T2#c.Post#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2", excel `replace' adjr2 keep(c.T2#c.Post#c.high_vol2 c.T2#c.Post#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
		quietly: areg `y' c.T2#c.Post#c.high_vol2 c.T2#c.Post#c.low_vol2  T2 Post high_vol2 c.Post#c.high_vol2 c.T2#c.high_vol2 i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T2#c.Post#c.high_vol2=c.T2#c.Post#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2", excel `replace' adjr2 keep(c.T2#c.Post#c.high_vol2 c.T2#c.Post#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)	
	}
	
/* Using r_policy */
	
	

local replace replace
	foreach y in $DV {
	quietly: areg `y' c.T#c.r_policy#c.high_vol c.T#c.r_policy#c.low_vol  T r_policy high_vol c.r_policy#c.high_vol c.T#c.high_vol i.firmnum , a(CityXy) cl(firmnum)
	test c.T#c.r_policy#c.high_vol=c.T#c.r_policy#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol_r", excel `replace' adjr2 keep(c.T#c.r_policy#c.high_vol c.T#c.r_policy#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
	local replace append
		quietly: areg `y' c.T#c.r_policy#c.high_vol c.T#c.r_policy#c.low_vol  T r_policy high_vol c.r_policy#c.high_vol c.T#c.high_vol i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T#c.r_policy#c.high_vol=c.T#c.r_policy#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol_r", excel `replace' adjr2 keep(c.T#c.r_policy#c.high_vol c.T#c.r_policy#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)
	quietly: areg `y' c.T2#c.r_policy#c.high_vol c.T2#c.r_policy#c.low_vol  T2 r_policy high_vol c.r_policy#c.high_vol c.T2#c.high_vol i.firmnum , a(CityXy) cl(firmnum)
	test c.T2#c.r_policy#c.high_vol=c.T2#c.r_policy#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol_r", excel `replace' adjr2 keep(c.T2#c.r_policy#c.high_vol c.T2#c.r_policy#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
	local replace append
		quietly: areg `y' c.T2#c.r_policy#c.high_vol c.T2#c.r_policy#c.low_vol  T2 r_policy high_vol c.r_policy#c.high_vol c.T2#c.high_vol i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T2#c.r_policy#c.high_vol=c.T2#c.r_policy#c.low_vol
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol_r", excel `replace' adjr2 keep(c.T2#c.r_policy#c.high_vol c.T2#c.r_policy#c.low_vol) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)	
	}

	
	
/* By price dispersion (within generic-city bins) */


global DV  "rel_p  inf_a"
local replace replace
	foreach y in $DV {
	quietly: areg `y' c.T#c.r_policy#c.high_vol2 c.T#c.r_policy#c.low_vol2  T r_policy high_vol2 c.r_policy#c.high_vol2 c.T#c.high_vol2 i.firmnum , a(CityXy) cl(firmnum)
	test c.T#c.r_policy#c.high_vol2=c.T#c.r_policy#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2_r", excel `replace' adjr2 keep(c.T#c.r_policy#c.high_vol2 c.T#c.r_policy#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
	local replace append
		quietly: areg `y' c.T#c.r_policy#c.high_vol2 c.T#c.r_policy#c.low_vol2  T r_policy high_vol2 c.r_policy#c.high_vol2 c.T#c.high_vol2 i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T#c.r_policy#c.high_vol2=c.T#c.r_policy#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2_r", excel `replace' adjr2 keep(c.T#c.r_policy#c.high_vol2 c.T#c.r_policy#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)
	quietly: areg `y' c.T2#c.r_policy#c.high_vol2 c.T2#c.r_policy#c.low_vol2  T2 r_policy high_vol2 c.r_policy#c.high_vol2 c.T2#c.high_vol2 i.firmnum , a(CityXy) cl(firmnum)
	test c.T2#c.r_policy#c.high_vol2=c.T2#c.r_policy#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2_r", excel `replace' adjr2 keep(c.T2#c.r_policy#c.high_vol2 c.T2#c.r_policy#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YRD, city-year FE,NO, city-good-year FE, NO)
		quietly: areg `y' c.T2#c.r_policy#c.high_vol2 c.T2#c.r_policy#c.low_vol2  T2 r_policy high_vol2 c.r_policy#c.high_vol2 c.T2#c.high_vol2 i.firmnum , a(CityXGoodXy) cl(firmnum)
	test c.T2#c.r_policy#c.high_vol2=c.T2#c.r_policy#c.low_vol2
	local p=`r(p)'
	outreg2 using "$tables\reg_het_vol2_r", excel `replace' adjr2 keep(c.T2#c.r_policy#c.high_vol2 c.T2#c.r_policy#c.low_vol2) addstat("N clusters", `e(N_clust)', "p-value (high=low)", `p') addtext(Firm FE, YES, Good FE, YES, good-year FE, YES, city-year FE,NO, city-good-year FE, YES)	
	}
		
	

********************************************************************************
***************** Regressions: ES coeffs.
********************************************************************************



		
distinct qtr
	if r(ndistinct)!=15 {
		di r(ndistinct)
		di "check1"
		error 1
		} 	


foreach x in q_1 q_2 q_3 q_4 q_5 q_6 q_7 q_9 q_10 q_11 q_12 q_13 q_14 q_15 {
g Tx`x'=T*`x'
g T2x`x'=T2*`x'
}
global pre "Txq_1 Txq_2 Txq_3 Txq_4 Txq_5 Txq_6 Txq_7"
global post "Txq_9 Txq_10 Txq_11 Txq_12 Txq_13 Txq_14 Txq_15"
global pre2 "T2xq_1 T2xq_2 T2xq_3 T2xq_4 T2xq_5 T2xq_6 T2xq_7"
global post2 "T2xq_9 T2xq_10 T2xq_11 T2xq_12 T2xq_13 T2xq_14 T2xq_15"	


*** No controls:

mat qtt=J(15,1,.)
forval t=1/15 {
mat qtt[`t',1]=`t'-9
}

foreach y in rel_p {
mat b_`y'=J(15,2,.)	
mat se_`y'=J(15,2,.)

reg `y' $pre $post q_1 q_2 q_3 q_4 q_5 q_6 q_7 q_9 q_10 q_11 q_12 q_13 q_14 q_15   T  ,  cl(firmnum)
outreg2 using "$tables\ES_coefs", excel replace adjr2 keep($pre $post) addstat("N clusters", `e(N_clust)') addtext(Firm FE, NO, good-year FE, NO,  city-good-year FE, NO)

forval t=1/7 {
mat b_`y'[`t',1]=_b[Txq_`t']
mat se_`y'[`t',1]=_se[Txq_`t']
}

mat b_`y'[8,1]=0
mat se_`y'[8,1]=0

forval t=9/15 {
mat b_`y'[`t',1]=_b[Txq_`t']
mat se_`y'[`t',1]=_se[Txq_`t']
}


reg `y' $pre2 $post2 q_1 q_2 q_3 q_4 q_5 q_6 q_7 q_9 q_10 q_11 q_12 q_13 q_14 q_15 T2 ,  cl(firmnum)
outreg2 using "$tables\ES_coefs", excel append adjr2 keep($pre2 $post2) addtext(Firm FE, NO, good-year FE, NO,  city-good-year FE, NO)
forval t=1/7 {
mat b_`y'[`t',2]=_b[T2xq_`t']
mat se_`y'[`t',2]=_se[T2xq_`t']
}

mat b_`y'[8,2]=0
mat se_`y'[8,2]=0

forval t=9/15 {
mat b_`y'[`t',2]=_b[T2xq_`t']
mat se_`y'[`t',2]=_se[T2xq_`t']
}
}


*** Using good-year FE


foreach y in rel_p {
mat b_`y'_2=J(15,2,.)	
mat se_`y'_2=J(15,2,.)

areg `y' $pre $post q_1 q_2 q_3 q_4 q_5 q_6 q_7 q_9 q_10 q_11 q_12 q_13 q_14 q_15   T  , a(GoodXy)  cl(firmnum)
outreg2 using "$tables\ES_coefs", excel append adjr2 keep($pre $post) addtext(good-year FE, YES,  city-good-year FE, NO)
forval t=1/7 {
mat b_`y'_2[`t',1]=_b[Txq_`t']
mat se_`y'_2[`t',1]=_se[Txq_`t']
}

mat b_`y'_2[8,1]=0
mat se_`y'_2[8,1]=0

forval t=9/15 {
mat b_`y'_2[`t',1]=_b[Txq_`t']
mat se_`y'_2[`t',1]=_se[Txq_`t']
}


areg `y' $pre2 $post2 q_1 q_2 q_3 q_4 q_5 q_6 q_7 q_9 q_10 q_11 q_12 q_13 q_14 q_15 T2 , a(GoodXy) cl(firmnum)
outreg2 using "$tables\ES_coefs", excel append adjr2 keep($pre2 $post2) addtext( good-year FE, YES,  city-good-year FE, NO)
forval t=1/7 {
mat b_`y'_2[`t',2]=_b[T2xq_`t']
mat se_`y'_2[`t',2]=_se[T2xq_`t']
}

mat b_`y'_2[8,2]=0
mat se_`y'_2[8,2]=0

forval t=9/15 {
mat b_`y'_2[`t',2]=_b[T2xq_`t']
mat se_`y'_2[`t',2]=_se[T2xq_`t']
}
}


*** using city-good-year FE

foreach y in rel_p {
mat b_`y'_3=J(15,2,.)	
mat se_`y'_3=J(15,2,.)

areg `y' $pre $post q_1 q_2 q_3 q_4 q_5 q_6 q_7 q_9 q_10 q_11 q_12 q_13 q_14 q_15   T  , a(CityXGoodXy)  cl(firmnum)
outreg2 using "$tables\ES_coefs", excel append adjr2 keep($pre $post) addtext(good-year FE, YES,  city-good-year FE,YES)

forval t=1/7 {
mat b_`y'_3[`t',1]=_b[Txq_`t']
mat se_`y'_3[`t',1]=_se[Txq_`t']
}

mat b_`y'_3[8,1]=0
mat se_`y'_3[8,1]=0

forval t=9/15 {
mat b_`y'_3[`t',1]=_b[Txq_`t']
mat se_`y'_3[`t',1]=_se[Txq_`t']
}


areg `y' $pre2 $post2 q_1 q_2 q_3 q_4 q_5 q_6 q_7 q_9 q_10 q_11 q_12 q_13 q_14 q_15 T2 , a(CityXGoodXy) cl(firmnum)
outreg2 using "$tables\ES_coefs", excel append adjr2 keep($pre2 $post2) addtext( good-year FE, YES,  city-good-year FE, YES)

forval t=1/7 {
mat b_`y'_3[`t',2]=_b[T2xq_`t']
mat se_`y'_3[`t',2]=_se[T2xq_`t']
}

mat b_`y'_3[8,2]=0
mat se_`y'_3[8,2]=0

forval t=9/15 {
mat b_`y'_3[`t',2]=_b[T2xq_`t']
mat se_`y'_3[`t',2]=_se[T2xq_`t']
}
}
	
	

***********************
******* Export coefficients to excel
***********************


preserve
clear
svmat double qtt
rename qtt1 quarters_to_treat
foreach y in rel_p {
svmat double b_`y'
svmat double se_`y'
rename b_`y'1 b_`y'_disc
rename b_`y'2 b_`y'_cont
rename se_`y'1 se_`y'_disc
rename se_`y'2 se_`y'_cont

foreach suf in 2 3 {
svmat double b_`y'_`suf'
svmat double se_`y'_`suf'
rename b_`y'_`suf'1 b_`y'_`suf'_disc
rename b_`y'_`suf'2 b_`y'_`suf'_cont
rename se_`y'_`suf'1 se_`y'_`suf'_disc
rename se_`y'_`suf'2 se_`y'_`suf'_cont	
}
}
export excel "${tables}\ES_coefficients.xlsx", firstrow(variables) replace
restore	
	