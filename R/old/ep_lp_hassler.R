#Replicate productivity from Hassler et al.(2021) using only energy use - not price
library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(ggplot2)

load('data/rdata/df_ep_lp_hassler.Rdata')

gamma <- 0.5
epsilon <- 0.02
  
df_hassler <- df %>%
  mutate(ae = ep_euk_usd*((1/ep_euk_usd)/gamma)^(epsilon/(epsilon-1))) %>%
  filter(COU == "USA") %>%
  select(ae, ind, lp_euk_usd, year) %>%
  group_by(year) %>%
  summarise(ae = mean(ae, na.rm = TRUE), lp_euk_usd = mean(lp_euk_usd, na.rm = TRUE))