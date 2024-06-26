// Creating panel from INEGI's Census data.


// Run this in case the original databases do not have a column "year"
foreach year of numlist 1999 2004 2009 2014 2019 {
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

****************************************************************
** Including id_uelm in the Oscar Fentanes' "correspondencias."
*****************************************************************
use data/dta/Insumo2009_MuestraFicticia_year.dta, clear
keep id_uelm NIC_NOP_2009
merge 1:m NIC_NOP_2009 using data/dta/correspondencias_1994-2014.dta,nogen
save data/dta/correspondencias_1994-2014_MuestraFicticia_id_uelm.dta, replace

****************************************************************************
** Populate the new_id column in the 2004 Census 
** If there's a corresponding id_uelm in the 2009 Census, that's the new_id. 
** Otherwise, copy NIC_NOP_2004.
****************************************************************************

use data/dta/correspondencias_1994-2014_MuestraFicticia_id_uelm.dta, clear
merge m:1 NIC_NOP_2004 using data/dta/Insumo2004_MuestraFicticia_year.dta, keep (3) nogen
tostring new_id, replace
replace new_id = id_uelm
replace new_id = NIC_NOP_2004 if new_id == ""
drop id_uelm NIC_NOP_1994 NIC_NOP_1999 NIC_NOP_2004 NIC_NOP_2009 NIC_NOP_2014
save data/dta/Insumo2004_MuestraFicticia_year.dta, replace

****************************************************************************
** Populate the new_id column in the 1999 Census 
** If there's a corresponding NIC_NOP_2004 in the 2004 Census, that's the new_id. 
** Otherwise, copy NIC_NOP_1999.
****************************************************************************

use data/dta/correspondencias_1994-2014_MuestraFicticia_id_uelm.dta, clear
merge m:1 NIC_NOP_1999 using data/dta/Insumo1999_MuestraFicticia_year.dta, keep (3) nogen
tostring new_id, replace
replace new_id = id_uelm
replace new_id = NIC_NOP_2004 if new_id == ""
replace new_id = NIC_NOP_1999 if new_id == ""
drop id_uelm NIC_NOP_1994 NIC_NOP_1999 NIC_NOP_2004 NIC_NOP_2009 NIC_NOP_2014
save data/dta/Insumo1999_MuestraFicticia_year.dta, replace

****************************************************************************
** Appending the Census of all years to create a panel based on new_id.
****************************************************************************

use data/dta/Insumo2019_MuestraFicticia_year.dta, clear
drop o603 o604 o605 o606 o607
append using data/dta/Insumo2014_MuestraFicticia_year.dta
drop d101
append using data/dta/Insumo2009_MuestraFicticia_year.dta
append using data/dta/Insumo2004_MuestraFicticia_year.dta
append using data/dta/Insumo1999_MuestraFicticia_year.dta
drop NIC_NOP_2009
save data/dta/Panel_MuestraFicticia.dta, replace







