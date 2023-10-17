library(tidyverse)
library(dplyr)
library(lubridate)

eurusd <- read.csv("data/csv/EURUSD.csv")
usdczk <- read.csv("data/csv/USDCZK.csv")
usddkk <- read.csv("data/csv/USDDKK.csv")
usdhuf <- read.csv("data/csv/USDHUF.csv")
usdpln <- read.csv("data/csv/USDPLN.csv")
usdsek <- read.csv("data/csv/USDSEK.csv")
usdgbp <- read.csv("data/csv/USDGBP.csv")

usdeur <- eurusd %>% mutate(year = year(Date)) %>%
  select(year, Close) %>%
  group_by(year) %>%
  summarize(er = mean(Close, na.rm = TRUE)) %>%
  mutate(cur = "EUR",
         er = 1/er,
         year_cur = paste(cur, "_",year))

usdczk <- usdczk %>% mutate(year = year(Date)) %>%
  select(year, Close) %>%
  group_by(year) %>%
  summarize(er = mean(Close, na.rm = TRUE)) %>%
  mutate(cur = "CZE",
         year_cur = paste(cur, "_",year))

usddkk <- usddkk %>% mutate(year = year(Date)) %>%
  select(year, Close) %>%
  group_by(year) %>%
  summarize(er = mean(Close, na.rm = TRUE)) %>%
  mutate(cur = "DNK",
         year_cur = paste(cur, "_",year))

usdhuf <- usdhuf %>% mutate(year = year(Date)) %>%
  select(year, Close) %>%
  group_by(year) %>%
  summarize(er = mean(Close, na.rm = TRUE)) %>%
  mutate(cur = "HUN",
         year_cur = paste(cur, "_",year))

usdpln <- usdpln %>% mutate(year = year(Date)) %>%
  select(year, Close) %>%
  group_by(year) %>%
  summarize(er = mean(Close, na.rm = TRUE)) %>%
  mutate(cur = "POL",
         year_cur = paste(cur, "_",year))

usdsek <- usdsek %>% mutate(year = year(Date)) %>%
  select(year, Close) %>%
  group_by(year) %>%
  summarize(er = mean(Close, na.rm = TRUE)) %>%
  mutate(cur = "SWE",
         year_cur = paste(cur, "_",year))

usdgbp <- usdgbp %>% mutate(year = year(Date)) %>%
  select(year, Close) %>%
  group_by(year) %>%
  summarize(er = mean(Close, na.rm = TRUE)) %>%
  mutate(cur = "GBR",
         year_cur = paste(cur, "_",year))

usd <- usdgbp %>% mutate(er = 1,
                         cur = "USA",
                         year_cur = paste(cur, "_",year))

er_year <- rbind(usdeur, usdczk, usddkk, 
                 usdhuf, usdpln, usdsek, usdgbp, usd)

er_year <- er_year %>%
  select(year_cur, er)

save(er_year, file = "data/rdata/er_year.Rdata")