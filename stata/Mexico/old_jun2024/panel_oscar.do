// Creating panel from INEGI's Census data.


// Run this in case the original databases do not have a column "year"
foreach year of numlist 2009 2014 2019 {
use data/dta/Insumo`year'.dta, clear
gen year = `year'

    * Check if the column "id_uelm" exists
    capture confirm variable id_uelm
    
    * If the command above does not produce an error, the variable exists
    if _rc == 0 {
        * Create new_id as a copy of id_uelm
        gen new_id = id_uelm
    }
    else {
        * Create new_id and leave it blank (missing)
        gen new_id = .
    }
	
	if `year' <= 2009 {
	gen NIC_NOP_`year' =  trim(e01) + trim(e02)
	}
	
save data/dta/Insumo`year'_year.dta, replace
}

****************************************************************************
** Appending the Census of all years to create a panel based on new_id.
****************************************************************************

use data/dta/Insumo2019_year.dta, clear
append using data/dta/Insumo2014_year.dta
append using data/dta/Insumo2009_year.dta
append using data/dta/Insumo2004_year.dta
save data/dta/Panel.dta, replace
//use data/dta/Panel.dta, clear






