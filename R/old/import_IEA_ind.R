# Import IEA policy data at the industry level
#install.packages('fuzzyjoin')
library(readxl)
library(dplyr)
library(tidyr)
library(fuzzyjoin)

iea <- read_excel("data/excel/IEAData.xlsx", sheet = "IEA (1)")
iea_ind <- read_excel("data/excel/IEAData.xlsx", sheet = "IEA Targeted Industry")
iea_nace <- read_excel("data/excel/IEAData.xlsx", sheet = "IEA - NACE Map v2")
cw <- read_excel("data/excel/IEAData.xlsx", sheet = "crosswalk")

iea_ind <- iea_ind %>% rename(Sectors = IEA)
iea_nace <- iea_nace %>% rename(Sectors = Industry)


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
iea_sel <- iea_sel %>% filter(!is.na(COU), !is.na(Sectors), Year <= 2015, Status == "In force" | Status == "Ended") %>%
  mutate(COUyear = paste(COU, Year, sep = "_")) %>%
  select(COUyear, COU, Status, Sectors)

#iea_sel <- iea_sel[!duplicated(iea_sel$COUyear), ]
iea_pol <- iea_sel %>%
  mutate(iea_pol_count = ifelse(Status == "In force", 1, -1)) %>%
  group_by(COUyear, COU, Sectors) %>%
  summarize(iea_pol_count = sum(iea_pol_count)) %>%
  ungroup() %>%
  group_by(COU) %>%
  mutate(iea_pol_cum = cumsum(iea_pol_count)) %>%
  ungroup()

iea_pol[["iea_pol_cum"]][iea_pol[["iea_pol_cum"]] < 0] <- 0

iea_pol_cum <- iea_pol %>%
  group_by(COU) %>%
  mutate(iea_pol_cum_gr = ifelse(iea_pol_cum != 0 & lag(iea_pol_cum) != 0, (iea_pol_cum - lag(iea_pol_cum))/lag(iea_pol_cum), NA)) %>%
  ungroup() %>%
  select("COUyear", "Sectors", "iea_pol_cum", "iea_pol_cum_gr")

iea_pol_ind <- stringdist_join(iea_pol_cum, iea_ind, by = "Sectors", mode = "left", ignore_case = TRUE, method = "soundex")

iea_pol_ind <- iea_pol_ind %>% select(-c(Sectors.x, Sectors.y)) %>%
  rename(Sectors = Industry)

iea_pol_ind <- left_join(iea_pol_ind, iea_nace, by = "Sectors")
iea_pol_ind <- iea_pol_ind %>% 
  group_by(COUyear) %>%
  filter(!duplicated(Mapping)) %>%
  ungroup() %>%
  rename(NACE = Mapping)
  
iea_pol_ind <- left_join(iea_pol_ind, cw, by = "NACE")
iea_pol_ind <- iea_pol_ind %>% filter(!is.na(ISIC)) %>%
  mutate(COUyearind = paste(COUyear, ISIC, sep = "_")) %>%
  select(-c(NACE, COUyear))

save(iea_pol_ind, file = "data/rdata/iea_pol_ind.Rdata")
## Tests to solve the problem ####

a <- iea_pol_ind %>% select(Sectors.x, Sectors.y) %>%
  filter(is.na(Sectors.y))

b <- a %>% select(Sectors.x) %>%
  filter(!duplicated(Sectors.x))

#save(iea_pol_cum, file = "data/rdata/iea_ind_cum.RData")


