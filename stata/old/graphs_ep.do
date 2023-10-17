//Plotting graphs for data visualization. How does emission productivity vary across industries?
//load indutry_v1.dta

// Plotting emission productivity by industry for EME and AE.

graph bar (median) va_em if EME == 1, over(industry_title, relabel (1 "1"	2 " "	3 " "	4 " "	5 "5"	6 " "	7 " "	8 " "	9 " "	10 "10"	11 " "	12 " "	13 " "	14 " "	15 "15"	16 " "	17 " "	18 " "	19 " "	20 "20"	21 " "	22 " "	23 " "	24 " "	25 "25"	26 " "	27 " "	28 " "	29 " "	30 "30"	31 " "	32 " "	33 " "	34 " "	35 "35"	36 " "	37 " "	38 " "	39 " "	40 "40"	41 " "	42 " "	43 " "	44 " "	45 "45"	46 " "	47 " "	48 " "	49 " ")) ytitle("Median of emission productivity over time") title("Emission productivity for Emerging Markets")

graph bar (median) va_em if EME == 0, over(industry_title, relabel (1 "1"	2 " "	3 " "	4 " "	5 "5"	6 " "	7 " "	8 " "	9 " "	10 "10"	11 " "	12 " "	13 " "	14 " "	15 "15"	16 " "	17 " "	18 " "	19 " "	20 "20"	21 " "	22 " "	23 " "	24 " "	25 "25"	26 " "	27 " "	28 " "	29 " "	30 "30"	31 " "	32 " "	33 " "	34 " "	35 "35"	36 " "	37 " "	38 " "	39 " "	40 "40"	41 " "	42 " "	43 " "	44 " "	45 "45"	46 " "	47 " "	48 " "	49 " ")) ytitle("Median of emission productivity over time") title("Emission productivity for Advanced Economies")

