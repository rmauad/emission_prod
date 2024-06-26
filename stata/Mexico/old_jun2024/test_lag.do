// test lag operator

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

keep COU ind panelid year ae

by panelid: g lag_ae = L.ae
