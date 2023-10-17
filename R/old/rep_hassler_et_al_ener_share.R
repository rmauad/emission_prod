#Replicate productivity from Hassler et al.(2021) using only energy use - not price
library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(ggplot2)

load('data/rdata/df_wiod.Rdata')

df_wiod <- df_wiod %>% filter(COU == "USA") %>%
  mutate(e_share = em/va_wiod) %>%
  group_by(year) %>%
  summarise(e_share_avr = mean(e_share, na.rm = TRUE))

ggplot(df_wiod, aes(x = year, y = e_share_avr)) + 
  geom_line() +
  geom_point() +
  labs(
    x = "Year",
    y = "E_share"
  )
