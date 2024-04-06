// Regressions for Census data

use data/dta/Panel.dta, clear
//replace m000a = tida if missing(m000a) // "Total de ingresos derivados de la actividad" is called "tida" in 1999. Merging with total income from the other years. 
//drop tida
keep new_id year m000a h001d
