# Treat the merged database (EU KLEMS and WIOD) to take country averages before running the regressions

library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(matlab)
library(foreign)
library(stringi)

load("df.RData")

df_cou_avr <- df %>% group_by(ind, year) %>%
  mutate(avr_lp = mean(lp_euk_usd)) %>%
  filter(!duplicated(ind))

write.dta(df_cou_avr, "df_cou_avr.dta")