# Import and treat IEA policy data
library(tidyverse)
library(readxl)
library(reshape2)
library(dplyr)
library(matlab)
library(foreign)
library(stringi)
#iea <- read.table("IEA.csv",sep = ",",header = TRUE)
#iea <- read_excel("IEA.xlsx")
#save(iea, file = "iea.RData")

load("iea.RData")

COU <- c("AUT",	"CZE",	"DEU",	"DNK",	
         "ESP",	"EST",	"FIN",	"FRA",	
         "GBR",	"GRC",	"HUN",	"IRL",	
         "ITA",	"LTU",	"LUX",	"LVA",	
         "NLD",	"POL",	"PRT",	"SVN",	"SWE",	"USA")

Country <- c("Austria",	"Czech Republic",	"Germany",	
             "Denmark",	"Spain",	"Estonia",	"Finland",	
             "France",	"United Kingdom",	"Greece",	"Hungary",	
             "Ireland",	"Italy",	"Lithuania",	"Luxembourg",	
             "Latvia",	"Netherlands",	"Poland",	"Portugal",	
             "Slovenia",	"Sweden",	"United States")

country <- as.data.frame(cbind(COU, Country))

iea_sel <- left_join(iea, country, by = "Country")
iea_sel <- iea_sel %>% filter(!is.na(COU), Year <= 2015, Status == "In force" | Status == "Ended") %>%
  mutate(COUyear = paste(COU, Year, sep = "_"))
#iea_sel <- iea_sel[!duplicated(iea_sel$COUyear), ]
iea_pol <- iea_sel %>%
  mutate(iea_pol = ifelse(Status == "In force", 1, -1)) %>%
  group_by(COUyear, Year, COU) %>%
  summarize(iea_pol = sum(iea_pol)) %>%
  ungroup() %>%
  group_by(COU) %>%
  mutate(iea_pol_cum = cumsum(iea_pol)) %>%
  ungroup()

iea_pol[["iea_pol_cum"]][iea_pol[["iea_pol_cum"]] < 0] <- 0
  
iea_pol_cum <- iea_pol %>%
  group_by(COU) %>%
  mutate(iea_pol_cum_gr = ifelse(iea_pol_cum != 0 & lag(iea_pol_cum) != 0, (iea_pol_cum - lag(iea_pol_cum))/lag(iea_pol_cum), NA)) %>%
  ungroup() %>%
  select("COUyear", "iea_pol_cum", "iea_pol_cum_gr")


save(iea_pol_cum, file = "iea_pol_cum.RData")
