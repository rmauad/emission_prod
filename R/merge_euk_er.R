library(tidyverse)
library(dplyr)
library(lubridate)

load("data/rdata/euk.Rdata")
load("data/rdata/er_year.Rdata")

euk <- euk %>%
  mutate(cur = ifelse(COU == "CZE", "CZE",
                      ifelse(COU == "DNK", "DNK",
                             ifelse(COU == "HUN", "HUN",
                                    ifelse(COU == "POL", "POL",
                                           ifelse(COU == "SWE", "SWE",
                                                  ifelse(COU == "GBR", "GBR",
                                                         ifelse(COU == "USA", "USA",
                                                  "EUR"))))))),
         year_cur = paste(cur, "_",year))

euk_er <- inner_join(euk, er_year, by = "year_cur")

euk_er <- euk_er %>%
  filter(COU != "LTU", COU != "LVA", COU != "SVK", COU != "SVN") %>%
  mutate(va_euk_usd = va*er,
         lp = va_euk_usd/emp_h)

save(euk_er, file = "data/rdata/euk_er.Rdata")


