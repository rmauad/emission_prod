library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(matlab)

load("emissions_agg.RData")
load("eu_klems.Rdata")

eu_klems_agg <- eu_klems_comp %>%
  mutate(lpg1 = 1 + lpg/100) %>%
  subset(select = -c(lpg)) %>%
mutate(ind1 = ifelse(ind == "58-60" | ind == "62-63", "58-60_62-63",
                    ifelse(ind == "O" | ind == "T", "O_T_U",
                    ind))) %>%
  group_by(COU, year, ind1) %>%
  summarize_at(c("lpg1"),prod) %>%
  mutate(lpg = ifelse(ind1 == "58-60_62-63" | ind1 == "O_T_U", (lpg1)^(1/2)-1,
                      lpg1-1)) %>%
  subset(select = -c(lpg1))

col_names = list('COU','year','ind','lpg')
colnames(eu_klems_agg) <- col_names

# Merging both databases ####

eu_klems_agg <- eu_klems_agg %>%
  mutate(key = paste(COU, year, ind, sep = "_"))

emissions_agg <- emissions_agg %>%
  mutate(key = paste(COU, year, ind, sep = "_"))

df <- merge(x = eu_klems_agg, y = emissions_agg, by = "key")
df <- df %>%   subset(select = -c(key, COU.y, year.y, ind.y, VA, em, va_em))
col_names = list('COU','year','ind','lpg','EME','epg')
colnames(df) <- col_names

save(df, file = "df.RData")