// Creating panel from INEGI's Census data.

*******************************
* Please change the path if needed
*******************************

gl data "data/dta/"


foreach year of numlist 2009 2014 2019 {
local filename = "$data/Insumo`year'.dta"
use "`filename'", clear
capture gen year = `year'
if _rc == 0 {
save "$data/Insumo`year'_year.dta", replace
}
}

****************************************************************************
** Summing the "green investment" variables for 2014 and 2019
****************************************************************************
local filename = "$data/Insumo2019_year.dta"
use "`filename'", clear
append using "$data/Insumo2014_year.dta"
drop o603 o604 o605 o606 o607 d101
egen o605 = rowtotal(o612_3c o612_4c o612_5c o612_6c o612_11c o612_12c o612_13c) // Gastos en inversión para prevenir, reducir o eliminar la contaminación - DO NOT sum with "+" because there are missing values
egen o606 = rowtotal(o612_1c o612_2c o612_7c o612_8c o612_14c) // Gasto corriente destinado para actividades de protección al medio ambiente - DO NOT sum with "+" because there are missing values
drop o612_3c o612_4c o612_5c o612_6c o612_11c o612_12c o612_13c o612_1c o612_2c o612_7c o612_8c o612_14c
save "$data/Insumo2014_2019.dta", replace

****************************************************************************
** Appending the Census of all years to create a panel based on new_id.
****************************************************************************

local filename = "$data/Insumo2014_2019.dta"
use "`filename'", clear
append using "$data/Insumo2009_year.dta"
save "$data/Panel.dta", replace



