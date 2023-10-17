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
iea_sel <- iea_sel %>% filter(!is.na(COU) & Year <= 2015 & Status == "In force") %>%
  mutate(COUyear = paste(COU, Year, sep = "_"))
iea_sel <- iea_sel[!duplicated(iea_sel$COUyear), ]
iea_pol <- iea_sel %>% mutate(iea_pol = 1) %>%
  select("COUyear", "iea_pol")

save(iea_pol, file = "iea_pol.RData")
