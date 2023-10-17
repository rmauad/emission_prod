# Merge emissions with EU KLEMS. Changing the industries from WIOD (emissions) 
# according to "industries.xls" in the "read" folder

library(tidyverse)
library(dplyr)

load("data/rdata/emissions_all.Rdata") #generated from import_emissions.R
load("data/rdata/euk_er.Rdata") #generated from merge_euk_er.R

emissions_all <- emissions_all %>%
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
  filter(ind != "FC_HH") %>%
  group_by(COU, year, ind_new) %>%
  summarize(emissions = sum(emissions)) %>%
  mutate(cou_year_ind = paste(COU,"_", year,"_", ind_new)) %>%
  ungroup() %>%
  select(cou_year_ind, emissions)

euk_er <- euk_er %>%
  mutate(cou_year_ind = paste(COU,"_", year,"_", ind))

euk_emissions <- inner_join(euk_er, emissions_all, by = "cou_year_ind")

euk_emissions <- euk_emissions %>%
  mutate(e_share = emissions/va_euk_usd) %>%
  group_by(COU, year) %>%
  mutate(e_share_avr = mean(e_share, na.rm = TRUE))

save(euk_emissions, file = "data/rdata/euk_emissions.Rdata")

plot <- euk_emissions %>%
  ungroup() %>%
  filter(COU == "USA") %>%
  select(year, e_share_avr)

plot <- unique(plot)
  
ggplot(data = plot, aes(year, e_share_avr)) + geom_point()
