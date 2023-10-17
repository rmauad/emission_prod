# Merge EU KLEMS with WIOD from the previous paper by Galina and Grace (FINAL16_v12.dta).
# This WIOD file contains energy use and emissions by energy type.

library(tidyverse)
library(dplyr)
library(haven)

wiod_energ <- read_dta('data/dta/FINAL16_v12.dta')
load("data/rdata/euk_er.rdata")

wiod_energ_ind <- wiod_energ %>%
  rename(ind = co2_code) %>%
  filter(ind != "FC_HH" & ind != "vTOTII_new") %>%
  mutate(ind_new = ifelse(ind == "A01" | ind == "A02" | ind == "A03", "A",
               ifelse(ind == "C10-C12", "10-12",
               ifelse(ind == "C13-C15", "13-15",
               ifelse(ind == "C16" | ind == "C17" | ind == "C18", "16-18",
               ifelse(ind == "C19", "19",
               ifelse(ind == "C20" | ind == "C21", "20-21",
               ifelse(ind == "C22" | ind == "C23", "22-23",
               ifelse(ind == "C24" | ind == "C25", "24-25",
               ifelse(ind == "C26" | ind == "C27", "26-27",
               ifelse(ind == "C28", "28",
               ifelse(ind == "C29" | ind == "C30", "29-30",
               ifelse(ind == "C31_C32" | ind == "C33", "31-33",
               ifelse(ind == "D35" | ind == "E36" | ind == "E37-E39", "D-E",
               ifelse(ind == "G45", "45",
               ifelse(ind == "G46", "46",
               ifelse(ind == "G47", "47",
               ifelse(ind == "H49" | ind == "H50" | ind == "H51" | ind == "H52", "49-52",
               ifelse(ind == "H53", "53",
               ifelse(ind == "J58" | ind == "J59_J60", "58-60",
               ifelse(ind == "J61", "61",
               ifelse(ind == "J62_J63", "62-63",
               ifelse(ind == "K64" | ind == "K65" | ind == "K66", "K",
               ifelse(ind == "L68", "L",
               ifelse(ind == "M69_M70" | ind == "M71" | ind == "M72" | ind == "M73" | ind == "M74_M75" | ind == "N", "M-N",
               ifelse(ind == "O84", "O",
               ifelse(ind == "P85", "P",
               ifelse(ind == "R_S", "R-S", ind)))))))))))))))))))))))))))) %>%
  mutate(cou_ind_year = paste(country_code, "_", ind_new, "_", year)) %>%
  select(-c(country_code, ind_new, year, ind_code, emgross_code, ind))

euk_ind <- euk_er %>%
  mutate(ind_new = ifelse(ind == "R" | ind == "S", "R-S", ind),
         cou_ind_year = paste(COU, "_", ind_new, "_", year)) %>%
  select(-c(COU, ind_new, year, ind))

wiod_euk <- inner_join(wiod_energ_ind, euk_ind, by = "cou_ind_year")

save(wiod_euk, file = "data/rdata/wiod_euk.rdata")







  