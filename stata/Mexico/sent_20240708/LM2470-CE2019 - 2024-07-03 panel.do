// Creating panel from INEGI's Census data.

*******************************
* Please change the path here
*******************************

local path_dta "data/dta/"

****************************************************************************
** Summing the "green investment" variables for 2014 and 2019
****************************************************************************
local path_dta "data_test/dta/"
local filename = "`path_dta'Insumo2019.dta"
use "`filename'", clear
append using `path_dta'Insumo2014.dta
drop o603 o604 o605 o606 o607 d101
egen o605 = rowtotal(o612_3c o612_4c o612_5c o612_6c o612_11c o612_12c o612_13c) // Gastos en inversión para prevenir, reducir o eliminar la contaminación - DO NOT sum with "+" because there are missing values
egen o606 = rowtotal(o612_1c o612_2c o612_7c o612_8c o612_14c) // Gasto corriente destinado para actividades de protección al medio ambiente - DO NOT sum with "+" because there are missing values
drop o612_3c o612_4c o612_5c o612_6c o612_11c o612_12c o612_13c o612_1c o612_2c o612_7c o612_8c o612_14c
save `path_dta'Insumo2014_2019.dta, replace

****************************************************************************
** Appending the Census of all years to create a panel based on new_id.
****************************************************************************

local filename = "`path_dta'Insumo2014_2019.dta"
use "`filename'", clear
append using `path_dta'Insumo2009.dta
save `path_dta'Panel.dta, replace





