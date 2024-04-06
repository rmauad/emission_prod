// Creating panel from INEGI's Census data.


// Run this in case the original databases do not have a column "year"
foreach year of numlist 2009 2014 2019 {
use data/dta/Insumo`year'_MuestraFicticia.dta, clear
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
	
save data/dta/Insumo`year'_MuestraFicticia_year.dta, replace
}


****************************************************************************
** Summing the "green investment" variables fro 2014 and 2019
****************************************************************************

use data/dta/Insumo2019_MuestraFicticia_year.dta, clear
append using data/dta/Insumo2014_MuestraFicticia_year.dta
drop o603 o604 o605 o606 o607 d101
egen o605 = rowtotal(o612_3c o612_4c o612_5c o612_6c o612_11c o612_12c o612_13c) // Gastos en inversión para prevenir, reducir o eliminar la contaminación - DO NOT sum with "+" because there are missing values
egen o606 = rowtotal(o612_1c o612_2c o612_7c o612_8c o612_14c) // Gasto corriente destinado para actividades de protección al medio ambiente - DO NOT sum with "+" because there are missing values
drop o612_3c o612_4c o612_5c o612_6c o612_11c o612_12c o612_13c o612_1c o612_2c o612_7c o612_8c o612_14c
save data/dta/Insumo2014_2019_MuestraFicticia_year.dta, replace

****************************************************************************
** Appending the Census of all years to create a panel based on new_id.
****************************************************************************

use data/dta/Insumo2014_2019_MuestraFicticia_year.dta, clear
append using data/dta/Insumo2009_MuestraFicticia_year.dta
drop NIC_NOP_2009
save data/dta/Panel_MuestraFicticia.dta, replace







