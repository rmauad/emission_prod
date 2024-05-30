

use data/dta/df_cum.dta, clear

encode ind,gen(ind1)
drop ind
rename ind1 ind

encode year,gen(year1)
drop year
rename year1 year

encode COU,gen(COU1)
drop COU
rename COU1 COU

egen panelid = group(COU ind), label
xtset panelid year

gen epXhigh = ae*high_ep_2005


* Variables to summarize
local var_summary "at ae epXhigh"
foreach vars in `var_summary' {
egen mean_`vars' = mean(`vars'), by(year)
egen sd_`vars' = sd(`vars'), by(year)
egen min_`vars' = min(`vars'), by(year)
egen max_`vars' = max(`vars'), by(year)
}

* Keep one record per group
bysort year: gen tag = _n == 1

local var_summary "at ae epXhigh"
local vars_to_keep "year tag"
foreach vars in `var_summary' {
local vars_to_keep `vars_to_keep' mean_`vars' sd_`vars' min_`vars' max_`vars'
}

keep `vars_to_keep'
export delimited using "summary_statistics.csv", replace



