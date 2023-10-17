library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(matlab)
library(foreign)
library(stringi)

load("data/rdata/emissions_agg.RData")
load("data/rdata/euk.Rdata")
load("data/rdata/fx.RData")
load("data/rdata/iea_pol_cum.RData")

euk_agg <- euk %>%
  group_by(COU, ind) %>%
mutate(ind1 = ifelse(ind == "58-60" | ind == "62-63", "58-60_62-63",
                    ifelse(ind == "O" | ind == "T", "O_T_U",
                    ind))) %>%
  ungroup() %>%
  group_by(COU, year, ind1) %>%
  summarize(va = sum(va), emp_h = sum(emp_h))  %>%
  rename(ind = ind1, va_euk = va)

# Merging both databases ####

euk_agg <- euk_agg %>%
  mutate(key = paste(COU, year, ind, sep = "_"))

emissions_agg <- emissions_agg %>%
  mutate(key = paste(COU, year, ind, sep = "_"))

df <- merge(x = euk_agg, y = emissions_agg, by = "key")
df <- df %>%   subset(select = -c(key, COU.y, year.y, ind.y)) %>%
  rename(COU = COU.x, year = year.x, ind = ind.x) %>%
  subset(select = -c(VA)) # REMOVING VALUE ADDED FROM WIOD (IN NOMINAL TERMS)

df <- as.data.frame(df)
df <- left_join(df, fx, by = "COU")
df$er <- as.numeric(df$er)
df <- df %>% mutate(va_euk_usd = va_euk*er) %>% 
  mutate(ep_euk_usd = va_euk_usd/em) %>%
  group_by(COU,ind) %>%
  mutate(epg = log(ep_euk_usd)-lag(log(ep_euk_usd))) %>%
  mutate(lp_euk_usd = va_euk_usd/emp_h) %>%
  mutate(lpg = log(lp_euk_usd)-dplyr::lag(log(lp_euk_usd))) %>%
  ungroup() %>%
  group_by(year, ind) %>%
  mutate(avr_ep = mean(ep_euk_usd)) %>%
  ungroup() %>%
  group_by(year) %>%
  mutate(med_avr_ep = median(avr_ep, na.rm = TRUE)) %>%
  mutate(high_ep_2005 = ifelse(year == 2005 & avr_ep > med_avr_ep, 1, 0)) %>%
  ungroup()
  
high_ep_ind <- df %>% select(ind, high_ep_2005, year) %>%
  filter(year == 2005) %>% select(-c(year))
high_ep_ind <- high_ep_ind[!duplicated(high_ep_ind$ind), ] #DON'T FORGET THIS COMMA INSIDE THE BRACKETS!!!!!!!

df <- left_join(df, high_ep_ind, by = "ind")
df <- df %>% select(-c(high_ep_2005.x)) %>%
  rename(high_ep_2005 = high_ep_2005.y)

df <- df %>% mutate(COUyear = paste(COU, year, sep = "_"))
df <- left_join(df, iea_pol_cum)
#df[["iea_pol"]][is.na(df[["iea_pol"]])] <- 0 #replacing NAs with zeros in iea_pol
df_cum <- df %>% select(-c(COUyear))

save(df_cum, file = "data/rdata/df_cum.RData")
write.dta(df_cum, "data/dta/df_cum.dta")